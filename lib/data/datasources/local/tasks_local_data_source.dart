import 'package:tasky/data/models/task_model.dart';

abstract interface class TasksLocalDataSource {
  Future<List<TaskModel>> getTasks();

  Future<void> insertTask(TaskModel task);

  Future<bool> updateTask(TaskModel task);

  Future<void> deleteTask(String id);

  Future<void> deleteAllTasks();
}
