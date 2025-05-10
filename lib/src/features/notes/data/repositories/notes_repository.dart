import 'package:notes_test_work/src/database/dto/note_dto.dart';
import 'package:notes_test_work/src/database/dto/note_patch_dto.dart';
import 'package:notes_test_work/src/database/sqlite_database.dart';
import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';
import 'package:notes_test_work/src/features/notes/domain/repository/i_notes_repository.dart';

class NotesRepository implements INotesRepository {
  final SqliteDatabase db;

  NotesRepository({required this.db});
  @override
  void addNote(NoteDto note) {
    db.addNote(note);
  }

  @override
  Stream<Iterable<NoteEntity>> notesStream() {
    return db.getChangesStream();
  }

  @override
  void patchNote(int id,NotePatchDto patch) {
    return db.patchNote(id, patch);
  }

  @override
  Iterable<NoteEntity> getNotes() {
    return db.getNotes();
  }
  
  @override
  void deleteNote(int id) {
    return db.deleteNote(id);
  }
}
