import 'dart:async';
import 'dart:developer';

import 'package:notes_test_work/src/database/dto/note_dto.dart';
import 'package:notes_test_work/src/database/dto/note_patch_dto.dart';
import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as path;
///TODO(me): WIP
final class BehaviorSubject<T> with ChangeNotifier {
  late final StreamSubscription<T> sourceSubs;

  late T value;

  BehaviorSubject({required Stream<T> source, required T initialData}) {
    value = initialData;
    sourceSubs = source.listen(
      (event) => value = event,
    );
  }

  @override
  void dispose() {
    sourceSubs.cancel();
    super.dispose();
  }
}

class SqliteDatabase {
  static String getCurrent() => (path.current);
  late final Database db;
  static String? _databasePath;
  static Future<String> _getDatabasePath() async {
    if (_databasePath != null) return _databasePath!;

    final dir = await getApplicationDocumentsDirectory();
    _databasePath = path.join(dir.path, 'my_app.db');
    return _databasePath!;
  }

  Future<void> init() async {
    // Получение пути к базе
    db = sqlite3.open(await _getDatabasePath());
    db.execute(createTableSQL);
    // Query the sqlite_master system table
    //   final result = db.select('''
    //   SELECT name
    //   FROM sqlite_master
    //   WHERE type = 'table'
    //   AND name NOT LIKE 'sqlite_%'
    // ''');
    final n = getNotes();
    streamController.add(n);
  }

  late final BehaviorSubject<Iterable<NoteEntity>>? changes;
  final StreamController<Iterable<NoteEntity>> streamController =
      StreamController();

  final createTableSQL = '''
  CREATE TABLE IF NOT EXISTS notes (
      id INTEGER PRIMARY KEY,
      title TEXT NOT NULL,
      body TEXT NOT NULL
  );
''';

  void addNote(NoteDto entity) {
    final stmnt = db.prepare(''' INSERT OR IGNORE INTO notes (title, body)
                                VALUES (?, ?)''');
    try {
      stmnt.execute([
        entity.title,
        entity.body,
      ]);
    } on Exception catch (_) {
    } finally {
      stmnt.dispose();
    }
    streamController.add(getNotes());
  }

  void deleteNote(int id) {
    final stmnt = db.prepare(''' DELETE FROM notes WHERE id = ?''');

    try {
      stmnt.execute([id]);
    } on Exception catch (_) {
    } finally {
      stmnt.dispose();
    }
    streamController.add(getNotes());
  }

  Iterable<NoteEntity> getNotes() {
    final resultSet = db.select('''SELECT * FROM notes''');
    final result = resultSet.rows.map(
      (e) => NoteEntity(
        id: e[0] as int,
        title: e[1] as String,
        body: e[2] as String,
      ),
    );
    streamController.add(result);
    return result;
  }

  void patchNote(int id, NotePatchDto patch) {
    final stmntFormatted = patch.getUpdateStatement();
    if (stmntFormatted == null) {
      return;
    }
    final stmnt =
        db.prepare(''' UPDATE notes $stmntFormatted WHERE id = $id''');

    try {
      stmnt.execute(
        patch.getRealParams().toList(),
      );
    } on Exception catch (e) {
      log(e.toString());
       
    } finally {
      stmnt.dispose();
    }
    var f = getNotes();
    streamController.add(getNotes());
  }

  Stream<Iterable<NoteEntity>> getChangesStream() {
    return streamController.stream;
  }
}

extension Up on NotePatchDto {
  String? getUpdateStatement() {
    if (body == null && title == null) {
      return null;
    }

    return 'SET ${title == null ? '' : 'title = ?'} ${title != null && body != null ? ',' : ''} ${body == null ? '' : 'body = ?'} ';
  }

  Iterable<String?> getRealParams() {
    return [title, body]
        .where(
          (element) => element != null,
        )
        .toList();
  }
}
