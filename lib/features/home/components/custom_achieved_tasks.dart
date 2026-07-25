import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_project/core/constants/app_sizes.dart';
import 'package:second_project/core/themes/theme_controller.dart';
import 'package:second_project/features/tasks/tasks_controller.dart';

// ignore: must_be_immutable
class CustomAchievedTasks extends StatelessWidget {
  const CustomAchievedTasks({super.key});

  //step2 ---- Create The page :
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (BuildContext context, TasksController controller, Widget? child) {
        return Container(
          padding: EdgeInsets.all(AppSizes.w14),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.r20),
            border: Border.all(
              color: ThemeController.isDark()
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.outline,
              width: AppSizes.w2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Achieved Tasks",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "${controller.doneTasks} out of ${controller.totalTask} Done",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: AppSizes.font14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: AlignmentGeometry.center,
                children: [
                  Transform.rotate(
                    angle: -pi / 2,
                    child: SizedBox(
                      height: AppSizes.h48,
                      width: AppSizes.w48,
                      child: CircularProgressIndicator(
                        value: controller.percent,
                        backgroundColor: Theme.of(context).colorScheme.outline,
                        valueColor: AlwaysStoppedAnimation(Color(0XFF15B86C)),
                        strokeWidth: AppSizes.w3,
                      ),
                    ),
                  ),
                  Text(
                    "${((controller.percent * 100).toInt())} %",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppSizes.font14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
