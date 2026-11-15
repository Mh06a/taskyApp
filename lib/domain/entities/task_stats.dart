final class TaskStats {
  const TaskStats({
    required this.total,
    required this.done,
    required this.overdue,
  });

  final int total;
  final int done;
  final int overdue;

  int get todo => total - done;

  double get percent => total == 0 ? 0.0 : done / total;
}
