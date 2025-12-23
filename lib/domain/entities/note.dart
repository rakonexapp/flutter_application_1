import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String? id;
  final String title;
  final String content;
  final int color;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final List<String> labels;
  final bool isArchived;

  const Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.labels = const [],
    this.isArchived = false,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    int? color,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    List<String>? labels,
    bool? isArchived,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      labels: labels ?? this.labels,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    color,
    createdAt,
    updatedAt,
    isPinned,
    labels,
    isArchived,
  ];
}
