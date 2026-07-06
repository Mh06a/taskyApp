import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:second_project/core/constants/storage_key.dart';
import 'package:second_project/core/widgets/custom_add_edit_task.dart';
import 'package:second_project/models/task.dart';
import 'package:second_project/core/services/preferences_manager.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  //step1 ----> here Create Var for class :
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isHighPriority = false;

  //step2 ----> here Create The page :
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //step2.1 ----> here Create AppBar :
      appBar: AppBar(title: Text("New Task")),

      //step2.2 ----> here Create the body :
      body: SafeArea(
        child: CustomAddEditTask(
          formKey: formKey,
          nameController: nameController,
          descriptionController: descriptionController,
          isHighPriority: isHighPriority,
          onChanged: (value) {
            setState(() {
              isHighPriority = value;
            });
          },
          buttonText: "Add Task",
          onPressed: () async {
            if (formKey.currentState?.validate() ?? false) {
              final taskJson = PreferencesManager().getString(
                StorageKey.taskName,
              );
              List<dynamic> tasks = [];
              if (taskJson != null) {
                tasks = jsonDecode(taskJson);
              }

              TaskModel taskModel = TaskModel(
                id: tasks.length + 1,
                taskName: nameController.text,
                taskDescription: descriptionController.text,
                isHighPriority: isHighPriority,
              );

              tasks.add(taskModel.toMap());
              final taskEncode = jsonEncode(tasks);
              await PreferencesManager().setString(
                StorageKey.taskName,
                taskEncode,
              );
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop(true);
            }
          },
          buttonIcon: Icon(Icons.add),
        ),
      ),
    );
  }
}
