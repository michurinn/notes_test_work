import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_test_work/src/app/common/app_scope/app_scope.dart';
import 'package:notes_test_work/src/app/common/di_scope.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  return runZonedGuarded<Future<void>>(
    () async {
      final appScope = await registerAppScope();
      ///WidgetsFlutterBinding.ensureInitialized();
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );

      runApp(
        DiScope<IAppScope>(
          factory: (_) => appScope,
          child: const MyApp(),
        ),
      );
    },
    (exception, stack) {
      // TODO(me): add logging errors to the report system
    },
  );
}
