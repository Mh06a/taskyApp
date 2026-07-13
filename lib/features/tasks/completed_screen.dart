import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_project/core/components/custom_list.dart';
import 'package:second_project/features/tasks/tasks_controller.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});

  //step2 ----> here Create The page :
  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //step2.1 ----> here Create AppBar :
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "Completed Tasks",
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontSize: 20),
            textAlign: TextAlign.start,
          ),
        ),

        //step2.2 ----> here Create the body :
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<TasksController>(
              builder: (context, valueController, child) {
                return CustomList(
                  tasks: valueController.completeTasks,
                  onTap: (value, index) async {
                    controller.doneTask(
                      value,
                      valueController.completeTasks[index!].id,
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
        ),
      ],
    );
  }
}
