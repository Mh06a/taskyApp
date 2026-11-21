import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/screens/onboarding/data/onboarding_data.dart';
import 'package:tasky/domain/usecases/onboarding/complete_onboarding.dart';
import 'package:tasky/presentation/screens/onboarding/widgets/onboarding_page.dart';
import 'package:tasky/presentation/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  int _currentPage = 0;
  bool _isFinishing = false;

  bool get _isLastPage =>
      _currentPage == OnboardingData.pages.length - 1;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  Future<void> _finishOnboarding() async {
    if (_isFinishing) return;

    setState(() {
      _isFinishing = true;
    });

    try {
      await context.read<CompleteOnboarding>().call();

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isFinishing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Please try again.'),
        ),
      );
    }
  }

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

  void _skipOnboarding() {
    _finishOnboarding();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  child: _isLastPage
                      ? const SizedBox.shrink()
                      : TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                ),
              ),

              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: OnboardingData.pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return OnboardingPage(
                      page: OnboardingData.pages[index],
                    );
                  },
                ),
              ),

              SmoothPageIndicator(
                controller: _pageController,
                count: OnboardingData.pages.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: theme.colorScheme.primary,
                  dotColor: theme.colorScheme.outlineVariant,
                  dotHeight: AppSizes.s8,
                  dotWidth: AppSizes.s8,
                  expansionFactor: 3,
                  spacing: AppSizes.s8,
                ),
              ),

              SizedBox(height: AppSizes.s24),

              AppButton(
                text: _isLastPage ? 'Get started' : 'Continue',
                onPressed: _isFinishing ? null : _nextPage,
                isLoading: _isFinishing,
              ),

              SizedBox(height: AppSizes.s8),
            ],
          ),
        ),
      ),
    );
  }
}