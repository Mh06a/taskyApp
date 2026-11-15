abstract final class DatabaseConstants {
  static const String name = 'tasky.db';
  static const int version = 1;
}

abstract final class TasksTable {
  static const String name = 'tasks';
  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
  static const String priority = 'priority';
  static const String dueDate = 'due_date';
  static const String hasDueTime = 'has_due_time';
  static const String createdAt = 'created_at';
  static const String completedAt = 'completed_at';
}
