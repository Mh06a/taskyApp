import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/domain/entities/user_profile.dart';
import 'package:tasky/presentation/widgets/profile_avatar.dart';

class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({
    super.key,
    required this.displayName,
    required this.profile,
  });

  final String displayName;
  final UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSizes.r20),
      ),
      child: Row(
        children: [
          ProfileAvatar(
            path: profile?.avatarPath,
            size: AppSizes.avatarSummary,
          ),
          SizedBox(width: AppSizes.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayName, style: theme.textTheme.titleMedium),
                SizedBox(height: AppSizes.s4),
                Text(
                  profile?.quote ?? Limits.defaultQuote,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
