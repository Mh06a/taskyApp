import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/entities/task_stats.dart';

final class GetTaskStats {
  const GetTaskStats();

  TaskStats call(List<Task> tasks, DateTime now) {
    return TaskStats(
      total: tasks.length,
      done: tasks.where((task) => task.isDone).length,
      overdue: tasks.where((task) => task.isOverdue(now)).length,
    );
  }
}
