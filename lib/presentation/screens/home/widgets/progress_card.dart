import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/theme/app_colors.dart';

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.total,
    required this.done,
    required this.percent,
  });

  final int total;
  final int done;
  final double percent;

  String get message {
    if (total == 0) {
      return 'A fresh start.';
    }

    if (done == total) {
      return 'All done. Great work!';
    }

    return 'Keep your rhythm.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: AppColors.alphaSubtle),
        borderRadius: BorderRadius.circular(AppSizes.r20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: AppColors.alphaSubtle),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TODAY'S PROGRESS",
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1,
                    color: theme.colorScheme.primary,
                  ),
                ),

                SizedBox(height: AppSizes.s8),

                Text(
                  message,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: AppSizes.s4),

                Text(
                  '$done of $total tasks done',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: AppSizes.s12),

          SizedBox(
            width: AppSizes.s64,
            height: AppSizes.s64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: percent.clamp(0.0, 1.0),
                    strokeWidth: AppSizes.s4,
                    strokeCap: StrokeCap.round,
                    backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: AppColors.alphaLight),
                    color: theme.colorScheme.primary,
                  ),
                ),

                Text(
                  '${(percent * 100).round()}%',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}