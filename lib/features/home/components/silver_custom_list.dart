import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_project/core/components/custom_task_item.dart';
import 'package:second_project/core/constants/app_sizes.dart';
import 'package:second_project/features/tasks/tasks_controller.dart';

class SilverCustomList extends StatelessWidget {
  const SilverCustomList({super.key});

  //step2 ----> here Create The custom list :
  @override
  Widget build(BuildContext context) {
    return Consumer<TasksController>(
      builder:
          (BuildContext context, TasksController controller, Widget? child) {
            return controller.tasks.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        "No Data",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.only(bottom: AppSizes.h30),
                    sliver: SliverList.separated(
                      itemCount: controller.tasks.length,
                      itemBuilder: (context, index) {
                        return CustomTaskItem(
                          model: controller.tasks[index],
                          onChanged: (bool? value) {
                            controller.doneTask(
                              value,
                              controller.tasks[index].id,
                            );
                          },
                          onDelete: (int id) {
                            controller.deleteTask(id);
                          },
                          onEdit: () {
                            controller.init();
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: AppSizes.h8);
                      },
                    ),
                  );
          },
    );
  }
}
