import 'package:tasky/core/constants/app_assets.dart';
import 'package:tasky/presentation/screens/onboarding/models/onboarding_page_model.dart';

abstract final class OnboardingData {
  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'Catch it before it slips away.',
      description:
      'One tap to open. Type a title. Save. Add the details only when you need them.',
      imagePath: AppAssets.onboarding1,
    ),
    OnboardingPageModel(
      title: 'See how far you’ve come.',
      description:
      'Check things off and watch your day take shape. Progress, without pressure.',
      imagePath: AppAssets.onboarding2,
    ),
  ];
}