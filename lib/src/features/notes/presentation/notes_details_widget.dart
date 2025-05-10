import 'package:notes_test_work/src/app/mwwm/notes_app_element.dart';
import 'package:notes_test_work/src/app/mwwm/widget_model_factory.dart';
import 'package:notes_test_work/src/app/mwwm/wm_params.dart';
import 'package:notes_test_work/src/features/notes/domain/entity/note_entity.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_details_widget_model.dart';
import 'package:flutter/material.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_widget.dart';
import 'package:notes_test_work/src/shared/extensions/hardcoded.dart';

class NotesDetailsWidget<T extends NotesDetailsWidgetModel> extends Widget
    implements Buildable<NotesDetailsWidgetModel> {
  final WidgetModelFactory wm;
  final NoteEntity? initialNote;
  const NotesDetailsWidget({
    super.key,
    this.initialNote,
    this.wm = createNotesDetailsWidgetModel,
  });
  @override
  Element createElement() => NotesAppElement(
        this,
        wmfactory: wm,
        params: initialNote == null
            ? null
            : WmParams<NoteEntity>(params: [initialNote!]),
      );

  @override
  Widget build(NotesDetailsWidgetModel wm) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: wm.coordinator.pop,
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(
                height: 75,
              ),
            ],
          )),
      body: _FormBody(
        bodyEditingController: wm.bodyEditingController,
        titleEditingController: wm.titleEditingController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          wm.addOrPatchNote();
        },
        child: Text('Записать'.hardcoded),
      ),
    );
  }
}

class _FormBody extends StatefulWidget {
  const _FormBody({
    super.key,
    required this.titleEditingController,
    required this.bodyEditingController,
  });
  final TextEditingController titleEditingController;
  final TextEditingController bodyEditingController;
  @override
  State<_FormBody> createState() => __FormBodyState();
}

class __FormBodyState extends State<_FormBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox.square(
              dimension: 25,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text('Заголовок'.hardcoded)),
              maxLength: 100,
              controller: widget.titleEditingController,
              validator: (value) => value?.isNotEmpty == true
                  ? null
                  : 'Заголовок заметки не может быть пустым'.hardcoded,
            ),
            TextFormField(
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text('Запись'.hardcoded)),
              maxLength: 200,
              minLines: 10,
              maxLines: 10,
              controller: widget.bodyEditingController,
            )
          ],
        ),
      ),
    );
  }
}
