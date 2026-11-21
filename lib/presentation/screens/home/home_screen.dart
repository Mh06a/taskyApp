import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/enums/async_status.dart';
import 'package:tasky/core/enums/task_status_filter.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/presentation/formatters/task_date_formatter.dart';
import 'package:tasky/presentation/widgets/task_toggle_action.dart';
import 'package:tasky/presentation/screens/home/widgets/home_header.dart';
import 'package:tasky/presentation/screens/home/widgets/progress_card.dart';
import 'package:tasky/presentation/screens/home/widgets/today_tasks_section.dart';
import 'package:tasky/presentation/widgets/empty_state.dart';
import 'package:tasky/presentation/widgets/section_header.dart';
import 'package:tasky/presentation/widgets/task_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onSeeAllHighPriority});

  final VoidCallback onSeeAllHighPriority;


  void _openDetails(
      BuildContext context,
      Task task,
      ) {
    Navigator.of(context).pushNamed(
      AppRoutes.taskDetails,
      arguments: task.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TasksController, ProfileController>(
      builder: (
          context,
          tasksController,
          profileController,
          child,
          ) {
        final now = tasksController.currentTime;
        final stats = tasksController.todayStatsFor(now);
        final highPriorityTasks = tasksController.highPriorityTasks;
        final todayTasks = tasksController.todayTasksFor(now);

        return Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  tasksController.loadTasks(),
                  profileController.loadProfile(),
                ]);
              },

              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.s20,
                  AppSizes.s16,
                  AppSizes.s20,
                  AppSizes.bottomContentPadding,
                ),

                children: [
                  HomeHeader(
                    name: profileController.displayName,
                    avatarPath:
                    profileController.profile?.avatarPath,
                    date: TaskDateFormatter.formatHeaderDate(now, locale: 'en'),
                    now: now,
                  ),

                  SizedBox(height: AppSizes.s24),

                  ProgressCard(
                    total: stats.total,
                    done: stats.done,
                    percent: stats.percent,
                  ),

                  SizedBox(height: AppSizes.s24),

                  SectionHeader(
                    title: 'High priority',
                    actionText: highPriorityTasks.length > 3 ? 'See all' : null,
                    onAction: highPriorityTasks.length > 3 ? () {
                      tasksController.changeStatus(TaskStatusFilter.todo);
                      tasksController.toggleHighPriorityFilter(true);
                      onSeeAllHighPriority();
                    } : null,
                  ),

                  SizedBox(height: AppSizes.s8),

                  if (tasksController.loadStatus == AsyncStatus.initial ||
                      (tasksController.loadStatus == AsyncStatus.loading && highPriorityTasks.isEmpty && todayTasks.isEmpty))
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else if (highPriorityTasks.isEmpty)
                    const EmptyState(
                      title: 'No high priority tasks',
                      description:
                      'Your important tasks will appear here.',
                    )
                  else
                    ...highPriorityTasks.take(3).map(
                          (task) {
                        return TaskCard(
                          task: task,
                          now: now,
                          onTap: () => _openDetails(
                            context,
                            task,
                          ),
                          onToggle: () => TaskToggleAction.run(context, task),
                        );
                      },
                    ),

                  SizedBox(height: AppSizes.s24),

                  TodayTasksSection(
                    tasks: todayTasks,
                    now: now,
                    onTaskTap: (task) {
                      _openDetails(context, task);
                    },
                    onTaskToggle: (task) {
                      TaskToggleAction.run(context, task);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}