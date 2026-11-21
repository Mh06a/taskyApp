
import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';

class ChoiceTile extends StatelessWidget {
  const ChoiceTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.leading,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.s8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
        ),
        tileColor: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : theme.colorScheme.surface,
        leading: leading,
        title: Text(title),
        trailing: selected
            ? Icon(
          Icons.check_rounded,
          color: theme.colorScheme.primary,
        )
            : null,
        onTap: onTap,
      ),
    );
  }
}
