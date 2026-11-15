import 'package:tasky/core/extensions/date_extensions.dart';
import 'package:tasky/core/enums/due_group.dart';
import 'package:tasky/domain/entities/task.dart';

/// Meant for open tasks: it looks only at the due day, not at `isDone`.
final class GroupTasksByDueDate {
  const GroupTasksByDueDate();

  Map<DueGroup, List<Task>> call(List<Task> tasks, DateTime now) {
    final today = now.dateOnly;
    final groups = <DueGroup, List<Task>>{
      for (final group in DueGroup.values) group: <Task>[],
    };

    for (final task in tasks) {
      final due = task.dueDate;
      final group = due == null
          ? DueGroup.noDate
          : _groupFor(due.dateOnly, today);
      groups[group]!.add(task);
    }
    return groups;
  }

  DueGroup _groupFor(DateTime dueDay, DateTime today) {
    if (dueDay.isBefore(today)) return DueGroup.overdue;
    if (dueDay == today) return DueGroup.today;
    return DueGroup.later;
  }
}
