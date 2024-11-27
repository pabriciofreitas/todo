import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/domain/entities/entities.dart';
import 'package:to_do/presentation/presentations/to_do/provider_to_do_presenter.dart';
import 'package:to_do/ui/components/to_do/filter_to_do.dart';

import '../../../shared/shared.dart';
import 'to_do_presenter.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({
    super.key,
  });

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

TaskEntity? taskEntityEdit;

class _ToDoListPageState extends State<ToDoListPage> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<ProviderToDoPresenter>();
    presenter.getListTask();
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: presenter.openDraggableScrollableSheet
            ? null
            : FloatingActionButton(
                onPressed: () {
                  taskEntityEdit = null;
                  presenter.openDra(true);
                  textEditingController.clear();
                },
                child: const Icon(Icons.add),
              ),
        backgroundColor: Colors.grey[60],
        appBar: AppBar(
          titleSpacing: 0,
          title: FilterToDo(
            onChange: (filter) async {
              await presenter.changeFilterTask(filter);
            },
          ),
        ),
        body: Stack(
          children: [
            presenter.listTask.isEmpty
                ? const Center(
                    child: Text(
                      "No tasks",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Center(
                        child: Text(
                          'TASKS',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.separated(
                          itemCount: context
                              .watch<ProviderToDoPresenter>()
                              .listTask
                              .length,
                          separatorBuilder: (context, index) =>
                              Container(height: size.height * 0.02),
                          itemBuilder: (context, index) => Dismissible(
                            // onDismissed: (direction) async {
                            //   if (DismissDirection.startToEnd == direction) {

                            //   }
                            // },
                            confirmDismiss: (DismissDirection direction) async {
                              if (DismissDirection.startToEnd == direction) {
                                return await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Icon(
                                        Icons.warning,
                                        size: size.width * .1,
                                      ),
                                      content: const Text(
                                        "Do you really want to delete?",
                                        textAlign: TextAlign.center,
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text("No")),
                                            TextButton(
                                              onPressed: () async {
                                                await presenter.removeTask(
                                                  presenter.listTask[index].id!,
                                                );
                                                Navigator.of(context).pop(true);
                                              },
                                              child: const Text("Yes"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                taskEntityEdit =
                                    presenter.listTask[index]; //  editar
                                textEditingController.text =
                                    taskEntityEdit!.title;
                                presenter.openDra(true);
                              }
                              return false;
                            },
                            key: Key("${presenter.listTask[index].id}"),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              color: Colors.red,
                              child: Align(
                                alignment: const Alignment(-0.9, 0),
                                child: Icon(
                                  Icons.delete,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Theme.of(context).primaryColor,
                              child: const Align(
                                alignment: Alignment(0.9, 0),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            child: Container(
                              color: Colors.grey[200],
                              child: ListTile(
                                title: Text(
                                  presenter.listTask[index].title,
                                ),
                                leading: Icon(
                                    color: presenter.listTask[index].isCheck
                                        ? Theme.of(context).primaryColor
                                        : Colors.black45,
                                    presenter.listTask[index].isCheck
                                        ? Icons.check_circle
                                        : Icons.info),
                                trailing: Checkbox(
                                  value: presenter.listTask[index].isCheck,
                                  onChanged: (value) async {
                                    await presenter.editTask(
                                        presenter.listTask[index].copyWith(
                                            isCheck: !presenter
                                                .listTask[index].isCheck));
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            if (presenter.openDraggableScrollableSheet)
              DraggableScrollableSheet(
                // initialChildSize: 0.3,
                builder: (context, scrollController) {
                  return Container(
                    color: Colors.grey[200],
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            CustomTextFieldWidget(
                              labelText: "New task",
                              controller: textEditingController,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 16),
                              width: size.width,
                              height: 65,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    elevation: 5,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero)),
                                onPressed: () async {
                                  if (textEditingController.text.isNotEmpty) {
                                    if (taskEntityEdit != null) {
                                      await presenter.editTask(
                                        taskEntityEdit!.copyWith(
                                            title: textEditingController.text),
                                      );

                                      textEditingController.clear();
                                      presenter.openDra(false);
                                      taskEntityEdit = null;
                                    } else {
                                      await presenter.addTask(
                                        TaskEntity(
                                          title: textEditingController.text,
                                        ),
                                      );
                                      textEditingController.clear();
                                      presenter.openDra(false);
                                    }
                                  }
                                },
                                child: const Text("Save",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 16),
                              width: size.width,
                              height: 65,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    elevation: 5,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero)),
                                onPressed: () {
                                  presenter.openDra(false);
                                },
                                child: const Text("Cancel",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}
