import 'package:notes_test_work/src/app/mwwm/widget_model_factory.dart';
import 'package:notes_test_work/src/app/mwwm/wm_params.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_widget.dart';
import 'package:notes_test_work/src/shared/wm.dart';
import 'package:flutter/widgets.dart';

class NotesAppElement extends ComponentElement {
  NotesAppElement(super.widget, {required this.wmfactory, this.params});
  final WidgetModelFactory wmfactory;
  final WmParams? params;
  late final Wm _wm;
  bool isPerformed = false;

  @override
  void performRebuild() {
    if (!isPerformed) {
      _wm = wmfactory(this)
        ..initWm(params)
        ..element = this;
    }
    super.performRebuild();
  }

  @override
  void unmount() {
    super.unmount();

    _wm.disposeWm();
  }

  @override
  void deactivate() {
    _wm.deactivate();
    super.deactivate();
  }

  @override
  void reassemble() {
    _wm.reassemble();
    super.reassemble();
  }

  @override
  Widget build() {
    return (widget as Buildable<Wm>).build(_wm);
  }
}
