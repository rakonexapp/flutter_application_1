import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_notes.dart';
import '../../domain/usecases/update_note.dart';
import 'note_event.dart';
import 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNotes getNotes;
  final AddNote addNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;

  NoteBloc({
    required this.getNotes,
    required this.addNote,
    required this.updateNote,
    required this.deleteNote,
  }) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final notes = await getNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onAddNote(AddNoteEvent event, Emitter<NoteState> emit) async {
    try {
      await addNote(event.note);
      add(LoadNotes());
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onUpdateNote(
    UpdateNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await updateNote(event.note);
      add(LoadNotes());
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> _onDeleteNote(
    DeleteNoteEvent event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await deleteNote(event.id);
      add(LoadNotes());
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }
}
