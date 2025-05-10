import 'dart:async';

import 'package:collection/collection.dart';
import 'package:notes_test_work/src/app/common/app_scope/app_scope.dart';
import 'package:notes_test_work/src/app/mwwm/wm_params.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_model.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_state.dart';
import 'package:notes_test_work/src/shared/scaffold_message_wrapper.dart';
import 'package:notes_test_work/src/shared/wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesWidgetModel<M extends NotesModel> extends Wm {
  final M model;
  final ScaffoldMessengerWrapper scaffoldMessengerWrapper;
  final ValueNotifier<NotesState> stateNotifier = ValueNotifier(
    NotesState.loading(),
  );

  StreamSubscription? changesSub;
  @override
  initWm([WmParams? params]) {
    changesSub = model.getChangesStream().listen(
      (event) => stateNotifier.value = NotesState.data(
        event.sorted(
          (a, b) => b.id.compareTo(a.id),
        ),
      ),
      onError: (error) {
        scaffoldMessengerWrapper.showSnackBar(
          context,
          error.toString(),
        );
      },
    );
  }

  @override
  disposeWm() {
    changesSub?.cancel();
    stateNotifier.dispose();
  }

  NotesWidgetModel({
    required this.model,
    required this.scaffoldMessengerWrapper,
  });

  void deleteNote(int id)
  {
    model.deleteNode(id);
  }

  @override
  void deactivate() {}

  @override
  void reassemble() {}
}

NotesWidgetModel createNotesWidgetModel(BuildContext context) {
  return context.read<IAppScope>().createNotesWidgetModel();
}
