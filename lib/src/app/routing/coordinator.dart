import 'package:flutter/material.dart';
import 'package:notes_test_work/src/app/routing/app_coordinates.dart';

class Coordinator extends ChangeNotifier {
  final _coordinates = <AppCoordinate, _Route>{};
  final _pages = <Page<dynamic>>[];

  List<Page<dynamic>> get pages => List.of(_pages);

  void init(
    Map<AppCoordinate, CoordinateBuilder> coordinates,
    AppCoordinate initialCoordinate,
  ) {
    _coordinates.addEntries(
      coordinates.entries.map(
        (entry) => MapEntry(
          entry.key,
          _Route(entry.key.value, entry.value),
        ),
      ),
    );

    final path = _coordinates[initialCoordinate]?.path;
    _pages.add(_buildMaterialPage(null, initialCoordinate, null, path));
  }

  void navigate(
    BuildContext context,
    AppCoordinate target, {
    Object? arguments,
    bool replaceCurrentCoordinate = false,
    bool replaceAllCoordinates = false,
  }) {
    final path = _coordinates[target]?.path;

    if (replaceAllCoordinates) {
      _pages.clear();
    } else if (replaceCurrentCoordinate) {
      _pages.removeLast();
    }
    _pages.add(_buildMaterialPage(context, target, arguments, path));

    debugPrint(_pages.map((e) => e.name).toList().toString());

    notifyListeners();
  }

  void pop() {
    assert(_pages.isNotEmpty);

    _pages.removeLast();

    debugPrint(_pages.map((e) => e.name).toList().toString());

    notifyListeners();
  }

  MaterialPage<void> _buildMaterialPage(
    BuildContext? context,
    AppCoordinate coordinate,
    Object? arguments,
    String? path,
  ) {
    final builder = _coordinates[coordinate]?.builder;

    if (builder == null) {
      throw Exception('Application coordinate {$coordinate} is not registered');
    }

    final body = builder.call(
      context,
      arguments,
    );

    return MaterialPage<void>(
      key: ValueKey(path),
      name: path,
      child: Scaffold(
        body: body,
      ),
      arguments: arguments,
    );
  }
}

class _Route {
  final String path;
  final CoordinateBuilder builder;

  const _Route(this.path, this.builder);
}
