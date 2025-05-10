import 'package:flutter/material.dart';
import 'package:notes_test_work/src/database/dto/note_dto.dart';
import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_details_widget.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_widget.dart';

typedef CoordinateBuilder = Widget Function(
  BuildContext? context,
  Object? data,
);

class AppCoordinate {
  static const notes = AppCoordinate._('notes');
  static const noteDetails = AppCoordinate._('note_details');
  static const initial = notes;

  final String value;

  const AppCoordinate._(this.value);
}

final Map<AppCoordinate, CoordinateBuilder> appCoordinates = {
  AppCoordinate.notes: (_, __) => const NotesWidget(),
  AppCoordinate.noteDetails: (_, builder) {
    return NotesDetailsWidget(
      initialNote: builder is NoteEntity ? builder : null,
    );
  },
};
