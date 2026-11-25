import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/core/enums/async_status.dart';
import 'package:tasky/presentation/controllers/task_action_result.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';
import 'package:tasky/domain/usecases/tasks/add_task.dart';
import 'package:tasky/domain/usecases/tasks/delete_task.dart';
import 'package:tasky/domain/usecases/tasks/filter_and_sort_tasks.dart';
import 'package:tasky/domain/usecases/tasks/get_task_stats.dart';
import 'package:tasky/domain/usecases/tasks/get_tasks.dart';
import 'package:tasky/domain/usecases/tasks/restore_task.dart';
import 'package:tasky/domain/usecases/tasks/toggle_task_done.dart';
import 'package:tasky/domain/usecases/tasks/update_task.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/core/services/id_generator.dart';
import 'package:tasky/core/errors/failure.dart';

class FakeTasksRepository implements TasksRepository {
  List<Task> tasks = [];
  bool fail = false;

  @override
  Future<Result<List<Task>>> getTasks() async {
    if (fail) return Err(StorageFailure());
    return Ok(tasks);
  }

  @override
  Future<Result<void>> addTask(Task task) async {
    tasks.add(task);
    return const Ok(null);
  }

  @override
  Future<Result<void>> updateTask(Task task) async {
    final idx = tasks.indexWhere((t) => t.id == task.id);
    if (idx >= 0) {
      tasks[idx] = task;
      return const Ok(null);
    }
    return Err(NotFoundFailure(task.id));
  }

  @override
  Future<Result<void>> deleteTask(String id) async {
    tasks.removeWhere((t) => t.id == id);
    return const Ok(null);
  }

  @override
  Future<Result<void>> restoreTask(Task task) async {
    tasks.add(task);
    return const Ok(null);
  }

  @override
  Future<Result<void>> deleteAllTasks() async {
    tasks.clear();
    return const Ok(null);
  }
}

class FakeIdGenerator implements IdGenerator {
  int i = 0;
  @override
  String generate() => 'task_${++i}';
}

void main() {
  group('TasksController tests', () {
    final now = DateTime(2025, 1, 1);
    late FakeTasksRepository repo;
    late TasksController controller;

    setUp(() {
      repo = FakeTasksRepository();
      controller = TasksController(
        getTasks: GetTasks(repo),
        addTask: AddTask(repository: repo, idGenerator: FakeIdGenerator(), clock: () => now),
        updateTask: UpdateTask(repo),
        deleteTask: DeleteTask(repo),
        toggleTaskDone: ToggleTaskDone(repository: repo, clock: () => now),
        filterAndSortTasks: const FilterAndSortTasks(),
        getTaskStats: const GetTaskStats(),
        restoreTask: RestoreTask(repo),
        clock: () => now,
      );
    });

    test('loadTasks loads successfully', () async {
      repo.tasks = [Task(id: '1', title: 'Task 1', createdAt: now)];
      await controller.loadTasks();

      expect(controller.loadStatus, AsyncStatus.success);
      expect(controller.tasks.length, 1);
    });

    test('addNewTask adds task and updates list', () async {
      final success = await controller.addNewTask(title: 'New Task');
      expect(success, true);
      expect(controller.tasks.length, 1);
      expect(controller.tasks.first.title, 'New Task');
    });

    test('toggleDone toggles task status', () async {
      final task = Task(id: '1', title: 'Task', createdAt: now);
      repo.tasks = [task];
      await controller.loadTasks();

      final actionResult = await controller.toggleDone(task);
      expect(actionResult, TaskActionResult.success);
      expect(controller.tasks.first.isDone, true);
    });

    test('delete and restore task works', () async {
      final task = Task(id: '1', title: 'Task', createdAt: now);
      repo.tasks = [task];
      await controller.loadTasks();

      await controller.removeTask(task);
      expect(controller.tasks.isEmpty, true);

      await controller.restoreTask(task);
      expect(controller.tasks.length, 1);
    });
  });
}
