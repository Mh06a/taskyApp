import 'package:flutter/material.dart';
import 'package:second_project/Widgets/custom_list.dart';
import 'dart:convert';
import 'package:second_project/models/task.dart';
import 'package:second_project/services/preferences_manager.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
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
            .where((element) => element.isDone == false)
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

  //step2 ----> here Create The page :
  @override
  Widget build(BuildContext context) {
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
                    'tasks',
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
        ),
      ],
    );
  }
}
