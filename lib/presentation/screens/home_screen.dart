import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../domain/entities/note.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/note_state.dart';
import '../widgets/empty_notes_widget.dart';
import '../widgets/note_card.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(LoadNotes());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Note> _filterNotes(List<Note> notes) {
    // Filter out archived notes
    var filteredNotes = notes.where((note) => !note.isArchived).toList();

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredNotes = filteredNotes.where((note) {
        return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Sort: pinned notes first
    filteredNotes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.updatedAt.compareTo(a.updatedAt);
    });

    return filteredNotes;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: _buildAppBar(context),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          } else if (state is NoteLoaded) {
            final filteredNotes = _filterNotes(state.notes);
            if (filteredNotes.isEmpty) {
              return const EmptyNotesWidget();
            }
            return _buildNotesView(filteredNotes);
          } else if (state is NoteError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }
          return const EmptyNotesWidget();
        },
      ),
      floatingActionButton:
          FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NoteDetailScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('New Note'),
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 300.ms)
              .scale(
                delay: 300.ms,
                duration: 300.ms,
                curve: Curves.easeOutBack,
              ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.lightbulb_outline),
            selectedIcon: Icon(Icons.lightbulb),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
          NavigationDestination(
            icon: Icon(Icons.archive_outlined),
            selectedIcon: Icon(Icons.archive),
            label: 'Archive',
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: _searchQuery.isEmpty ? const Text('Notes') : null,
      leading: _searchQuery.isEmpty
          ? IconButton(icon: const Icon(Icons.menu), onPressed: () {})
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            ),
      actions: [
        if (_searchQuery.isEmpty) ...[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _searchQuery = ' '; // Trigger search mode
              });
            },
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.view_agenda : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 20,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            onPressed: () {},
          ),
        ] else ...[
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search your notes',
                border: InputBorder.none,
                hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            ),
        ],
      ],
    );
  }

  Widget _buildNotesView(List<Note> notes) {
    if (_isGridView) {
      return _buildGridView(notes);
    } else {
      return _buildListView(notes);
    }
  }

  Widget _buildGridView(List<Note> notes) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteCard(
                note: note,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(note: note),
                    ),
                  );
                },
                onDelete: () {
                  context.read<NoteBloc>().add(DeleteNoteEvent(note.id!));
                },
              )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 30 * index),
                duration: 300.ms,
              )
              .scale(
                begin: const Offset(0.8, 0.8),
                delay: Duration(milliseconds: 30 * index),
                duration: 300.ms,
                curve: Curves.easeOutCubic,
              );
        },
      ),
    );
  }

  Widget _buildListView(List<Note> notes) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child:
              NoteCard(
                    note: note,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailScreen(note: note),
                        ),
                      );
                    },
                    onDelete: () {
                      context.read<NoteBloc>().add(DeleteNoteEvent(note.id!));
                    },
                  )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 30 * index),
                    duration: 300.ms,
                  )
                  .slideX(
                    begin: -0.2,
                    delay: Duration(milliseconds: 30 * index),
                    duration: 300.ms,
                    curve: Curves.easeOutCubic,
                  ),
        );
      },
    );
  }
}
