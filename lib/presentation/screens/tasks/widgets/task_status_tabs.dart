import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/enums/task_status_filter.dart';

class TaskStatusTabs extends StatelessWidget {
  const TaskStatusTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final TaskStatusFilter selected;
  final ValueChanged<TaskStatusFilter> onChanged;

  static const _items = [
    (TaskStatusFilter.all, 'All'),
    (TaskStatusFilter.todo, 'To do'),
    (TaskStatusFilter.done, 'Done'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.s4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.r16),
      ),
      child: Row(
        children: _items.map((item) {
          final isSelected = selected == item.$1;

          return Expanded(
            child: InkWell(
              onTap: () => onChanged(item.$1),
              borderRadius: BorderRadius.circular(AppSizes.r12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(
                  vertical: AppSizes.s16,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.surface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.r12),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                      blurRadius: AppSizes.s8,
                    ),
                  ]
                      : null,
                ),
                child: Text(
                  item.$2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}