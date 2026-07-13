import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:second_project/core/constants/storage_key.dart';
import 'package:second_project/core/services/preferences_manager.dart';
import 'package:second_project/models/task.dart';

class AddTaskController extends ChangeNotifier {
  //step1 ----> here Create Var for class :
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isHighPriority = false;

  //step2 ----> here I will Create a function to Add Task :
  void addTask(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      final taskJson = PreferencesManager().getString(StorageKey.taskName);
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
      await PreferencesManager().setString(StorageKey.taskName, taskEncode);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
    }
  }

  //step3 ----> here I will Create a function to :
  void toggle(bool value) {
    isHighPriority = value;
    notifyListeners();
  }
}
