import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/task.dart';

abstract interface class TasksRepository {
  Future<Result<List<Task>>> getTasks();

  Future<Result<void>> addTask(Task task);

  /// Fails with `NotFoundFailure` if the task does not exist.
  Future<Result<void>> updateTask(Task task);

  /// Succeeds even if the task is already gone.
  Future<Result<void>> deleteTask(String id);

  Future<Result<void>> deleteAllTasks();
}
