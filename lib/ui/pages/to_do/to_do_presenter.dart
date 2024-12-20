import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';
import '../../components/to_do/filter_to_do.dart';

abstract class ToDoListPresenter extends ChangeNotifier {
  List<TaskEntity> get listTask;
  bool get isLoading;
  bool isEditing();
  Future<void> addTask(TaskEntity newTask);
  void getListTask();
  Future<void> removeTask(int id);
  Future<void> changeFilterTask(TabFilterToDo filter);
  Future<void> editTask(TaskEntity task);
}
