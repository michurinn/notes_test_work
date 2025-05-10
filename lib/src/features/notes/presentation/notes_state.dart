import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';
import 'package:notes_test_work/src/shared/failure.dart';

sealed class NotesState<T extends List<NoteEntity>,
    E extends Failure> {
   abstract final T? data;
  abstract final E? failure;

  factory NotesState.loading() => LoadingNotessState<T, E>();
  factory NotesState.data(T data) => LoadedNotesState(data: data);
  factory NotesState.error(E f) => ErrorNotessState(failure: f);
}

final class LoadingNotessState<T extends List<NoteEntity>,
    E extends Failure> implements NotesState<T, E> {
  @override
  T? get data => null;

  @override
  E? get failure => null;
}

final class LoadedNotesState<T extends List<NoteEntity>,
    E extends Failure> implements NotesState<T, E> {
  @override
  final T data;

  LoadedNotesState({required this.data});

  @override
  E? get failure => null;
}

final class ErrorNotessState<T extends List<NoteEntity>,
    E extends Failure> implements NotesState<T, E> {
  @override
  final E failure;

  ErrorNotessState({required this.failure});

  @override
  T? get data => null;
}
