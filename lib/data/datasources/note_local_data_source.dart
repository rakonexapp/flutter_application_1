import 'package:sqflite/sqflite.dart';
import '../models/note_model.dart';
import 'database_helper.dart';

abstract class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> insertNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final DatabaseHelper databaseHelper;

  NoteLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<NoteModel>> getNotes() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      orderBy: 'updatedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return NoteModel.fromJson(maps[i]);
    });
  }

  @override
  Future<void> insertNote(NoteModel note) async {
    final db = await databaseHelper.database;
    await db.insert(
      'notes',
      note.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    final db = await databaseHelper.database;
    await db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  @override
  Future<void> deleteNote(String id) async {
    final db = await databaseHelper.database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
