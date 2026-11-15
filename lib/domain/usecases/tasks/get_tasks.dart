import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';

final class GetTasks {
  const GetTasks(this._repository);

  final TasksRepository _repository;

  Future<Result<List<Task>>> call() => _repository.getTasks();
}
