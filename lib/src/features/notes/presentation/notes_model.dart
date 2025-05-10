import 'package:notes_test_work/src/database/dto/note_dto.dart';
import 'package:notes_test_work/src/database/dto/note_patch_dto.dart';
import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';
import 'package:notes_test_work/src/features/notes/domain/repository/i_notes_repository.dart';

class NotesModel {
  final INotesRepository _repository;
  NotesModel({
    required INotesRepository repository,
  }) : _repository = repository;

  Stream<Iterable<NoteEntity>> getChangesStream() {
    return _repository.notesStream();
  }

  void addNote(NoteDto entity) {
    _repository.addNote(entity);
  }

  void patchNote(int id, NotePatchDto patch) {
    return _repository.patchNote(id, patch);
  }

  Iterable<NoteEntity> getNotes() {
    return _repository.getNotes();
  }
  void deleteNode(int id)
  {
    return _repository.deleteNote(id);
  }
}
