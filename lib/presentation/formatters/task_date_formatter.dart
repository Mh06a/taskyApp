import 'package:intl/intl.dart';
import 'package:tasky/core/extensions/date_extensions.dart';


abstract final class TaskDateFormatter {
  static String formatHeaderDate(DateTime date, {required String locale}) {
    return DateFormat('EEEE, MMMM d', locale).format(date);
  }

  static String formatDueDate(
    DateTime date, {
    required String locale,
    required DateTime now,
  }) {
    final today = now.dateOnly;
    final dueDate = date.dateOnly;

    if (dueDate == today) return 'Today';

    if (dueDate == today.add(const Duration(days: 1))) return 'Tomorrow';

    if (dueDate == today.subtract(const Duration(days: 1))) return 'Yesterday';

    return DateFormat('MMM d', locale).format(date);
  }

  static String formatDueTime(DateTime date, {required String locale}) {
    return DateFormat('h:mm a', locale).format(date);
  }

  static String formatDueDateTime(
    DateTime date, {
    required bool hasDueTime,
    required String locale,
    required DateTime now,
  }) {
    final dateLabel = formatDueDate(date, locale: locale, now: now);

    if (!hasDueTime) return dateLabel;

    return '$dateLabel, ${formatDueTime(date, locale: locale)}';
  }
}
