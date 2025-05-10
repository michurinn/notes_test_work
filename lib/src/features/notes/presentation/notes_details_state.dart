import 'package:notes_test_work/src/shared/failure.dart';

sealed class NotesDetailsState<T, E extends Failure> {
  abstract final T? data;
  abstract final E? failure;

  factory NotesDetailsState.loading() => LoadingNotessState<T, E>();
  factory NotesDetailsState.success(data) => LoadedNotesState(data: data);
}

final class LoadingNotessState<T, E extends Failure>
    implements NotesDetailsState<T, E> {
  @override
  T? get data => null;

  @override
  E? get failure => null;
}

final class LoadedNotesState<T, E extends Failure>
    implements NotesDetailsState<T, E> {
  @override
  final T data;

  LoadedNotesState({required this.data});

  @override
  E? get failure => null;
}
