import 'package:notes_test_work/src/app/routing/app_coordinates.dart';
import 'package:notes_test_work/src/app/routing/coordinator.dart';
import 'package:notes_test_work/src/database/sqlite_database.dart';
import 'package:notes_test_work/src/features/notes/data/repositories/notes_repository.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_details_widget_model.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_model.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_widget_model.dart';
import 'package:notes_test_work/src/shared/scaffold_message_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAppScope {
  SharedPreferences get sharedPreferences;
  Coordinator get coordinator;
  SqliteDatabase get database;

  NotesWidgetModel createNotesWidgetModel();
  NotesDetailsWidgetModel createNotesDetailsWidgetModel();
}

class AppScope implements IAppScope {
  final ScaffoldMessengerWrapper scaffoldMessengerWrapper;

  @override
  final Coordinator coordinator;
  @override
  final SharedPreferences sharedPreferences;

  @override
  final SqliteDatabase database;

  @override
  NotesWidgetModel createNotesWidgetModel() {
    return NotesWidgetModel(
      model: NotesModel(
        repository: NotesRepository(db: database),
      ),
      scaffoldMessengerWrapper: scaffoldMessengerWrapper,
    );
  }

  AppScope({
    required this.sharedPreferences,
    required this.database,
    required this.coordinator,
    required this.scaffoldMessengerWrapper,
  });

  @override
  NotesDetailsWidgetModel<NotesModel> createNotesDetailsWidgetModel() {
    return NotesDetailsWidgetModel(
      coordinator: coordinator,
      model: NotesModel(
        repository: NotesRepository(db: database),
      ),
      scaffoldMessengerWrapper: scaffoldMessengerWrapper,
    );
  }
}

Future<IAppScope> registerAppScope() async {
  final db = SqliteDatabase();
  await db.init();
  return AppScope(
    coordinator: Coordinator()..init(appCoordinates, AppCoordinate.initial),
    sharedPreferences: await SharedPreferences.getInstance(),
    database: db,
    scaffoldMessengerWrapper: ScaffoldMessengerWrapper(),
  );
}
