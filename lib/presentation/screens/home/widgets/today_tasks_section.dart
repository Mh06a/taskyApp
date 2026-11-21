import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/widgets/empty_state.dart';
import 'package:tasky/presentation/widgets/section_header.dart';
import 'package:tasky/presentation/widgets/task_card.dart';

class TodayTasksSection extends StatelessWidget {
  const TodayTasksSection({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Today & overdue',
        ),

        SizedBox(height: AppSizes.s8),

        if (tasks.isEmpty)
          const EmptyState(
            title: 'Nothing due today',
            description: 'You can add a task whenever you need.',
          )
        else
          ...tasks.map(
                (task) => TaskCard(
              task: task,
              now: now,
              onTap: () => onTaskTap(task),
              onToggle: () => onTaskToggle(task),
            ),
          ),
      ],
    );
  }
}