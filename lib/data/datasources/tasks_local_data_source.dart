import 'package:tasky/data/models/task_model.dart';

abstract interface class TasksLocalDataSource {
  Future<List<TaskModel>> getTasks();

  /// Replaces a task that has the same id, so adding twice is harmless.
  Future<void> insertTask(TaskModel task);

  /// Returns `false` when no task has this id.
  Future<bool> updateTask(TaskModel task);

  Future<void> deleteTask(String id);

  Future<void> deleteAllTasks();
}
