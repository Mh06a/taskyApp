import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/enums/priority.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/app/app_navigator.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/presentation/formatters/task_date_formatter.dart';
import 'package:tasky/presentation/screens/tasks/widgets/task_detail_row.dart';
import 'package:tasky/presentation/screens/tasks/widgets/task_status_badge.dart';
import 'package:tasky/presentation/widgets/priority_chip.dart';
import 'package:tasky/presentation/widgets/task_toggle_action.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({
    super.key,
    required this.taskId,
  });

  final String taskId;

  Future<void> _editTask(BuildContext context, Task task) {
    return AppNavigator.openTaskForm(context, task);
  }

  Future<void> _deleteTask(
      BuildContext context,
      TasksController controller,
      Task task,
      ) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final success = await controller.removeTask(task);

    if (!context.mounted) return;

    if (!success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            controller.errorMessage ?? 'Could not delete task.',
          ),
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
            final restored = await controller.restoreTask(task);

            if (!restored) {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Could not restore task.'),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (context, controller, child) {
        final task = controller.findTaskById(taskId);

        if (task == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Task details'),
            ),
            body: Center(
              child: Text(
                controller.isLoading
                    ? 'Loading task...'
                    : 'This task is no longer available.',
              ),
            ),
          );
        }

        return _buildContent(context, controller, task);
      },
    );
  }

  Widget _buildContent(
      BuildContext context,
      TasksController controller,
      Task task,
      ) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final now = controller.currentTime;

    final dueDateText = task.dueDate == null
        ? 'Not set'
        : TaskDateFormatter.formatDueDateTime(
      task.dueDate!,
      hasDueTime: task.hasDueTime,
      locale: locale,
      now: now,
    );

    final createdDateText = TaskDateFormatter.formatHeaderDate(
      task.createdAt,
      locale: locale,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task details'),
        actions: [
          TextButton(
            onPressed: () => _editTask(context, task),
            child: const Text('Edit'),
          ),
          TextButton(
            onPressed: controller.isTaskBusy(task.id)
                ? null
                : () => _deleteTask(context, controller, task),
            child: Text(
              'Delete',
              style: TextStyle(
                color: theme.colorScheme.error,
              ),
            ),
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
                  label: task.isDone ? 'Done' : 'To do',
                  isDone: task.isDone,
                ),
                SizedBox(width: AppSizes.s8),
                if (task.isHighPriority)
                  const PriorityChip(priority: Priority.high),
              ],
            ),
            SizedBox(height: AppSizes.s24),
            Text(
              task.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            SizedBox(height: AppSizes.s12),
            Text(
              task.description.isEmpty
                  ? 'No description added.'
                  : task.description,
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
                    value: dueDateText,
                    icon: AppAssets.dateIcon,
                  ),
                  TaskDetailRow(
                    title: 'Priority',
                    value: task.isHighPriority ? 'High' : 'Normal',
                    icon: AppAssets.flagIcon,
                  ),
                  TaskDetailRow(
                    title: 'Created',
                    value: createdDateText,
                    icon: AppAssets.clockIcon,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.s32),
            FilledButton(
              onPressed: controller.isTaskBusy(task.id)
                  ? null
                  : () => TaskToggleAction.run(context, task),
              child: Text(
                task.isDone ? 'Mark as to do' : 'Mark as done',
              ),
            ),
          ],
        ),
      ),
    );
  }
}