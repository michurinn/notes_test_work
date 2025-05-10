import 'package:notes_test_work/src/app/storage/notes/i_notes_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template first_run_storage.class}
/// Repository for working with first app status.
/// {@endtemplate}
class NotesStorage implements INotesStorage {
  final SharedPreferences _prefs;

  /// Create an instance [NotesStorage].
  /// {@macro first_run_storage.class}
  const NotesStorage(this._prefs);

  @override
  bool getIsFirstRun() {
    return _prefs.getBool(FirstRunStorageKeys.firstRun.keyName) ?? true;
  }

  @override
  Future<void> setIsFirstRun({required bool value}) => _prefs.setBool(FirstRunStorageKeys.firstRun.keyName, value);
}

/// Keys for [NotesStorage].
enum FirstRunStorageKeys {
  /// @nodoc.
  firstRun('first_run');

  /// Key Name.
  final String keyName;

  const FirstRunStorageKeys(this.keyName);
}
