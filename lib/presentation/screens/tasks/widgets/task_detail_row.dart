import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/widgets/app_svg_icon.dart';

class TaskDetailRow extends StatelessWidget {
  const TaskDetailRow({super.key, required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final String icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(padding: EdgeInsets.all(AppSizes.s16), child: Row(children: [AppSvgIcon(assetPath: icon, size: AppSizes.icon20, color: theme.colorScheme.primary), SizedBox(width: AppSizes.s12), Expanded(child: Text(title, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant))), Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600))]));
  }
}
