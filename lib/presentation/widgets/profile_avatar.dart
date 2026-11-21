import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.path,
    this.size,
  });

  final String? path;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedSize = size ?? AppSizes.avatarMedium;
    final imagePath = path;
    final hasFile = imagePath != null &&
        imagePath.isNotEmpty &&
        File(imagePath).existsSync();

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
      ),
      child: hasFile
          ? Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: resolvedSize,
        height: resolvedSize,
        errorBuilder: (_, _, _) => _fallbackIcon(theme),
      )
          : _fallbackIcon(theme),
    );
  }

  Widget _fallbackIcon(ThemeData theme) {
    return Icon(
      Icons.person_outline_rounded,
      color: theme.colorScheme.primary,
    );
  }
}