import 'package:tasky/core/utils/result.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';

final class UpdateTask {
  const UpdateTask(this._repository);

  final TasksRepository _repository;

  Future<Result<Task>> call(Task task) async {
    final cleaned = task.copyWith(
      title: task.title.trim(),
      description: task.description.trim(),
    );

    final error =
        Validators.taskTitle(cleaned.title) ??
        Validators.taskDescription(cleaned.description);
    if (error != null) return Err<Task>(ValidationFailure(error));

    final saved = await _repository.updateTask(cleaned);
    return saved.map((_) => cleaned);
  }
}
