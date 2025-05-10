import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notes_test_work/src/app/routing/app_coordinates.dart';

class NotesRouteInformationParser
    extends RouteInformationParser<AppCoordinate> {
  @override
  Future<AppCoordinate> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    // Should be adjusted if need parse outside navigation
    return SynchronousFuture(AppCoordinate.initial);
  }
}
