import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/controllers/onboarding_controller.dart';
import 'package:tasky/presentation/screens/onboarding/data/onboarding_data.dart';
import 'package:tasky/presentation/screens/onboarding/widgets/onboarding_content.dart';
import 'package:tasky/presentation/screens/onboarding/widgets/onboarding_indicator.dart';
import 'package:tasky/presentation/widgets/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Complete onboarding and navigate to the welcome screen.
  Future<void> _finishOnboarding(BuildContext context) async {
    final controller = context.read<OnboardingController>();
    final success = await controller.finishOnboarding();

    if (!context.mounted) return;

    if (success) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Something went wrong. Please try again.'),
      ),
    );
  }

  // Move to the next page or finish onboarding.
  void _nextPage(BuildContext context) {
    final controller = context.read<OnboardingController>();
    if (controller.isLastPage) {
      _finishOnboarding(context);
      return;
    }

    controller.pageController.nextPage(
      duration: AppSizes.durationNormal,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    final isLastPage = controller.isLastPage;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.s24),
          child: Column(
            children: [
              SizedBox(
                height: AppSizes.buttonHeight,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: isLastPage
                      ? const SizedBox.shrink()
                      : TextButton(
                    onPressed: controller.isFinishing
                        ? null
                        : () => _finishOnboarding(context),
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: OnboardingData.pages.length,
                  onPageChanged: controller.updatePage,
                  itemBuilder: (context, index) {
                    return OnboardingContent(
                      item: OnboardingData.pages[index],
                    );
                  },
                ),
              ),

              OnboardingIndicator(
                controller: controller.pageController,
                count: OnboardingData.pages.length,
              ),

              SizedBox(height: AppSizes.s24),

              AppButton(
                text: isLastPage ? 'Get started' : 'Continue',
                onPressed: controller.isFinishing ? null : () => _nextPage(context),
                isLoading: controller.isFinishing,
              ),

              SizedBox(height: AppSizes.s8),
            ],
          ),
        ),
      ),
    );
  }
}
