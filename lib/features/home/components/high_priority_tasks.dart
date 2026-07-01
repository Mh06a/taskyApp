import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_project/features/tasks/high_priority_screen.dart';
import 'package:second_project/core/widgets/custom_check_box.dart';
import 'package:second_project/models/task.dart';
import 'package:second_project/core/themes/theme_controller.dart';

class HighPriorityTasks extends StatelessWidget {
  const HighPriorityTasks({
    super.key,
    required this.tasks,
    required this.onTap,
  });

  //step1 ---- Create vars for class :
  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "High Priority Tasks",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 8),

              ...tasks.where((e) => e.isHighPriority).take(4).map((element) {
                return Row(
                  children: [
                    CustomCheckBox(
                      value: element.isDone,
                      onChanged: (bool? value) {
                        final index = tasks.indexWhere(
                          (e) => e.id == element.id,
                        );
                        onTap(value, index);
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      element.taskName,
                      style: element.isDone
                          ? Theme.of(context).textTheme.headlineSmall
                          : Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                    ),
                  ],
                );
              }),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HighPriorityScreen();
                  },
                ),
              );
            },
            child: Container(
              height: 56,
              width: 48,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/icons/higher_arrow_iocn.svg",
                height: 10,
                width: 10,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.secondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
