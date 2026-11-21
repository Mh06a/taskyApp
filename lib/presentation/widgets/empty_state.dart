import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/theme/tasky_theme_extension.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.check_rounded,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskyColors = theme.extension<TaskyThemeExtension>()!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.s20,
        vertical: AppSizes.s32,
      ),
      decoration: BoxDecoration(
        color: taskyColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppSizes.r20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSizes.icon32,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: AppSizes.s16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: AppSizes.s8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
