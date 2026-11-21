import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';

class TaskStatusBadge extends StatelessWidget {
  const TaskStatusBadge({super.key, required this.label, required this.isDone});
  final String label;
  final bool isDone;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDone ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;
    return Container(padding: EdgeInsets.symmetric(horizontal: AppSizes.s12, vertical: AppSizes.s8), decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(AppSizes.r12)), child: Text(label, style: theme.textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w600)));
  }
}
