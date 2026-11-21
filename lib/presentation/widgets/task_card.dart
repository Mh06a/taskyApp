
import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/formatters/task_date_formatter.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/widgets/priority_chip.dart';
import 'package:tasky/presentation/widgets/task_info_chip.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.now,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final DateTime now;

  String _dueLabel(BuildContext context) {
    final dueDate = task.dueDate;

    if (dueDate == null) {
      return 'No date';
    }

    final locale = Localizations.localeOf(context).languageCode;

    final dateLabel = TaskDateFormatter.formatDueDateTime(
      dueDate,
      hasDueTime: task.hasDueTime,
      locale: locale,
      now: now,
    );

    if (task.isOverdue(now)) {
      return '$dateLabel · Overdue';
    }

    return dateLabel;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDone = task.isDone;

    return Card(
      margin: EdgeInsets.only(
        bottom: AppSizes.s12,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.r20),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.s12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                label: isDone ? 'Mark task as not done' : 'Mark task as done',
                button: true,
                child: Checkbox(
                  value: isDone,
                  onChanged: (_) => onToggle(),
                ),
              ),
              SizedBox(width: AppSizes.s8),
              Expanded(
                child: _buildTaskContent(
                  context,
                  isDone: isDone,
                ),
              ),
              SizedBox(width: AppSizes.s4),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: AppSizes.icon20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskContent(
      BuildContext context, {
        required bool isDone,
      }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            decoration: isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: isDone
                ? theme.colorScheme.onSurfaceVariant
                : theme.colorScheme.onSurface,
          ),
        ),
        if (task.description.isNotEmpty) ...[
          SizedBox(height: AppSizes.s4),
          Text(
            task.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
        ],
        SizedBox(height: AppSizes.s8),
        Wrap(
          spacing: AppSizes.s8,
          runSpacing: AppSizes.s4,
          children: [
            if (task.dueDate != null)
              TaskInfoChip(
                iconPath: AppAssets.dateIcon,
                label: _dueLabel(context),
              ),
            if (task.isHighPriority)
              PriorityChip(
                priority: task.priority,
              ),
          ],
        ),
      ],
    );
  }
}
