import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/note.dart';
import '../bloc/note_bloc.dart';
import '../bloc/note_event.dart';
import '../bloc/ai_bloc.dart';
import '../bloc/ai_event.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_assistant_sheet.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;

  const NoteDetailScreen({super.key, this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _selectedColor;
  late bool _isPinned;
  late List<String> _labels;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.note != null;
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    _selectedColor = widget.note?.color ?? AppTheme.noteColors[0].value;
    _isPinned = widget.note?.isPinned ?? false;
    _labels = List.from(widget.note?.labels ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Determines if the background color is light or dark
  bool _isLightColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5;
  }

  /// Gets the appropriate text color based on background
  Color _getTextColor() {
    final backgroundColor = Color(_selectedColor);
    final isLight = _isLightColor(backgroundColor);
    return isLight ? Colors.black87 : Colors.white.withOpacity(0.95);
  }

  /// Gets the appropriate secondary text color
  Color _getSecondaryTextColor() {
    final backgroundColor = Color(_selectedColor);
    final isLight = _isLightColor(backgroundColor);
    return isLight ? Colors.black54 : Colors.white.withOpacity(0.7);
  }

  /// Gets the appropriate icon color
  Color _getIconColor() {
    final backgroundColor = Color(_selectedColor);
    final isLight = _isLightColor(backgroundColor);
    return isLight ? Colors.black54 : Colors.white.withOpacity(0.8);
  }

  void _saveNote() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final now = DateTime.now();
    final note = Note(
      id: widget.note?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      color: _selectedColor,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
      isPinned: _isPinned,
      labels: _labels,
      isArchived: widget.note?.isArchived ?? false,
    );

    if (_isEditing) {
      context.read<NoteBloc>().add(UpdateNoteEvent(note));
    } else {
      context.read<NoteBloc>().add(AddNoteEvent(note));
    }

    Navigator.pop(context);
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildColorPicker(),
    );
  }

  void _showAIAssistant() {
    final content = _contentController.text.isEmpty
        ? _titleController.text
        : '${_titleController.text}\n\n${_contentController.text}';

    if (content.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add some content first to use AI features'),
        ),
      );
      return;
    }

    // Clear previous AI state
    context.read<AIBloc>().add(ClearAISuggestionEvent());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => AIAssistantSheet(
          noteContent: content,
          scrollController: scrollController,
          onApplyText: (newText) {
            setState(() {
              _contentController.text = newText;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor();
    final secondaryTextColor = _getSecondaryTextColor();
    final iconColor = _getIconColor();

    return Scaffold(
      backgroundColor: Color(_selectedColor),
      appBar: AppBar(
        backgroundColor: Color(_selectedColor),
        foregroundColor: iconColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: iconColor,
          onPressed: () {
            _saveNote();
          },
        ),
        actions: [
          IconButton(
                icon: Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                ),
                color: iconColor,
                onPressed: () {
                  setState(() {
                    _isPinned = !_isPinned;
                  });
                },
              )
              .animate(target: _isPinned ? 1 : 0)
              .rotate(begin: 0, end: 0.125, duration: 200.ms),
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            color: iconColor,
            onPressed: () {
              // Archive functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            color: iconColor,
            onPressed: () {
              _showMoreOptions();
            },
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton(
                onPressed: _showAIAssistant,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 300.ms)
              .scale(
                delay: 300.ms,
                duration: 300.ms,
                curve: Curves.easeOutBack,
              ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            TextField(
              controller: _titleController,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(color: secondaryTextColor),
                border: InputBorder.none,
              ),
              maxLines: null,
            ),

            const SizedBox(height: 8),

            // Content
            TextField(
              controller: _contentController,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: textColor, height: 1.6),
              decoration: InputDecoration(
                hintText: 'Note',
                hintStyle: TextStyle(color: secondaryTextColor),
                border: InputBorder.none,
              ),
              maxLines: null,
              minLines: 15,
            ),

            // Labels
            if (_labels.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _labels.map((label) {
                  return Chip(
                    label: Text(label, style: TextStyle(color: textColor)),
                    backgroundColor: Colors.black.withOpacity(0.1),
                    deleteIcon: Icon(Icons.close, size: 18, color: iconColor),
                    onDeleted: () {
                      setState(() {
                        _labels.remove(label);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Color(_selectedColor),
          border: Border(
            top: BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add_box_outlined),
              color: iconColor,
              onPressed: () {},
              tooltip: 'Add item',
            ),
            IconButton(
              icon: const Icon(Icons.palette_outlined),
              color: iconColor,
              onPressed: _showColorPicker,
              tooltip: 'Color',
            ),
            IconButton(
              icon: const Icon(Icons.label_outlined),
              color: iconColor,
              onPressed: () {
                _showLabelDialog();
              },
              tooltip: 'Labels',
            ),
            const Spacer(),
            Text(
              'Edited ${_formatTime(DateTime.now())}',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: secondaryTextColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Color', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppTheme.noteColors.map((color) {
              final isSelected = _selectedColor == color.value;
              final isLight = _isLightColor(color);
              final checkColor = isLight ? Colors.black87 : Colors.white;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color.value;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: checkColor)
                      : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showLabelDialog() {
    final TextEditingController labelController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Label'),
        content: TextField(
          controller: labelController,
          decoration: const InputDecoration(hintText: 'Enter label name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (labelController.text.isNotEmpty) {
                setState(() {
                  _labels.add(labelController.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              if (widget.note != null) {
                context.read<NoteBloc>().add(DeleteNoteEvent(widget.note!.id!));
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.content_copy_outlined),
            title: const Text('Make a copy'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.month}/${time.day}/${time.year}';
  }
}
