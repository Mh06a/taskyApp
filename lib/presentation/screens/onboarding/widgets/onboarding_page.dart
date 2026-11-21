import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/screens/onboarding/models/onboarding_page_model.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.page,
  });

  final OnboardingPageModel page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.s16,
            ),
            child: Image.asset(
              page.imagePath,
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),

        SizedBox(height: AppSizes.s32),

        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.s8,
            ),
            child: Column(
              children: [
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),

                SizedBox(height: AppSizes.s16),

                Text(
                  page.description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: AppSizes.lineHeightRelaxed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}