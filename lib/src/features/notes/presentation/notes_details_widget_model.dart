import 'package:notes_test_work/src/app/common/app_scope/app_scope.dart';
import 'package:notes_test_work/src/app/mwwm/wm_params.dart';
import 'package:notes_test_work/src/app/routing/coordinator.dart';
import 'package:notes_test_work/src/database/dto/note_dto.dart';
import 'package:notes_test_work/src/database/dto/note_patch_dto.dart';
import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_details_state.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_model.dart';
import 'package:notes_test_work/src/shared/extensions/hardcoded.dart';
import 'package:notes_test_work/src/shared/scaffold_message_wrapper.dart';
import 'package:notes_test_work/src/shared/wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesDetailsWidgetModel<M extends NotesModel> extends Wm {
  final M model;
  final ScaffoldMessengerWrapper scaffoldMessengerWrapper;
  final Coordinator coordinator;

  /// True if the note already exist
  NoteEntity? initialNote;
  late final ValueNotifier<NotesDetailsState> stateNotifier = ValueNotifier(
    NotesDetailsState.loading(),
  );

  final TextEditingController titleEditingController = TextEditingController();
  final TextEditingController bodyEditingController = TextEditingController();

  @override
  initWm([WmParams? params]) {
    if (params != null && params.params.isNotEmpty) {
      initialNote =
          params.params.first is NoteEntity ? params.params.first : null;
      titleEditingController.text = params.params.first!.title;
      bodyEditingController.text = params.params.first?.body;
    }
  }

  @override
  disposeWm() {
    titleEditingController.dispose();
    bodyEditingController.dispose();
    stateNotifier.dispose();
  }

  void addOrPatchNote() {
    if (titleEditingController.text.isEmpty) {
      scaffoldMessengerWrapper.showSnackBar(
          context, 'Заголовок не может быть пустым'.hardcoded);
      return;
    }

    try {
      if (initialNote != null) {
        model.patchNote(
          initialNote!.id,
          NotePatchDto(
              title: titleEditingController.text,
              body: bodyEditingController.text),
        );
      } else {
        model.addNote(
          NoteDto(
              title: titleEditingController.text,
              body: bodyEditingController.text),
        );
      }
    } on Exception catch (e) {
      scaffoldMessengerWrapper.showSnackBar(
        context,
        e.toString(),
      );
    }

    stateNotifier.value = NotesDetailsState.success(true);
    coordinator.pop();
  }

  NotesDetailsWidgetModel({
    required this.model,
    required this.scaffoldMessengerWrapper,
    required this.coordinator,
  });

  @override
  void deactivate() {}

  @override
  void reassemble() {}
}

NotesDetailsWidgetModel createNotesDetailsWidgetModel(
  BuildContext context,
) {
  return context.read<IAppScope>().createNotesDetailsWidgetModel();
}
