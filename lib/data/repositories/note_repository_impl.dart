import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_local_data_source.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl(this.localDataSource);

  @override
  Future<List<Note>> getNotes() async {
    return await localDataSource.getNotes();
  }

  @override
  Future<void> addNote(Note note) async {
    final noteModel = NoteModel.fromEntity(note);
    await localDataSource.insertNote(noteModel);
  }

  @override
  Future<void> updateNote(Note note) async {
    final noteModel = NoteModel.fromEntity(note);
    await localDataSource.updateNote(noteModel);
  }

  @override
  Future<void> deleteNote(String id) async {
    await localDataSource.deleteNote(id);
  }
}
