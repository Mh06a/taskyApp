import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  }) : assert(
  (actionText == null) == (onAction == null),
  'actionText and onAction must be provided together.',
  );

  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: textTheme.titleLarge,
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.s8,
              ),
            ),
            child: Text(actionText!),
          ),
      ],
    );
  }
}
