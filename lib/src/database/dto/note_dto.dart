import 'package:flutter/material.dart';
import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';

@immutable
class NoteDto {
  final String body;
  final String title;

  const NoteDto({required this.body, required this.title});

  factory NoteDto.fromEntity(NoteEntity source) {
    return NoteDto(
      title: source.title,
      body: source.body,
    );
  }

  @override
  int get hashCode => Object.hashAll([title, body]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            (other as NoteDto).title == title &&
            (other).body == body);
  }
}
