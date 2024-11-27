import '../../domain/entities/entities.dart';

abstract class ToDoListRepository {
  Future<TaskEntity> addTask(TaskEntity task);
  Future<List<TaskEntity>> getListTask();
  Future<void> removeTask(int id);
  Future<void> editTask(TaskEntity task);
}
