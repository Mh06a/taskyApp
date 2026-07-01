import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:second_project/core/components/custom_list.dart';
import 'package:second_project/models/task.dart';
import 'package:second_project/core/services/preferences_manager.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  //step1 ----> here Create Var for class :
  List<TaskModel> tasks = [];

  //step3 ---- call initState() :
  @override
  void initState() {
    super.initState();

    _loadTask();
  }

  //step4 ---- Create a function to load tasks
  void _loadTask() async {
    final finalTask = PreferencesManager().getString("tasks");
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      setState(() {
        tasks = taskAfterDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isHighPriority)
            .toList();
      });
    }
  }

  //step5 ---- Create a function to delete the task :
  Future<void> _deleteTask(int? id) async {
    List<TaskModel> tasksA = [];
    if (id == null) return;

    final finalTask = PreferencesManager().getString("tasks");
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasksA = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      tasksA.removeWhere((e) => e.id == id);

      setState(() {
        tasks.removeWhere((task) => task.id == id);
      });
      final updatedTask = tasksA.map((element) => element.toMap()).toList();
      await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
    }
  }

  //step2 ----> here Create The custom list :
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //step2.2 ----> here Create The app bar :
      appBar: AppBar(title: Text("High Priority")),

      //step2.2 ----> here Create a body :
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomList(
          tasks: tasks,
          onTap: (value, index) async {
            setState(() {
              tasks[index ?? 0].isDone = value ?? false;
            });

            final allData = PreferencesManager().getString("tasks");
            if (allData != null) {
              List<TaskModel> allDataList = (jsonDecode(allData) as List)
                  .map((element) => TaskModel.fromJson(element))
                  .toList();

              final newIndex = allDataList.indexWhere(
                (e) => e.id == tasks[index!].id,
              );
              allDataList[newIndex] = tasks[index!];

              await PreferencesManager().setString(
                "tasks",
                jsonEncode(allDataList.map((e) => e.toMap()).toList()),
              );
              _loadTask();
            }
          },
          empatyMessage: "No Task Found",
          onDelete: (int? id) {
            _deleteTask(id);
          },
          onEdit: () {
            _loadTask();
          },
        ),
      ),
    );
  }
}
