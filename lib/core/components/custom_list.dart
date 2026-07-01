import 'package:flutter/material.dart';
import 'package:second_project/core/components/custom_task_item.dart';
import 'package:second_project/models/task.dart';

class CustomList extends StatelessWidget {
  const CustomList({
    super.key,
    required this.tasks,
    required this.onTap,
    this.empatyMessage,
    required this.onDelete,
    required this.onEdit,
  });

  //step1 ----> here Create Var for class :
  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final String? empatyMessage;
  final Function(int?) onDelete;
  final Function onEdit;

  //step2 ----> here Create The custom list :
  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              empatyMessage ?? "No Data",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            padding: EdgeInsets.only(bottom: 60),
            itemBuilder: (context, index) {
              return CustomTaskItem(
                model: tasks[index],
                onChanged: (bool? value) {
                  onTap(value, index);
                },
                onDelete: (int id) {
                  onDelete(id);
                },
                onEdit: () => onEdit,
              );
            },
          );
  }
}
