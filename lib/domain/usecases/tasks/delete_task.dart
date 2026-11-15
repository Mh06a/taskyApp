import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';

final class DeleteTask {
  const DeleteTask(this._repository);

  final TasksRepository _repository;

  Future<Result<void>> call(String id) => _repository.deleteTask(id);
}
