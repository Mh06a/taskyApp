import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/enums/priority.dart';
import 'package:tasky/presentation/controllers/task_form_controller.dart';
import 'package:tasky/presentation/widgets/app_button.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  Future<void> _pickDate(
    BuildContext context,
    TaskFormController controller,
  ) async {
    final now = controller.now;

    final selected = await showDatePicker(
      context: context,
      initialDate: controller.dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );

    if (selected != null) controller.setDate(selected);
  }

  Future<void> _pickTime(
    BuildContext context,
    TaskFormController controller,
  ) async {
    final dueDate = controller.dueDate;

    if (dueDate == null) return;

    final selected = await showTimePicker(
      context: context,
      initialTime: controller.time ?? TimeOfDay.fromDateTime(controller.now),
    );

    if (selected != null) controller.setTime(selected);
  }

  Future<void> _save(
    BuildContext context,
    TaskFormController controller,
  ) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    final saved = await controller.submit();

    if (saved) {
      navigator.pop();
      return;
    }

    // Validation problems are shown on the fields themselves.
    final message = controller.errorMessage;

    if (message != null) {
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<TaskFormController>();
    final dueDate = controller.dueDate;
    final localizations = MaterialLocalizations.of(context);
    final time = controller.time;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit task' : 'New task'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSizes.s20),
          children: [
            Text('What needs to be done?', style: theme.textTheme.titleMedium),
            SizedBox(height: AppSizes.s8),
            TextField(
              controller: controller.titleController,
              autofocus: !controller.isEditing,
              maxLength: Limits.taskTitle,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Write your task',
                counterText: '',
                errorText: controller.titleErrorText,
              ),
            ),
            SizedBox(height: AppSizes.s24),
            Text('Description', style: theme.textTheme.titleMedium),
            SizedBox(height: AppSizes.s8),
            TextField(
              controller: controller.descriptionController,
              maxLength: Limits.taskDescription,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Add some details (optional)',
                alignLabelWithHint: true,
                errorText: controller.descriptionErrorText,
              ),
            ),
            SizedBox(height: AppSizes.s24),
            Text('Priority', style: theme.textTheme.titleMedium),
            SizedBox(height: AppSizes.s12),
            SegmentedButton<Priority>(
              expandedInsets: EdgeInsets.zero,
              segments: const [
                ButtonSegment(
                  value: Priority.normal,
                  label: Text('Normal'),
                  icon: Icon(Icons.circle_outlined),
                ),
                ButtonSegment(
                  value: Priority.high,
                  label: Text('High'),
                  icon: Icon(Icons.flag_outlined),
                ),
              ],
              selected: {controller.priority},
              onSelectionChanged: (selection) {
                controller.setPriority(selection.first);
              },
            ),
            SizedBox(height: AppSizes.s24),
            Text('Schedule', style: theme.textTheme.titleMedium),
            SizedBox(height: AppSizes.s12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSizes.r16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today_outlined),
                    title: const Text('Due date'),
                    subtitle: Text(
                      dueDate == null
                          ? 'Choose a due date'
                          : localizations.formatMediumDate(dueDate),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => _pickDate(context, controller),
                  ),
                  Divider(height: AppSizes.stroke1),
                  SwitchListTile.adaptive(
                    secondary: const Icon(Icons.access_time_rounded),
                    title: const Text('Set a time'),
                    value: controller.hasDueTime,
                    onChanged: dueDate == null
                        ? null
                        : (value) {
                            if (value) {
                              _pickTime(context, controller);
                            } else {
                              controller.removeTime();
                            }
                          },
                  ),
                  if (time != null)
                    ListTile(
                      leading: const Icon(Icons.schedule_rounded),
                      title: const Text('Time'),
                      subtitle: Text(localizations.formatTimeOfDay(time)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _pickTime(context, controller),
                    ),
                  if (dueDate != null)
                    TextButton(
                      onPressed: controller.removeDate,
                      child: const Text('Remove date'),
                    ),
                ],
              ),
            ),
            SizedBox(height: AppSizes.s32),
            AppButton(
              text: controller.isEditing ? 'Save changes' : 'Create task',
              isLoading: controller.isSaving,
              onPressed: () => _save(context, controller),
            ),
          ],
        ),
      ),
    );
  }
}
