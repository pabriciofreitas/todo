import 'dart:convert';

import '../../data/local/to_do_list_repository.dart';
import '../../domain/entities/task_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RespositorySharedPreferesAdapter implements ToDoListRepository {
  static const String _taskKey = 'task_list';

  static final RespositorySharedPreferesAdapter _instance =
      RespositorySharedPreferesAdapter._internal();
  RespositorySharedPreferesAdapter._internal();
  factory RespositorySharedPreferesAdapter() {
    return _instance;
  }

  @override
  Future<List<TaskEntity>> getListTask() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_taskKey) ?? [];

    return tasksJson
        .map((json) => TaskEntity.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<TaskEntity> addTask(TaskEntity task) async {
    final prefs = await SharedPreferences.getInstance();

    final tasks = await getListTask();

    task.id = await generateId();

    tasks.insert(0, task);
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_taskKey, tasksJson);
    return task;
  }

  @override
  Future<void> removeTask(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final tasks = await getListTask();

    tasks.removeWhere((task) => task.id == id);
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_taskKey, tasksJson);
  }

  @override
  Future<void> editTask(TaskEntity updatedTask) async {
    final prefs = await SharedPreferences.getInstance();

    final tasks = await getListTask();

    final taskIndex = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (taskIndex != -1) {
      tasks.removeAt(taskIndex);
      tasks.insert(taskIndex, updatedTask);
      final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
      await prefs.setStringList(_taskKey, tasksJson);
    }
  }

  Future<int> generateId() async {
    final prefs = await SharedPreferences.getInstance();

    final currentId =
        prefs.getInt('last_id') ?? 1; // Pega o ID atual ou inicia em 0
    final newId = currentId + 1;

    // Salva o novo ID no SharedPreferences
    await prefs.setInt('last_id', newId);

    return newId;
  }
}
