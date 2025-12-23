import 'data/datasources/database_helper.dart';
import 'data/datasources/note_local_data_source.dart';
import 'data/repositories/note_repository_impl.dart';
import 'data/repositories/gemini_repository.dart';
import 'domain/repositories/note_repository.dart';
import 'domain/usecases/add_note.dart';
import 'domain/usecases/delete_note.dart';
import 'domain/usecases/get_notes.dart';
import 'domain/usecases/update_note.dart';
import 'presentation/bloc/note_bloc.dart';
import 'presentation/bloc/ai_bloc.dart';

class InjectionContainer {
  static late NoteBloc noteBloc;
  static late AIBloc aiBloc;

  static Future<void> init() async {
    // Database
    final databaseHelper = DatabaseHelper.instance;

    // Data sources
    final noteLocalDataSource = NoteLocalDataSourceImpl(databaseHelper);

    // Repositories
    final NoteRepository noteRepository = NoteRepositoryImpl(
      noteLocalDataSource,
    );

    final geminiRepository = GeminiRepository();

    // Use cases
    final getNotes = GetNotes(noteRepository);
    final addNote = AddNote(noteRepository);
    final updateNote = UpdateNote(noteRepository);
    final deleteNote = DeleteNote(noteRepository);

    // BLoCs
    noteBloc = NoteBloc(
      getNotes: getNotes,
      addNote: addNote,
      updateNote: updateNote,
      deleteNote: deleteNote,
    );

    aiBloc = AIBloc(geminiRepository);
  }
}
