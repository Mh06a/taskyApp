import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/formatters/greeting_helper.dart';
import 'package:tasky/presentation/widgets/profile_avatar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    this.avatarPath,
    this.date,
    required this.now,
  });

  final String name;
  final String? avatarPath;
  final String? date;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greeting = GreetingHelper.getGreeting(now);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: AppSizes.s4),

              Text(
                '$name, at your pace.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              if (date != null) ...[
                SizedBox(height: AppSizes.s8),
                Text(
                  date!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),

        SizedBox(width: AppSizes.s12),

        ProfileAvatar(path: avatarPath),
      ],
    );
  }
}

