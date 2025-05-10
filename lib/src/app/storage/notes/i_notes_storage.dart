abstract class INotesStorage {
  bool getIsFirstRun();

  Future<void> setIsFirstRun({required bool value});
}
