import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes_test_work/src/app/routing/app_coordinates.dart';
import 'package:notes_test_work/src/app/routing/coordinator.dart';

class NotesRouterDelegate extends RouterDelegate<AppCoordinate>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppCoordinate> {
  final Coordinator coordinator;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  NotesRouterDelegate(this.coordinator)
      : navigatorKey = GlobalKey<NavigatorState>() {
    coordinator.addListener(notifyListeners);
  }

  @override
  void dispose() {
    coordinator.removeListener(notifyListeners);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: coordinator.pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        } else {
          coordinator.pop();

          return true;
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppCoordinate configuration) async {
    // Should be adjusted in case we need to handle outside changes of the path
    return SynchronousFuture(null);
  }
}
