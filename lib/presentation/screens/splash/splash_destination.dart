import 'package:tasky/core/constants/app_routes.dart';

/// Where the app goes once start-up work is finished.
enum SplashDestination {
  onboarding(AppRoutes.onboarding),
  welcome(AppRoutes.welcome),
  main(AppRoutes.main);

  const SplashDestination(this.routeName);

  final String routeName;
}
