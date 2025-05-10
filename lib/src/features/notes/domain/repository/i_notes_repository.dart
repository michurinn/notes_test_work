import 'package:notes_test_work/src/database/dto/note_dto.dart';
import 'package:notes_test_work/src/database/dto/note_patch_dto.dart';
import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';

abstract class INotesRepository {
  void addNote(NoteDto note);
  Iterable<NoteEntity> getNotes();
  Stream<Iterable<NoteEntity>> notesStream();
  void patchNote(int id, NotePatchDto patch);
  void deleteNote(int id);
}
