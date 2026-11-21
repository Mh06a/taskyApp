import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_assets.dart';

import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/presentation/screens/tasks/widgets/task_detail_row.dart';
import 'package:tasky/presentation/screens/tasks/widgets/task_status_badge.dart';
import 'package:tasky/presentation/widgets/task_toggle_action.dart';
import 'package:tasky/presentation/widgets/priority_chip.dart';
import 'package:tasky/core/enums/priority.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({
    super.key,
    required this.taskId,
  });

  final String taskId;

  Future<void> _editTask(BuildContext context, Task currentTask) {
    return Navigator.of(context).pushNamed(
      AppRoutes.taskForm,
      arguments: currentTask,
    );
  }

  Future<void> _deleteTask(
    BuildContext context,
    TasksController controller,
    Task currentTask,
  ) async {
    // Captured before pop: the context is gone once this screen closes.
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final success = await controller.removeTask(currentTask);

    if (!success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage ?? 'Could not delete task.'),
        ),
      );
      return;
    }

    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: const Text('Task deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            final restored = await controller.restoreTask(currentTask);

            if (!restored) {
              messenger.showSnackBar(
                const SnackBar(content: Text('Could not restore task.')),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<TasksController>(
      builder: (context, controller, child) {
        Task? currentTask;

        for (final item in controller.tasks) {
          if (item.id == taskId) {
            currentTask = item;
            break;
          }
        }

        if (currentTask == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Task details')),
            body: const Center(
              child: Text('This task is no longer available.'),
            ),
          );
        }

        final current = currentTask;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Task details'),
            actions: [
              IconButton(
                tooltip: 'Edit',
                onPressed: () => _editTask(context, current),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: () => _deleteTask(
                  context,
                  controller,
                  current,
                ),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(AppSizes.s20),
              children: [
                Row(
                  children: [
                    TaskStatusBadge(
                      label: current.isDone ? 'Done' : 'To do',
                      isDone: current.isDone,
                    ),
                    SizedBox(width: AppSizes.s8),
                    if (current.isHighPriority)
                      const PriorityChip(priority: Priority.high),
                  ],
                ),
                SizedBox(height: AppSizes.s24),
                Text(
                  current.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    decoration: current.isDone
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                SizedBox(height: AppSizes.s12),
                Text(
                  current.description.isEmpty
                      ? 'No description added.'
                      : current.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: AppSizes.lineHeightNormal,
                  ),
                ),
                SizedBox(height: AppSizes.s24),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(AppSizes.r16),
                  ),
                  child: Column(
                    children: [
                      TaskDetailRow(
                        title: 'Due',
                        value: _formatDate(context, current.dueDate, hasTime: current.hasDueTime),
                        icon: AppAssets.dateIcon,
                      ),
                      TaskDetailRow(
                        title: 'Priority',
                        value: current.isHighPriority ? 'High' : 'Normal',
                        icon: AppAssets.flagIcon,
                      ),
                      TaskDetailRow(
                        title: 'Created',
                        value: _formatDate(context, current.createdAt),
                        icon: AppAssets.clockIcon,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.s32),
                FilledButton(
                  onPressed: () => TaskToggleAction.run(context, current),
                  child: Text(
                    current.isDone ? 'Mark as to do' : 'Mark as done',
                  ),
                ),
                SizedBox(height: AppSizes.s12),
                OutlinedButton(
                  onPressed: () => _editTask(context, current),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(BuildContext context, DateTime? date, {bool hasTime = false}) {
    if (date == null) return 'Not set';
    final localizations = MaterialLocalizations.of(context);
    final dateText = localizations.formatMediumDate(date);
    if (!hasTime) return dateText;
    return '$dateText · ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(date))}';
  }
}

