import 'package:flutter/material.dart';
import 'package:to_do/ui/components/to_do/filter_to_do.dart';

import '../../../data/local/local.dart';
import '../../../domain/entities/entities.dart';
import '../../../ui/pages/pages.dart';

class ProviderToDoPresenter extends ChangeNotifier
    implements ToDoListPresenter {
  @override
  final List<TaskEntity> listTask = [];

  @override
  bool openDraggableScrollableSheet = false;

  @override
  void openDra(bool value) {
    openDraggableScrollableSheet = value;
    notifyListeners();
  }

  TabFilterToDo filter = TabFilterToDo.allTask;
  final ToDoListRepository repository;
  ProviderToDoPresenter({
    required this.repository,
  });
  @override
  Future<void> addTask(TaskEntity newTask) async {
    final task = await repository.addTask(newTask);
    listTask.insert(0, task);
    notifyListeners();
  }

  @override
  Future<void> changeFilterTask(TabFilterToDo filter) async {
    this.filter = filter;
    await getListTask();
  }

  @override
  Future<void> editTask(TaskEntity task) async {
    await repository.editTask(task);
    final taskIndex = listTask.indexWhere((t) => t.id == task.id);
    listTask.removeAt(taskIndex);
    listTask.insert(taskIndex, task);
    notifyListeners();
  }

  @override
  Future<void> getListTask() async {
    List<TaskEntity> newListTask = await repository.getListTask();
    if (filter == TabFilterToDo.completed) {
      newListTask = newListTask.where((element) => element.isCheck).toList();
    } else if (filter == TabFilterToDo.incompleted) {
      newListTask = newListTask.where((element) => !element.isCheck).toList();
    }
    listTask.clear();
    listTask.addAll(newListTask);
    notifyListeners();
  }

  @override
  removeTask(int id) async {
    await repository.removeTask(id);
    listTask.where((element) => element.id == id);
    notifyListeners();
  }
}
