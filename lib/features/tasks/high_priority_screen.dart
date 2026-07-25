import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_project/core/components/custom_list.dart';
import 'package:second_project/core/constants/app_sizes.dart';
import 'package:second_project/features/tasks/tasks_controller.dart';

class HighPriorityScreen extends StatelessWidget {
  const HighPriorityScreen({super.key});

  //step2 ----> here Create The custom list :
  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
    return Scaffold(
      //step2.2 ----> here Create The app bar :
      appBar: AppBar(title: Text("High Priority")),

      //step2.2 ----> here Create a body :
      body: Padding(
        padding: EdgeInsets.all(AppSizes.w16),
        child: Consumer<TasksController>(
          builder: (BuildContext context, valueController, Widget? child) {
            return CustomList(
              tasks: valueController.highPriorityTasks,
              onTap: (value, index) async {
                controller.doneTask(
                  value,
                  valueController.highPriorityTasks[index!].id,
                );
              },
              empatyMessage: "No Task Found",
              onDelete: (int? id) {
                controller.deleteTask(id);
              },
              onEdit: () {
                controller.init();
              },
            );
          },
        ),
      ),
    );
  }
}
