import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_project/core/widgets/custom_add_edit_task.dart';
import 'package:second_project/features/add_task/add_task_controller.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  //step2 ----> here Create The page :
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddTaskController(),
      builder: (context, child) {
        final controller = context.read<AddTaskController>();

        return Scaffold(
          //step2.1 ----> here Create AppBar :
          appBar: AppBar(title: Text("New Task")),

          //step2.2 ----> here Create the body :
          body: SafeArea(
            child: CustomAddEditTask(
              formKey: controller.formKey,
              nameController: controller.nameController,
              descriptionController: controller.descriptionController,
              isHighPriority: controller.isHighPriority,
              // TODO تغير الى الادارة الجاله
              onChanged: (value) {
                controller.toggle(value);
              },
              buttonText: "Add Task",
              onPressed: () async {
                context.read<AddTaskController>().addTask(context);
              },
              buttonIcon: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
