import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/core/enums/priority.dart';
import 'package:tasky/core/enums/task_sort.dart';
import 'package:tasky/core/enums/due_group.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/entities/task_query.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';
import 'package:tasky/domain/usecases/tasks/add_task.dart';
import 'package:tasky/domain/usecases/tasks/update_task.dart';
import 'package:tasky/domain/usecases/tasks/toggle_task_done.dart';
import 'package:tasky/domain/usecases/tasks/filter_and_sort_tasks.dart';
import 'package:tasky/domain/usecases/tasks/get_task_stats.dart';
import 'package:tasky/domain/usecases/tasks/group_tasks_by_due_date.dart';
import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/core/services/id_generator.dart';

class FakeTasksRepository implements TasksRepository {
  List<Task> tasks = [];
  bool shouldFail = false;

  @override
  Future<Result<List<Task>>> getTasks() async => Ok(tasks);

  @override
  Future<Result<void>> addTask(Task task) async {
    if (shouldFail) return Err(StorageFailure());
    tasks.add(task);
    return const Ok(null);
  }

  @override
  Future<Result<void>> updateTask(Task task) async {
    if (shouldFail) return Err(StorageFailure());
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      tasks[index] = task;
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
  Future<Result<void>> deleteAllTasks() async {
    tasks.clear();
    return const Ok(null);
  }
}

class FakeIdGenerator implements IdGenerator {
  int _counter = 0;
  @override
  String generate() => 'id_${++_counter}';
}

void main() {
  group('Task Usecases & Helpers', () {
    final now = DateTime(2025, 1, 10, 12, 0);

    test('FilterAndSortTasks filters and sorts correctly', () {
      const filterSort = FilterAndSortTasks();
      final tasks = [
        Task(id: '1', title: 'Apple', createdAt: now.subtract(const Duration(hours: 1)), priority: Priority.normal),
        Task(id: '2', title: 'Banana', createdAt: now, priority: Priority.high),
      ];

      final filtered = filterSort(tasks, const TaskQuery(searchText: 'ap'));
      expect(filtered.length, 1);
      expect(filtered.first.id, '1');

      final sortedByPriority = filterSort(tasks, const TaskQuery(sort: TaskSort.priority));
      expect(sortedByPriority.first.id, '2');
    });

    test('GetTaskStats calculates correctly', () {
      const getStats = GetTaskStats();
      final tasks = [
        Task(id: '1', title: 'Task 1', createdAt: now, completedAt: now),
        Task(id: '2', title: 'Task 2', createdAt: now, dueDate: now.subtract(const Duration(days: 1))),
      ];

      final stats = getStats(tasks, now);
      expect(stats.total, 2);
      expect(stats.done, 1);
      expect(stats.overdue, 1);
    });

    test('GroupTasksByDueDate groups correctly', () {
      const groupTasks = GroupTasksByDueDate();
      final tasks = [
        Task(id: '1', title: 'No Date', createdAt: now),
        Task(id: '2', title: 'Today', createdAt: now, dueDate: now),
        Task(id: '3', title: 'Overdue', createdAt: now, dueDate: now.subtract(const Duration(days: 2))),
        Task(id: '4', title: 'Later', createdAt: now, dueDate: now.add(const Duration(days: 2))),
      ];

      final groups = groupTasks(tasks, now);
      expect(groups[DueGroup.noDate]?.length, 1);
      expect(groups[DueGroup.today]?.length, 1);
      expect(groups[DueGroup.overdue]?.length, 1);
      expect(groups[DueGroup.later]?.length, 1);
    });

    test('AddTask adds task successfully', () async {
      final repo = FakeTasksRepository();
      final addTask = AddTask(
        repository: repo,
        idGenerator: FakeIdGenerator(),
        clock: () => now,
      );

      final result = await addTask(title: 'New Task');
      expect(result.isOk, true);
      expect(repo.tasks.length, 1);
      expect(repo.tasks.first.title, 'New Task');
    });

    test('UpdateTask updates task successfully', () async {
      final repo = FakeTasksRepository();
      final task = Task(id: '1', title: 'Old', createdAt: now);
      repo.tasks.add(task);

      final updateTask = UpdateTask(repo);
      final result = await updateTask(task.copyWith(title: 'Updated'));
      expect(result.isOk, true);
      expect(repo.tasks.first.title, 'Updated');
    });

    test('ToggleTaskDone toggles status successfully', () async {
      final repo = FakeTasksRepository();
      final task = Task(id: '1', title: 'Task', createdAt: now);
      repo.tasks.add(task);

      final toggle = ToggleTaskDone(repository: repo, clock: () => now);
      final result = await toggle(task);
      expect(result.isOk, true);
      expect(result.valueOrNull?.isDone, true);
    });
  });
}
