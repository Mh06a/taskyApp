import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/theme/app_colors.dart';

class ThemeOptionCard extends StatelessWidget {
  const ThemeOptionCard({
    super.key,
    required this.title,
    required this.image,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String image;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.r16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.s8,
          vertical: AppSizes.s12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary.withValues(alpha: AppColors.alphaLight)
              : scheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(
            color: selected
                ? scheme.primary
                : theme.dividerColor.withValues(alpha: AppColors.alphaBorder),
            width: selected ? AppSizes.stroke1_5 : AppSizes.stroke1,
          ),
        ),
        child: Column(
          children: [
            Image.asset(
              image,
              width: AppSizes.themeOptionImage,
              height: AppSizes.themeOptionImage,
              fit: BoxFit.contain,
            ),
            SizedBox(height: AppSizes.s8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selected) ...[
                  SizedBox(width: AppSizes.s4),
                  Icon(
                    Icons.check_circle_rounded,
                    size: AppSizes.icon16,
                    color: scheme.primary,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
