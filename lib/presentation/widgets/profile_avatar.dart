import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/theme/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.path,
    this.size,
    this.fallback,
  });

  final String? path;
  final double? size;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedSize = size ?? AppSizes.avatarMedium;

    final imagePath = path;

    return Container(
      width: resolvedSize,
      height: resolvedSize,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primary.withValues(alpha: AppColors.alphaLight),
      ),
      child: imagePath == null || imagePath.isEmpty
          ? (fallback ?? _fallbackIcon(theme))
          : Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: resolvedSize,
        height: resolvedSize,
        errorBuilder: (_, _, _) => (fallback ?? _fallbackIcon(theme)),
      ),
    );
  }

  Widget _fallbackIcon(ThemeData theme) {
    return Icon(
      Icons.person_outline_rounded,
      size: AppSizes.icon24,
      color: theme.colorScheme.primary,
    );
  }
}
