import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: AppSizes.icon20,
        height: AppSizes.icon20,
        child: CircularProgressIndicator(
          strokeWidth: AppSizes.stroke2,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      );
    }

    if (icon == null) {
      return Text(text);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: AppSizes.icon20,
        ),
        SizedBox(width: AppSizes.s8),
        Text(text),
      ],
    );
  }
}
