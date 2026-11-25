import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/domain/entities/task.dart';

void main() {
  group('Task.copyWith sentinels', () {
    final now = DateTime(2025, 1, 1);
    final due = DateTime(2025, 1, 2);

    test('preserves values when sentinels are not passed', () {
      final task = Task(
        id: '1',
        title: 'Title',
        createdAt: now,
        dueDate: due,
        hasDueTime: true,
        completedAt: now,
      );

      final updated = task.copyWith(title: 'New Title');
      expect(updated.title, 'New Title');
      expect(updated.dueDate, due);
      expect(updated.hasDueTime, true);
      expect(updated.completedAt, now);
    });

    test('allows setting dueDate, hasDueTime, and completedAt to null explicitly', () {
      final task = Task(
        id: '1',
        title: 'Title',
        createdAt: now,
        dueDate: due,
        hasDueTime: true,
        completedAt: now,
      );

      final updated = task.copyWith(
        dueDate: null,
        completedAt: null,
      );

      expect(updated.dueDate, isNull);
      expect(updated.hasDueTime, false);
      expect(updated.completedAt, isNull);
    });
  });
}
