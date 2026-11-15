import 'package:tasky/core/utils/result.dart';
import 'package:tasky/core/enums/priority.dart';
import 'package:tasky/core/services/clock.dart';
import 'package:tasky/core/services/id_generator.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';

final class AddTask {
  const AddTask({
    required TasksRepository repository,
    required IdGenerator idGenerator,
    required Clock clock,
  }) : _repository = repository,
       _idGenerator = idGenerator,
       _clock = clock;

  final TasksRepository _repository;
  final IdGenerator _idGenerator;
  final Clock _clock;

  Future<Result<Task>> call({
    required String title,
    String description = '',
    Priority priority = Priority.normal,
    DateTime? dueDate,
    bool hasDueTime = false,
  }) async {
    final cleanTitle = title.trim();
    final cleanDescription = description.trim();

    final error =
        Validators.taskTitle(cleanTitle) ??
        Validators.taskDescription(cleanDescription);
    if (error != null) return Err<Task>(ValidationFailure(error));

    final task = Task(
      id: _idGenerator.generate(),
      title: cleanTitle,
      description: cleanDescription,
      priority: priority,
      dueDate: dueDate,
      hasDueTime: dueDate != null && hasDueTime,
      createdAt: _clock(),
    );

    final saved = await _repository.addTask(task);
    return saved.map((_) => task);
  }
}
