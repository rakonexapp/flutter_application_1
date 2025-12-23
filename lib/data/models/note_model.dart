import 'dart:convert';
import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    super.id,
    required super.title,
    required super.content,
    required super.color,
    required super.createdAt,
    required super.updatedAt,
    super.isPinned,
    super.labels,
    super.isArchived,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      color: json['color'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPinned: (json['isPinned'] as int?) == 1,
      labels: json['labels'] != null
          ? List<String>.from(jsonDecode(json['labels'] as String))
          : [],
      isArchived: (json['isArchived'] as int?) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned ? 1 : 0,
      'labels': jsonEncode(labels),
      'isArchived': isArchived ? 1 : 0,
    };
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      color: note.color,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      isPinned: note.isPinned,
      labels: note.labels,
      isArchived: note.isArchived,
    );
  }
}
