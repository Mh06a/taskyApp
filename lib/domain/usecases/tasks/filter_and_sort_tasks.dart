import 'package:tasky/core/enums/task_sort.dart';
import 'package:tasky/core/enums/task_status_filter.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/entities/task_query.dart';

final class FilterAndSortTasks {
  const FilterAndSortTasks();

  List<Task> call(List<Task> tasks, TaskQuery query) {
    final search = query.searchText.trim().toLowerCase();

    final result = tasks.where((task) {
      final statusMatches = switch (query.status) {
        TaskStatusFilter.all => true,
        TaskStatusFilter.todo => !task.isDone,
        TaskStatusFilter.done => task.isDone,
      };
      if (!statusMatches) return false;

      if (query.onlyHighPriority && !task.isHighPriority) return false;

      if (search.isEmpty) return true;
      return task.title.toLowerCase().contains(search) ||
          task.description.toLowerCase().contains(search);
    }).toList();

    result.sort(_comparatorFor(query.sort));
    return result;
  }

  Comparator<Task> _comparatorFor(TaskSort sort) {
    return switch (sort) {
      TaskSort.newest => _byNewest,
      TaskSort.dueDate => _byDueDate,
      TaskSort.priority => _byPriority,
    };
  }

  // Newest first. The id is the final tie-breaker so the order is always the
  // same, because Dart's List.sort is not guaranteed to be stable.
  int _byNewest(Task a, Task b) {
    final byDate = b.createdAt.compareTo(a.createdAt);
    return byDate != 0 ? byDate : a.id.compareTo(b.id);
  }

  // Earliest due day first; tasks without a due date go last.
  int _byDueDate(Task a, Task b) {
    final dueA = a.dueDate;
    final dueB = b.dueDate;
    if (dueA != null && dueB != null) {
      final dateA = DateTime(dueA.year, dueA.month, dueA.day);
      final dateB = DateTime(dueB.year, dueB.month, dueB.day);
      final byDay = dateA.compareTo(dateB);
      if (byDay != 0) return byDay;
      if (a.hasDueTime && b.hasDueTime) {
        final byTime = dueA.compareTo(dueB);
        if (byTime != 0) return byTime;
      }
    } else if (dueA != null) {
      return -1;
    } else if (dueB != null) {
      return 1;
    }
    return _byNewest(a, b);
  }

  // High priority first, then newest.
  int _byPriority(Task a, Task b) {
    if (a.isHighPriority != b.isHighPriority) {
      return a.isHighPriority ? -1 : 1;
    }
    return _byNewest(a, b);
  }
}
