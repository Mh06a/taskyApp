import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/enums/priority.dart';
import 'package:tasky/core/theme/tasky_theme_extension.dart';
import 'package:tasky/presentation/widgets/app_svg_icon.dart';

class PriorityChip extends StatelessWidget {
  const PriorityChip({
    super.key,
    required this.priority,
    this.showIcon = true,
  });

  final Priority priority;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskyColors = theme.extension<TaskyThemeExtension>()!;

    final isHigh = priority == Priority.high;

    final backgroundColor = isHigh
        ? taskyColors.priorityHigh
        : taskyColors.surfaceSecondary;

    final foregroundColor = isHigh
        ? taskyColors.priorityHighText
        : theme.colorScheme.onSurfaceVariant;

    final label = isHigh ? 'High priority' : 'Normal';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.s8,
        vertical: AppSizes.s4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.r8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && isHigh) ...[
            AppSvgIcon(
              assetPath: AppAssets.flagIcon,
              size: AppSizes.icon12,
              color: foregroundColor,
            ),
            SizedBox(width: AppSizes.s4),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
