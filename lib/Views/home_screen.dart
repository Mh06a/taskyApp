import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:second_project/Views/new_task_screen.dart';
import 'package:second_project/Widgets/custom_achieved_tasks.dart';
import 'package:second_project/Widgets/custom_add_buttton.dart';
import 'package:second_project/Widgets/high_priority_tasks.dart';
import 'package:second_project/Widgets/silver_custom_list.dart';
import 'package:second_project/models/task.dart';
import 'package:second_project/services/preferences_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //step1 ---- Create vars for class :
  String? username;
  String? motivationQuote;
  List<TaskModel> tasks = [];
  int totalTask = 0;
  int doneTask = 0;
  double percent = 0;

  //step3 ---- call initState() :
  @override
  void initState() {
    super.initState();

    _loadUserData();
    _loadTask();
  }

  //step4 ---- create a function to load load User Data :
  void _loadUserData() async {
    setState(() {
      username = PreferencesManager().getString("username") ?? "Guset";
      motivationQuote =
          PreferencesManager().getString("motivation_quote") ?? "Nothing";
    });
  }

  //step5 ---- Create a function to load tasks
  void _loadTask() async {
    final finalTask = PreferencesManager().getString("tasks");
    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        tasks = taskAfterDecode.map((element) {
          return TaskModel.fromJson(element);
        }).toList();
        _calculatePercent();
      });
    }
  }

  //step6 ---- Create a function to calculate percent :
  void _calculatePercent() {
    totalTask = tasks.length;
    doneTask = tasks.where((element) => element.isDone).length;
    percent = totalTask == 0 ? 0 : doneTask / totalTask;
  }

  //step7 ---- Create a function to set done tasks :
  Future<void> _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index ?? 0].isDone = value ?? false;
    });
    final updatedTask = tasks.map((element) => element.toMap()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
  }

  //step8 ---- Create a function to delete the task :
  Future<void> _deleteTask(int? id) async {
    if (id == null) return;
    setState(() {
      tasks.removeWhere((task) => task.id == id);
    });
    final updatedTask = tasks.map((element) => element.toMap()).toList();
    await PreferencesManager().setString('tasks', jsonEncode(updatedTask));
  }

  //step2 ---- Create The page :
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // step2.2 --- Good Text :
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/Vector.svg",
                        width: 42,
                        height: 42,
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening ,$username",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            "$motivationQuote",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(width: 30),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        width: 18,
                        height: 18,
                        child: SvgPicture.asset(
                          "assets/icons/sun.svg",
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),

                  // step2.3 --- Yuhuu Text :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Yuhuu ,Your work Is",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "almost done ! ",
                            style: Theme.of(context).textTheme.displayLarge,
                          ),

                          SvgPicture.asset(
                            "assets/icons/waving_hand.svg",
                            height: 32,
                            width: 32,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  //step2.5 ---Achieved Tasks :
                  CustomAchievedTasks(
                    totalTask: totalTask,
                    doneTask: doneTask,
                    percent: percent,
                  ),

                  SizedBox(height: 8),

                  //step2.6 ---High Priority Tasks :
                  HighPriorityTasks(
                    tasks: tasks,
                    onTap: (bool? value, int? index) async {
                      _doneTask(value, index);
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Text(
                      "My Tasks",
                      style: Theme.of(context).textTheme.displayMedium,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),

            //step2.4 --- my tasks :
            SilverCustomList(
              tasks: tasks,
              onTap: (bool? value, int? index) async {
                _doneTask(value, index);
                _calculatePercent();
              },
              onDelete: (int? id) {
                _deleteTask(id);
              },
              onEdit: () {
                _loadTask();
              },
            ),

            SliverToBoxAdapter(
              child: Align(
                alignment: Alignment.bottomRight,
                child: CustomAddButton(
                  onPressed: () async {
                    final bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return AddNewTask();
                        },
                      ),
                    );
                    if (result != null && result) {
                      _loadTask();
                    }
                  },
                  buttonText: "Add New Task",
                  height: 40.0,
                  width: 167.0,
                  icon: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
