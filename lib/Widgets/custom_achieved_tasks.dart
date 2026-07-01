import 'dart:math';

import 'package:flutter/material.dart';
import 'package:second_project/themes/theme_controller.dart';

// ignore: must_be_immutable
class CustomAchievedTasks extends StatelessWidget {
  CustomAchievedTasks({
    super.key,
    required this.totalTask,
    required this.doneTask,
    required this.percent,
  });

  //step1 ---- Create vars for class :
  int totalTask = 0;
  int doneTask = 0;
  double percent = 0;

  //step2 ---- Create The page :
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeController.isDark()
              ? Colors.transparent
              : Theme.of(context).colorScheme.outline,
          width: 1.5,
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
                "$doneTask out of $totalTask Done",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14,
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
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(
                    value: percent,
                    backgroundColor: Theme.of(context).colorScheme.outline,
                    valueColor: AlwaysStoppedAnimation(Color(0XFF15B86C)),
                    strokeWidth: 3,
                  ),
                ),
              ),
              Text(
                "${((percent * 100).toInt())} %",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
