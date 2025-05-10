import 'package:flutter/material.dart';

@immutable
class NoteEntity {
  final int id;
  final String title;
  final String body;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.body,
  });

  factory NoteEntity.fromJson(Map<String, dynamic> json) {
    return NoteEntity(
      id: json['id'],
      title: json['name'],
      body: json['body'],
    );
  }

  @override
  int get hashCode => Object.hashAll([id, title, body]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && (other as NoteEntity).id == id);
  }
}
