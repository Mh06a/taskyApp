import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/domain/entities/task.dart';

abstract final class AppNavigator {
  static Future<void> openTaskDetails(BuildContext context, String taskId) {
    return Navigator.of(context).pushNamed(
      AppRoutes.taskDetails,
      arguments: taskId,
    );
  }

  static Future<void> openTaskForm(BuildContext context, [Task? task]) {
    return Navigator.of(context).pushNamed(
      AppRoutes.taskForm,
      arguments: task,
    );
  }
}
