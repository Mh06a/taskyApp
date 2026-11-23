import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tasky/core/constants/app_sizes.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.controller,
    required this.count,
  });

  final PageController controller;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: ExpandingDotsEffect(
        activeDotColor: colorScheme.primary,
        dotColor: colorScheme.outlineVariant,
        dotHeight: AppSizes.s8,
        dotWidth: AppSizes.s8,
        expansionFactor: 3,
        spacing: AppSizes.s8,
      ),
    );
  }
}
