import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/theme/tasky_theme_extension.dart';
import 'package:tasky/presentation/widgets/app_svg_icon.dart';

class TaskInfoChip extends StatelessWidget {
  const TaskInfoChip({
    super.key,
    required this.label,
    this.iconPath,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  }) : assert(
  iconPath != null || icon != null,
  'Either iconPath or icon must be provided.',
  );

  final String label;
  final String? iconPath;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskyColors = theme.extension<TaskyThemeExtension>()!;

    final resolvedBackground =
        backgroundColor ?? taskyColors.surfaceSecondary;

    final resolvedForeground =
        foregroundColor ?? theme.colorScheme.onSurfaceVariant;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.s8,
        vertical: AppSizes.s4,
      ),
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(AppSizes.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null)
            AppSvgIcon(
              assetPath: iconPath!,
              size: AppSizes.icon12,
              color: resolvedForeground,
            )
          else
            Icon(
              icon,
              size: AppSizes.icon12,
              color: resolvedForeground,
            ),
          SizedBox(width: AppSizes.s4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: resolvedForeground,
            ),
          ),
        ],
      ),
    );
  }
}
