import 'package:flutter/material.dart';
import 'package:second_project/core/components/custom_task_item.dart';
import 'package:second_project/models/task.dart';

class SilverCustomList extends StatelessWidget {
  const SilverCustomList({
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
        ? SliverToBoxAdapter(
            child: Center(
              child: Text(
                empatyMessage ?? "No Data",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
          )
        : SliverPadding(
            padding: const EdgeInsets.only(bottom: 30.0),
            sliver: SliverList.separated(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return CustomTaskItem(
                  model: tasks[index],
                  onChanged: (bool? value) {
                    onTap(value, index);
                  },
                  onDelete: (int id) {
                    onDelete(id);
                  },
                  onEdit: () => onEdit(),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 8);
              },
            ),
          );
  }
}
