import 'package:tasky/core/constants/database_constants.dart';
import 'package:tasky/core/enums/priority.dart';
import 'package:tasky/core/extensions/enum_extensions.dart';
import 'package:tasky/domain/entities/task.dart';

final class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.title,
    required super.createdAt,
    super.description,
    super.priority,
    super.dueDate,
    super.hasDueTime,
    super.completedAt,
  });

  factory TaskModel.fromEntity(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      dueDate: task.dueDate,
      hasDueTime: task.hasDueTime,
      createdAt: task.createdAt,
      completedAt: task.completedAt,
    );
  }

  factory TaskModel.fromMap(Map<String, Object?> map) {
    final dueDate = _dateFrom(map[TasksTable.dueDate]);
    return TaskModel(
      id: map[TasksTable.id] as String,
      title: map[TasksTable.title] as String,
      description: map[TasksTable.description] as String? ?? '',
      priority: Priority.values.parse(
        map[TasksTable.priority] as String?,
        orElse: Priority.normal,
      ),
      dueDate: dueDate,
      hasDueTime: dueDate != null && map[TasksTable.hasDueTime] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map[TasksTable.createdAt] as int,
      ),
      completedAt: _dateFrom(map[TasksTable.completedAt]),
    );
  }

  Map<String, Object?> toMap() {
    return {
      TasksTable.id: id,
      TasksTable.title: title,
      TasksTable.description: description,
      TasksTable.priority: priority.name,
      TasksTable.dueDate: dueDate?.millisecondsSinceEpoch,
      TasksTable.hasDueTime: hasDueTime ? 1 : 0,
      TasksTable.createdAt: createdAt.millisecondsSinceEpoch,
      TasksTable.completedAt: completedAt?.millisecondsSinceEpoch,
    };
  }

  static DateTime? _dateFrom(Object? milliseconds) {
    if (milliseconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds as int);
  }
}
