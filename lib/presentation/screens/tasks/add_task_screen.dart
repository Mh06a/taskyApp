import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/constants/limits.dart';
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
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (!context.mounted || selected == null) return;

    controller.setDate(selected);
  }

  Future<void> _pickTime(
      BuildContext context,
      TaskFormController controller,
      ) async {
    if (controller.dueDate == null) return;

    final selected = await showTimePicker(
      context: context,
      initialTime: controller.time ?? TimeOfDay.fromDateTime(controller.now),
    );

    if (!context.mounted || selected == null) return;

    controller.setTime(selected);
  }

  Future<void> _save(
      BuildContext context,
      TaskFormController controller,
      ) async {
    final saved = await controller.submit();

    if (!context.mounted) return;

    if (saved) {
      Navigator.of(context).pop();
      return;
    }

    final message = controller.errorMessage;

    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<TaskFormController>();
    final dueDate = controller.dueDate;
    final time = controller.time;

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit task' : 'New task'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(AppSizes.s20),
          children: [
            Text(
              'What needs to be done?',
              style: theme.textTheme.titleMedium,
            ),
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
            Text(
              'Description',
              style: theme.textTheme.titleMedium,
            ),
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
            Text(
              'Priority',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: AppSizes.s12),
            SegmentedButton<Priority>(
              expandedInsets: EdgeInsets.zero,
              segments: [
                ButtonSegment(
                  value: Priority.normal,
                  label: const Text('Normal'),
                ),
                ButtonSegment(
                  value: Priority.high,
                  label: const Text('High'),
                  icon: SvgPicture.asset(
                    AppAssets.flagIcon,
                    width: AppSizes.icon18,
                    height: AppSizes.icon18,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
              selected: {controller.priority},
              onSelectionChanged: (selection) {
                controller.setPriority(selection.first);
              },
            ),
            SizedBox(height: AppSizes.s24),
            Text(
              'Schedule',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: AppSizes.s12),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppSizes.r16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: SvgPicture.asset(
                      AppAssets.dateIcon,
                      width: AppSizes.icon22,
                      height: AppSizes.icon22,
                    ),
                    title: const Text('Due date'),
                    subtitle: Text(
                      dueDate == null
                          ? 'Choose a due date'
                          : MaterialLocalizations.of(context)
                          .formatMediumDate(dueDate),
                    ),
                    onTap: () => _pickDate(context, controller),
                  ),
                  Divider(height: AppSizes.stroke1),
                  SwitchListTile.adaptive(
                    secondary: SvgPicture.asset(
                      AppAssets.clockIcon,
                      width: AppSizes.icon22,
                      height: AppSizes.icon22,
                    ),
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
                      leading: SvgPicture.asset(
                        AppAssets.clockIcon,
                        width: AppSizes.icon22,
                        height: AppSizes.icon22,
                      ),
                      title: const Text('Time'),
                      subtitle: Text(
                        MaterialLocalizations.of(context)
                            .formatTimeOfDay(time),
                      ),
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