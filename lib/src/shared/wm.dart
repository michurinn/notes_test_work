import 'package:flutter/material.dart';
import 'package:notes_test_work/src/app/mwwm/wm_params.dart';

abstract class Wm<W> {
  void initWm([WmParams? params]);
  void disposeWm();
  void deactivate();
  void reassemble();

  BuildContext get context {
    assert(() {
      if (element == null) {
        throw FlutterError('This widget has been unmounted');
      }
      return true;
    }());
    return element!;
  }

  BuildContext? element;
  Widget? widget;
}
