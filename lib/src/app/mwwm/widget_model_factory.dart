import 'package:flutter/material.dart';
import 'package:notes_test_work/src/shared/wm.dart';

typedef WidgetModelFactory<T extends Wm> = T Function(
  BuildContext context,
);
