import 'package:tasky/core/utils/result.dart';
import 'package:tasky/core/services/clock.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';

final class ToggleTaskDone {
  const ToggleTaskDone({
    required TasksRepository repository,
    required Clock clock,
  }) : _repository = repository,
       _clock = clock;

  final TasksRepository _repository;
  final Clock _clock;

  Future<Result<Task>> call(Task task) async {
    final updated = task.isDone ? task.markUndone() : task.markDone(_clock());
    final saved = await _repository.updateTask(updated);
    return saved.map((_) => updated);
  }
}
