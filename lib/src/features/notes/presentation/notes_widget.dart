import 'package:notes_test_work/src/app/common/app_scope/app_scope.dart';
import 'package:notes_test_work/src/app/mwwm/notes_app_element.dart';
import 'package:notes_test_work/src/app/mwwm/widget_model_factory.dart';
import 'package:notes_test_work/src/app/routing/app_coordinates.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_state.dart';
import 'package:notes_test_work/src/features/notes/presentation/notes_widget_model.dart';
import 'package:notes_test_work/src/shared/extensions/hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesWidget<T extends NotesWidgetModel> extends Widget
    implements Buildable<NotesWidgetModel> {
  final WidgetModelFactory wm;
  const NotesWidget({
    super.key,
    this.wm = createNotesWidgetModel,
  });
  @override
  Element createElement() => NotesAppElement(
        this,
        wmfactory: wm,
      );

  @override
  Widget build(NotesWidgetModel wm) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes:'.hardcoded),
      ),
      body: ValueListenableBuilder(
        valueListenable: wm.stateNotifier,
        builder: (context, value, child) {
          return switch (value) {
            LoadingNotessState() => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ErrorNotessState(:final failure) => Text(
                failure.description.toString(),
              ),
            LoadedNotesState(:final data) => data.isEmpty
                ? const Center(
                    child: Text('Нажмите + чтобы добавить заметку'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemBuilder: (context, index) => Dismissible(
                        key: ObjectKey(data[index]),
                        onDismissed: (direction) {
                          wm.deleteNote(data[index].id);
                        },
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox.shrink(),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints.tightFor(
                                        height: 40),
                                    child: Text(
                                      data[index].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<IAppScope>()
                                          .coordinator
                                          .navigate(context,
                                              AppCoordinate.noteDetails,
                                              arguments: data[index]);
                                    },
                                    icon: const Icon(
                                      Icons.edit_note,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox.shrink(),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints.tightFor(
                                        height: 100),
                                    child: Text(data[index].body),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      wm.deleteNote(data[index].id);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      separatorBuilder: (_, __) => const SizedBox.shrink(),
                      itemCount: data.length,
                    ),
                  ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          wm.context
              .read<IAppScope>()
              .coordinator
              .navigate(wm.context, AppCoordinate.noteDetails);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

abstract interface class Buildable<T> {
  Widget build(T wm);
}
