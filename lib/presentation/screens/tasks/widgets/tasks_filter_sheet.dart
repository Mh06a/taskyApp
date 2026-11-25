import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/theme/app_colors.dart';
import 'package:tasky/core/enums/task_sort.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/presentation/widgets/app_button.dart';

Future<void> showTasksFilterSheet(BuildContext context) async {
  final controller = context.read<TasksController>();

  var selectedSort = controller.query.sort;
  var highPriorityOnly = controller.query.onlyHighPriority;

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);

      return StatefulBuilder(
        builder: (context, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSizes.s20,
                AppSizes.s8,
                AppSizes.s20,
                AppSizes.s24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sort & filter',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppSizes.s4),
                  Text(
                    'Keep what matters in view.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSizes.s24),

                  Text(
                    'Sort by',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: AppSizes.s8),

                  _SortOption(
                    title: 'Newest first',
                    selected: selectedSort == TaskSort.newest,
                    onTap: () {
                      setSheetState(() {
                        selectedSort = TaskSort.newest;
                      });
                    },
                  ),
                  _SortOption(
                    title: 'Due date',
                    selected: selectedSort == TaskSort.dueDate,
                    onTap: () {
                      setSheetState(() {
                        selectedSort = TaskSort.dueDate;
                      });
                    },
                  ),
                  _SortOption(
                    title: 'Priority',
                    selected: selectedSort == TaskSort.priority,
                    onTap: () {
                      setSheetState(() {
                        selectedSort = TaskSort.priority;
                      });
                    },
                  ),

                  SizedBox(height: AppSizes.s20),

                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('High priority only'),
                    subtitle: const Text(
                      'Show only important tasks.',
                    ),
                    value: highPriorityOnly,
                    onChanged: (value) {
                      setSheetState(() {
                        highPriorityOnly = value;
                      });
                    },
                  ),

                  SizedBox(height: AppSizes.s16),

                  AppButton(
                    text: 'Apply filters',
                    onPressed: () {
                      controller.changeSort(selectedSort);
                      controller.toggleHighPriorityFilter(
                        highPriorityOnly,
                      );
                      Navigator.pop(sheetContext);
                    },
                  ),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        controller.resetFilters();
                        Navigator.pop(sheetContext);
                      },
                      child: const Text('Reset filters'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.s8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.r12),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: AppColors.alphaSubtle)
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSizes.r12),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}