import 'package:equatable/equatable.dart';
import 'package:tasky/core/enums/priority.dart';
import 'package:tasky/core/extensions/date_extensions.dart';

class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.description = '',
    this.priority = Priority.normal,
    this.dueDate,
    this.hasDueTime = false,
    this.completedAt,
  }) : assert(dueDate != null || !hasDueTime, 'hasDueTime requires a dueDate');

  final String id;
  final String title;
  final String description;
  final Priority priority;
  final DateTime? dueDate;
  final bool hasDueTime;
  final DateTime createdAt;
  final DateTime? completedAt;

  bool get isDone => completedAt != null;
  bool get isHighPriority => priority == Priority.high;

  bool isOverdue(DateTime now) {
    final due = dueDate;
    if (isDone || due == null) return false;
    return due.dateOnly.isBefore(now.dateOnly);
  }

  bool isDueToday(DateTime now) {
    final due = dueDate;
    if (due == null) return false;
    return due.dateOnly == now.dateOnly;
  }

  static const _unset = Object();

  Task copyWith({
    String? title,
    String? description,
    Priority? priority,
    Object? dueDate = _unset,
    bool? hasDueTime,
    Object? completedAt = _unset,
  }) {
    final newDueDate = identical(dueDate, _unset)
        ? this.dueDate
        : dueDate as DateTime?;

    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: newDueDate,
      hasDueTime: newDueDate == null
          ? false
          : hasDueTime ?? this.hasDueTime,
      createdAt: createdAt,
      completedAt: identical(completedAt, _unset)
          ? this.completedAt
          : completedAt as DateTime?,
    );
  }


  Task markDone(DateTime at) {
    return copyWith(completedAt: at);
  }

  Task markUndone() {
    return copyWith(completedAt: null);
  }
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    priority,
    dueDate,
    hasDueTime,
    createdAt,
    completedAt,
  ];

  @override
  String toString() => 'Task($id, $title, done: $isDone)';
}
