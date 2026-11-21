import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/widgets/empty_state.dart';
import 'package:tasky/presentation/widgets/task_card.dart';

class TaskListSection extends StatelessWidget {
  const TaskListSection({
    super.key,
    required this.tasks,
    required this.onTaskTap,
    required this.onTaskToggle,
    required this.now,
  });

  final List<Task> tasks;
  final ValueChanged<Task> onTaskTap;
  final ValueChanged<Task> onTaskToggle;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: EmptyState(
          title: 'Nothing here yet',
          description: 'Your tasks will appear here.',
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSizes.s20,
        AppSizes.s8,
        AppSizes.s20,
        AppSizes.bottomContentPadding,
      ),
      itemCount: tasks.length,
      separatorBuilder: (_, _) => SizedBox(
        height: AppSizes.s8,
      ),
      itemBuilder: (context, index) {
        final task = tasks[index];

        return TaskCard(
          task: task,
          now: now,
          onTap: () => onTaskTap(task),
          onToggle: () => onTaskToggle(task),
        );
      },
    );
  }
}