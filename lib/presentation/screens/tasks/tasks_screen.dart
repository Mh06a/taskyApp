import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/enums/async_status.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/presentation/screens/tasks/widgets/task_list_section.dart';
import 'package:tasky/presentation/screens/tasks/widgets/task_search_field.dart';
import 'package:tasky/presentation/screens/tasks/widgets/task_status_tabs.dart';
import 'package:tasky/presentation/screens/tasks/widgets/tasks_filter_sheet.dart';
import 'package:tasky/presentation/widgets/task_toggle_action.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});


  void _openDetails(BuildContext context, Task task) {
    Navigator.of(context).pushNamed(
      AppRoutes.taskDetails,
      arguments: task.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<TasksController>(
      builder: (context, controller, child) {
        final tasks = controller.filteredTasks;

        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.s20,
                    AppSizes.s20,
                    AppSizes.s20,
                    AppSizes.s16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your tasks',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: AppSizes.s4),
                      Text(
                        'A little clarity for everything on your mind.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: AppSizes.s20),

                      TaskSearchField(
                        onChanged: controller.search,
                      ),
                      SizedBox(height: AppSizes.s12),

                      TaskStatusTabs(
                        selected: controller.query.status,
                        onChanged: controller.changeStatus,
                      ),
                      SizedBox(height: AppSizes.s12),

                      if (controller.query.onlyHighPriority) ...[
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: InputChip(
                            avatar: const Icon(Icons.flag_outlined),
                            label: const Text('High priority'),
                            onDeleted: () =>
                                controller.toggleHighPriorityFilter(false),
                            deleteButtonTooltipMessage: 'Clear filter',
                          ),
                        ),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${tasks.length} tasks',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Sort and filter',
                            onPressed: () {
                              showTasksFilterSheet(context);
                            },
                            icon: const Icon(Icons.tune_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: controller.loadStatus == AsyncStatus.loading && controller.tasks.isEmpty
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : RefreshIndicator(
                    onRefresh: controller.loadTasks,
                    child: TaskListSection(
                      tasks: tasks,
                      now: controller.currentTime,
                      onTaskTap: (task) {
                        _openDetails(context, task);
                      },
                      onTaskToggle: (task) {
                        TaskToggleAction.run(context, task);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
