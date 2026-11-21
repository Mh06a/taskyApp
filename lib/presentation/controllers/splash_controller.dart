import 'package:tasky/domain/usecases/onboarding/get_onboarding_status.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/controllers/settings_controller.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/presentation/screens/splash/splash_destination.dart';

/// Loads what the app needs at start-up and decides the first screen.
class SplashController {
  const SplashController({
    required SettingsController settingsController,
    required ProfileController profileController,
    required TasksController tasksController,
    required GetOnboardingStatus getOnboardingStatus,
  }) : _settingsController = settingsController,
       _profileController = profileController,
       _tasksController = tasksController,
       _getOnboardingStatus = getOnboardingStatus;

  static const Duration minimumDuration = Duration(milliseconds: 1200);

  final SettingsController _settingsController;
  final ProfileController _profileController;
  final TasksController _tasksController;
  final GetOnboardingStatus _getOnboardingStatus;

  Future<SplashDestination> resolveDestination() async {
    final minimumDelay = Future<void>.delayed(minimumDuration);

    // Settings first, so the theme and language are correct from the start.
    await _settingsController.loadSettings();

    if (!_getOnboardingStatus()) {
      await minimumDelay;
      return SplashDestination.onboarding;
    }

    await Future.wait([
      _profileController.loadProfile(),
      _tasksController.loadTasks(),
    ]);

    await minimumDelay;

    return _profileController.profile == null
        ? SplashDestination.welcome
        : SplashDestination.main;
  }
}
