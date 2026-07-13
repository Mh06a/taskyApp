import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:second_project/core/constants/storage_key.dart';
import 'package:second_project/core/services/preferences_manager.dart';
import 'package:second_project/models/task.dart';

class TasksController extends ChangeNotifier {
  //step1 ----> here Create Var for class :
  List<TaskModel> tasks = [];
  List<TaskModel> completeTasks = [];
  List<TaskModel> todoTasks = [];
  List<TaskModel> highPriorityTasks = [];
  int totalTask = 0;
  int doneTasks = 0;
  double percent = 0;

  //step2 ----> here I will Create a init function:
  void init() {
    _loadTask();
  }

  //step3 ---- Create a function to load tasks :
  void _loadTask() async {
    final finalTask = PreferencesManager().getString(StorageKey.taskName);
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();

      _loadData();

      calculatePercent();
    }
    notifyListeners();
  }

  void _loadData() {
    todoTasks = tasks.where((element) => !element.isDone).toList();
    completeTasks = tasks.where((element) => element.isDone).toList();
    highPriorityTasks = tasks
        .where((element) => element.isHighPriority)
        .toList();
    highPriorityTasks = highPriorityTasks.reversed.toList();
  }

  //step4 ----> Create a function to done tasks :
  void doneTask(bool? value, int id) async {
    final index = tasks.indexWhere((e) => e.id == id);

    if (index == -1) return;

    tasks[index].isDone = value ?? false;

    _loadData();
    calculatePercent();

    final updatedTask = tasks.map((e) => e.toJson()).toList();
    await PreferencesManager().setString(
      StorageKey.taskName,
      jsonEncode(updatedTask),
    );

    notifyListeners();
  }

  //step7 ----> Create a function to delete task :
  void deleteTask(int? id) async {
    if (id == null) return;

    tasks.removeWhere((e) => e.id == id);

    _loadData();
    calculatePercent();

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    PreferencesManager().setString(
      StorageKey.taskName,
      jsonEncode(updatedTask),
    );

    notifyListeners();
  }

  //step8 ---- Create a function to calculate percent :
  void calculatePercent() {
    totalTask = tasks.length;
    doneTasks = tasks.where((element) => element.isDone).length;
    percent = totalTask == 0 ? 0 : doneTasks / totalTask;

    notifyListeners();
  }
}
