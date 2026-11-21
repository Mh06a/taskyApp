import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';

final class RestoreTask {
  const RestoreTask(this._repository);

  final TasksRepository _repository;

  Future<Result<void>> call(Task deletedTask) {
    return _repository.addTask(deletedTask);
  }
}
