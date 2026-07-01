import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:second_project/core/widgets/custom_add_edit_task.dart';
import 'package:second_project/core/widgets/custom_check_box.dart';
import 'package:second_project/core/enums/task_item_actions_enum.dart';
import 'package:second_project/models/task.dart';
import 'package:second_project/core/services/preferences_manager.dart';
import 'package:second_project/core/themes/theme_controller.dart';

class CustomTaskItem extends StatelessWidget {
  const CustomTaskItem({
    super.key,
    required this.model,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });

  final TaskModel model;
  final Function(bool?) onChanged;
  final Function(int) onDelete;
  final Function onEdit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ThemeController.isDark()
                ? Colors.transparent
                : Theme.of(context).colorScheme.outline,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 8),

            CustomCheckBox(
              value: model.isDone,
              onChanged: (bool? value) => onChanged(value),
            ),

            SizedBox(width: 16),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.taskName,
                    style: TextStyle(
                      color: model.isDone
                          ? Color(0xFFA0A0A0)
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                      decoration: model.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Color(0xFFCAC4D0),
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: 2),
                  if (model.taskDescription.isNotEmpty)
                    Text(
                      model.taskDescription,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                ],
              ),
            ),

            PopupMenuButton<TaskItemActionsEnum>(
              icon: Icon(
                Icons.more_vert,
                color: ThemeController.isDark()
                    ? (model.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                    : (model.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
              ),

              onSelected: (value) async {
                switch (value) {
                  case TaskItemActionsEnum.markAsDone:
                    onChanged(!model.isDone);
                  case TaskItemActionsEnum.delete:
                    await _showAlertDialog(context);
                  case TaskItemActionsEnum.edit:
                    final result = await _showButtonSheet(context, model);
                    if (result == true) {
                      onEdit();
                    }
                }
              },

              itemBuilder: (context) => TaskItemActionsEnum.values.map((e) {
                return PopupMenuItem(value: e, child: Text(e.name));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // here I will Create a function to show Dialog :
  Future<String?> _showAlertDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Task",
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          content: Text("Are you sure you want delete this task "),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),

            TextButton(
              onPressed: () {
                onDelete(model.id);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // here I will Create a function to show button sheet :
  Future<bool?> _showButtonSheet(BuildContext context, TaskModel model) {
    TextEditingController taskNameController = TextEditingController(
      text: model.taskName,
    );
    TextEditingController taskDescriptionController = TextEditingController(
      text: model.taskDescription,
    );
    GlobalKey<FormState> key = GlobalKey<FormState>();
    bool isHighPriority = model.isHighPriority;

    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, void Function(void Function()) setState) {
            return CustomAddEditTask(
              formKey: key,
              nameController: taskNameController,
              descriptionController: taskDescriptionController,
              isHighPriority: isHighPriority,
              onChanged: (bool value) {
                isHighPriority = value;
              },
              buttonText: "Edit",
              onPressed: () async {
                if (key.currentState?.validate() ?? false) {
                  final taskJson = PreferencesManager().getString("tasks");

                  List<dynamic> listTask = [];

                  if (taskJson != null) {
                    listTask = jsonDecode(taskJson);
                  }

                  TaskModel newModel = TaskModel(
                    id: model.id,
                    taskName: taskNameController.text,
                    taskDescription: taskDescriptionController.text,
                    isHighPriority: isHighPriority,
                    isDone: model.isDone,
                  );

                  final item = listTask.firstWhere((e) => e["id"] == model.id);

                  final int index = listTask.indexOf(item);
                  listTask[index] = newModel.toMap();

                  final taskEncode = jsonEncode(listTask);
                  await PreferencesManager().setString("tasks", taskEncode);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(true);
                }
              },
              buttonIcon: Icon(Icons.edit),
            );
          },
        );
      },
    );
  }
}
