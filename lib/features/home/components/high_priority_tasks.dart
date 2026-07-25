import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:second_project/core/constants/app_sizes.dart';
import 'package:second_project/features/tasks/high_priority_screen.dart';
import 'package:second_project/core/widgets/custom_check_box.dart';
import 'package:second_project/core/themes/theme_controller.dart';
import 'package:second_project/features/tasks/tasks_controller.dart';

class HighPriorityTasks extends StatelessWidget {
  const HighPriorityTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder: (context, controller, child) {
        final tasksList = controller.tasks;
        return Container(
          padding: EdgeInsets.all(AppSizes.w16),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(AppSizes.w16),
                      child: Text(
                        "High Priority Tasks",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: AppSizes.font14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: AppSizes.h8),

                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          tasksList.reversed
                                  .where((e) => e.isHighPriority)
                                  .length >
                              4
                          ? 4
                          : tasksList.reversed
                                .where((e) => e.isHighPriority)
                                .length,
                      itemBuilder: (BuildContext context, int index) {
                        final task = tasksList.reversed
                            .where((e) => e.isHighPriority)
                            .toList()[index];
                        return Row(
                          children: [
                            CustomCheckBox(
                              value: task.isDone,
                              onChanged: (bool? value) {
                                controller.doneTask(value, task.id);
                              },
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                            Flexible(
                              child: Text(
                                task.taskName,
                                style: task.isDone
                                    ? Theme.of(context).textTheme.headlineSmall
                                    : Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
                  controller.init();
                },
                child: Container(
                  height: AppSizes.h56,
                  width: AppSizes.w48,
                  padding: EdgeInsets.all(AppSizes.w8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: AppSizes.w2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/higher_arrow_iocn.svg",
                    height: AppSizes.h10,
                    width: AppSizes.w10,
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
      },
    );
  }
}
