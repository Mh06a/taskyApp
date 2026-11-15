import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/core/utils/guard.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/data/datasources/tasks_local_data_source.dart';
import 'package:tasky/data/models/task_model.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';

final class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl(this._dataSource);

  final TasksLocalDataSource _dataSource;

  @override
  Future<Result<List<Task>>> getTasks() {
    return guard<List<Task>>(_dataSource.getTasks);
  }

  @override
  Future<Result<void>> addTask(Task task) {
    return guard<void>(
      () => _dataSource.insertTask(TaskModel.fromEntity(task)),
    );
  }

  @override
  Future<Result<void>> updateTask(Task task) async {
    final result = await guard<bool>(
      () => _dataSource.updateTask(TaskModel.fromEntity(task)),
    );
    return result.when<Result<void>>(
      ok: (found) =>
          found ? const Ok<void>(null) : Err<void>(NotFoundFailure(task.id)),
      err: Err<void>.new,
    );
  }

  @override
  Future<Result<void>> deleteTask(String id) {
    return guard<void>(() => _dataSource.deleteTask(id));
  }

  @override
  Future<Result<void>> deleteAllTasks() {
    return guard<void>(_dataSource.deleteAllTasks);
  }
}
