import 'package:flutter/foundation.dart';
import 'package:tasky/core/enums/async_status.dart';
import 'package:tasky/core/enums/priority.dart';
import 'package:tasky/core/enums/task_sort.dart';
import 'package:tasky/core/enums/task_status_filter.dart';
import 'package:tasky/core/services/clock.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/entities/task_query.dart';
import 'package:tasky/domain/entities/task_stats.dart';
import 'package:tasky/domain/usecases/tasks/add_task.dart';
import 'package:tasky/domain/usecases/tasks/delete_task.dart';
import 'package:tasky/domain/usecases/tasks/filter_and_sort_tasks.dart';
import 'package:tasky/domain/usecases/tasks/get_tasks.dart';
import 'package:tasky/domain/usecases/tasks/get_task_stats.dart';
import 'package:tasky/domain/usecases/tasks/restore_task.dart';
import 'package:tasky/domain/usecases/tasks/toggle_task_done.dart';
import 'package:tasky/domain/usecases/tasks/update_task.dart';
import 'package:tasky/core/enums/task_action_result.dart';

class TasksController extends ChangeNotifier {
  TasksController({
    required GetTasks getTasks,
    required AddTask addTask,
    required UpdateTask updateTask,
    required DeleteTask deleteTask,
    required ToggleTaskDone toggleTaskDone,
    required FilterAndSortTasks filterAndSortTasks,
    required GetTaskStats getTaskStats,
    required RestoreTask restoreTask,
    Clock clock = DateTime.now,
  }) : _getTasks = getTasks,
       _addTask = addTask,
       _updateTask = updateTask,
       _deleteTask = deleteTask,
       _toggleTaskDone = toggleTaskDone,
       _filterAndSortTasks = filterAndSortTasks,
       _getTaskStats = getTaskStats,
       _restoreTask = restoreTask,
       _clock = clock;

  final GetTasks _getTasks;
  final AddTask _addTask;
  final UpdateTask _updateTask;
  final DeleteTask _deleteTask;
  final ToggleTaskDone _toggleTaskDone;
  final FilterAndSortTasks _filterAndSortTasks;
  final GetTaskStats _getTaskStats;
  final RestoreTask _restoreTask;
  final Clock _clock;
  List<Task> _tasks = <Task>[];
  TaskQuery _query = const TaskQuery();
  AsyncStatus _loadStatus = AsyncStatus.initial;
  String? _errorMessage;

  /// Ids of tasks with a toggle or delete in flight.
  final Set<String> _busyTaskIds = <String>{};

  /// Number of add/update operations in flight.
  int _pendingSaves = 0;

  // State
  List<Task> get tasks => List.unmodifiable(_tasks);
  bool get hasTasks => _tasks.isNotEmpty;
  TaskQuery get query => _query;
  AsyncStatus get loadStatus => _loadStatus;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _loadStatus == AsyncStatus.loading;
  bool get isSaving => _pendingSaves > 0;
  bool isTaskBusy(String id) => _busyTaskIds.contains(id);

  /// The single time source of the presentation layer.
  DateTime get currentTime => _clock();

  // Derived lists
  List<Task> get filteredTasks => _filterAndSortTasks(_tasks, _query);

  List<Task> get highPriorityTasks => _filterAndSortTasks(
    _tasks.where((task) => task.isHighPriority && !task.isDone).toList(),
    const TaskQuery(sort: TaskSort.newest),
  );

  List<Task> get completedTasks => _filterAndSortTasks(
    _tasks.where((task) => task.isDone).toList(),
    const TaskQuery(sort: TaskSort.newest),
  );

  /// Today section contains overdue and today's tasks, excluding items already
  /// displayed in High priority. Overdue tasks are ordered ahead of today's.
  List<Task> get todayTasks => todayTasksFor(_clock());

  List<Task> todayTasksFor(DateTime now) {
    final highPriorityIds = highPriorityTasks.map((task) => task.id).toSet();

    final visible = _tasks.where((task) {
      if (task.isDone || highPriorityIds.contains(task.id)) return false;

      return task.isOverdue(now) || task.isDueToday(now);
    }).toList();

    visible.sort((a, b) => _compareTodayOrder(a, b, now));

    return visible;
  }

  int _compareTodayOrder(Task a, Task b, DateTime now) {
    final aOverdue = a.isOverdue(now);
    final bOverdue = b.isOverdue(now);

    if (aOverdue != bOverdue) return aOverdue ? -1 : 1;

    final dueA = a.dueDate!;
    final dueB = b.dueDate!;
    final dayA = DateTime(dueA.year, dueA.month, dueA.day);
    final dayB = DateTime(dueB.year, dueB.month, dueB.day);

    final byDay = dayA.compareTo(dayB);
    if (byDay != 0) return byDay;

    if (a.hasDueTime && b.hasDueTime) {
      final byTime = dueA.compareTo(dueB);
      if (byTime != 0) return byTime;
    }

    return b.createdAt.compareTo(a.createdAt);
  }

  TaskStats get stats => _getTaskStats(_tasks, _clock());

  TaskStats get todayStats => todayStatsFor(_clock());

  TaskStats todayStatsFor(DateTime now) {
    final todayTasks = _tasks.where((task) => task.isDueToday(now)).toList();

    return _getTaskStats(todayTasks, now);
  }

  // Commands
  Future<void> loadTasks() async {
    final isInitialLoad = _loadStatus == AsyncStatus.initial;

    if (isInitialLoad) {
      _loadStatus = AsyncStatus.loading;
      notifyListeners();
    }

    _errorMessage = null;

    final result = await _getTasks();

    result.when(
      ok: (items) {
        _tasks = List<Task>.of(items, growable: true);
        _loadStatus = AsyncStatus.success;
      },
      err: (failure) {
        debugPrint('Tasks load failed: $failure');
        _loadStatus = AsyncStatus.failure;
        _errorMessage = 'Could not load tasks. Please try again.';
      },
    );

    notifyListeners();
  }

  Future<bool> addNewTask({
    required String title,
    String description = '',
    Priority priority = Priority.normal,
    DateTime? dueDate,
    bool hasDueTime = false,
  }) {
    return _save(
      action: () => _addTask(
        title: title,
        description: description,
        priority: priority,
        dueDate: dueDate,
        hasDueTime: hasDueTime,
      ),
      onSuccess: (task) => _tasks.insert(0, task),
      label: 'Task save',
      failureMessage: 'Could not save task. Please try again.',
    );
  }

  Future<bool> updateExistingTask(Task task) {
    return _save(
      action: () => _updateTask(task),
      onSuccess: _replaceTask,
      label: 'Task update',
      failureMessage: 'Could not update task. Please try again.',
    );
  }

  Future<TaskActionResult> toggleDone(Task task) async {
    if (!_busyTaskIds.add(task.id)) return TaskActionResult.ignored;

    notifyListeners();

    final success = await _perform(
      action: () => _toggleTaskDone(task),
      onSuccess: _replaceTask,
      label: 'Task toggle',
      failureMessage: 'Could not update task status. Please try again.',
    );

    _busyTaskIds.remove(task.id);
    notifyListeners();

    return success ? TaskActionResult.success : TaskActionResult.failed;
  }

  Future<bool> removeTask(Task task) async {
    if (!_busyTaskIds.add(task.id)) return false;

    notifyListeners();

    final success = await _perform(
      action: () => _deleteTask(task.id),
      onSuccess: (_) => _tasks.removeWhere((item) => item.id == task.id),
      label: 'Task delete',
      failureMessage: 'Could not delete task. Please try again.',
    );

    _busyTaskIds.remove(task.id);
    notifyListeners();

    return success;
  }

  Future<bool> restoreTask(Task task) {
    return _perform(
      action: () => _restoreTask(task),
      onSuccess: (_) => _tasks.add(task),
      label: 'Task restore',
      failureMessage: 'Could not restore task. Please try again.',
    );
  }

  // Query
  void search(String value) => _updateQuery(_query.copyWith(searchText: value));

  void changeStatus(TaskStatusFilter status) {
    _updateQuery(_query.copyWith(status: status));
  }

  void changeSort(TaskSort sort) => _updateQuery(_query.copyWith(sort: sort));

  void toggleHighPriorityFilter(bool value) {
    _updateQuery(_query.copyWith(onlyHighPriority: value));
  }

  void resetFilters() => _updateQuery(const TaskQuery());

  void clearLocalTasks() {
    _tasks.clear();
    _updateQuery(const TaskQuery());
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Helpers
  void _updateQuery(TaskQuery query) {
    _query = query;
    notifyListeners();
  }

  void _replaceTask(Task updated) {
    final index = _tasks.indexWhere((item) => item.id == updated.id);

    if (index >= 0) _tasks[index] = updated;
  }

  /// Runs an add/update operation and tracks it in [isSaving].
  Future<bool> _save({
    required Future<Result<Task>> Function() action,
    required void Function(Task task) onSuccess,
    required String label,
    required String failureMessage,
  }) async {
    _pendingSaves++;
    notifyListeners();

    final success = await _perform(
      action: action,
      onSuccess: onSuccess,
      label: label,
      failureMessage: failureMessage,
    );

    _pendingSaves--;
    notifyListeners();

    return success;
  }

  /// Runs [action], applies [onSuccess] to the in-memory list and records a
  /// user-friendly error. Technical details are only logged.
  Future<bool> _perform<T>({
    required Future<Result<T>> Function() action,
    required void Function(T value) onSuccess,
    required String label,
    required String failureMessage,
  }) async {
    _errorMessage = null;

    final result = await action();

    final success = result.when(
      ok: (value) {
        onSuccess(value);
        return true;
      },
      err: (failure) {
        debugPrint('$label failed: $failure');
        _errorMessage = failureMessage;
        return false;
      },
    );

    notifyListeners();

    return success;
  }
}
