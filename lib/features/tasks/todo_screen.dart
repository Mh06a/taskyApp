import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_project/core/components/custom_list.dart';
import 'package:second_project/features/tasks/tasks_controller.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  //step2 ----> here Create The page :
  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //step2.1 ----> here Create tect tp  AppBar :
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(
            "To Do Tasks",
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
              builder: (context, controllerValue, child) {
                return CustomList(
                  tasks: controllerValue.todoTasks,
                  onTap: (value, index) async {
                    controller.doneTask(
                      value,
                      controllerValue.todoTasks[index!].id,
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
