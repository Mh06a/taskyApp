import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/controllers/onboarding_controller.dart';
import 'package:tasky/presentation/screens/onboarding/data/onboarding_data.dart';
import 'package:tasky/presentation/screens/onboarding/widgets/onboarding_content.dart';
import 'package:tasky/presentation/screens/onboarding/widgets/onboarding_indicator.dart';
import 'package:tasky/presentation/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  bool get _isLastPage =>
      context.read<OnboardingController>().currentPage ==
          OnboardingData.pages.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  // Complete onboarding and navigate to the welcome screen.
  Future<void> _finishOnboarding() async {
    final success = await context
        .read<OnboardingController>()
        .finishOnboarding();

    if (!mounted) return;

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
  void _nextPage() {
    if (_isLastPage) {
      _finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();

    final isLastPage =
        controller.currentPage == OnboardingData.pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(AppSizes.s24),
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
                        : _finishOnboarding,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
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
                controller: _pageController,
                count: OnboardingData.pages.length,
              ),

               SizedBox(height: AppSizes.s24),

              AppButton(
                text: isLastPage ? 'Get started' : 'Continue',
                onPressed: controller.isFinishing ? null : _nextPage,
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
