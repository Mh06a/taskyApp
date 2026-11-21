
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/constants/app_sizes.dart';

class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({
    super.key,
    required this.assetPath,
    this.size,
    this.color,
  });

  final String assetPath;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    return SvgPicture.asset(
      assetPath,
      width: size ?? iconTheme.size ?? AppSizes.icon24,
      height: size ?? iconTheme.size ?? AppSizes.icon24,
      colorFilter: ColorFilter.mode(
        color ?? iconTheme.color ?? Theme.of(context).colorScheme.onSurface,
        BlendMode.srcIn,
      ),
    );
  }
}
