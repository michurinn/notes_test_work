import 'package:flutter/material.dart';
import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';
/// Contains the info for putching existing note
@immutable
class NotePatchDto {
  final String? body;
  final String? title;

  const NotePatchDto({this.body, this.title});

  factory NotePatchDto.fromEntity(NoteEntity source) {
    return NotePatchDto(
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
            (other as NotePatchDto).title == title &&
            (other).body == body);
  }
}
