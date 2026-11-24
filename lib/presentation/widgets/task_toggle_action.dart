import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/presentation/controllers/task_action_result.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';

abstract final class TaskToggleAction {
  static Future<void> run(BuildContext context, Task task) async {
    final controller = context.read<TasksController>();
    final messenger = ScaffoldMessenger.of(context);

    final result = await controller.toggleDone(task);

    if (result != TaskActionResult.failed || !messenger.mounted) {
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          controller.errorMessage ?? 'Could not update task.',
        ),
      ),
    );
  }
}
