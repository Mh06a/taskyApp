import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/usecases/onboarding/get_onboarding_status.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/controllers/settings_controller.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/presentation/screens/main/main_screen.dart';
import 'package:tasky/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:tasky/presentation/screens/profile/edit_profile_screen.dart';
import 'package:tasky/presentation/controllers/splash_controller.dart';
import 'package:tasky/presentation/screens/splash/splash_screen.dart';
import 'package:tasky/presentation/screens/tasks/add_task_screen.dart';
import 'package:tasky/presentation/controllers/task_form_controller.dart';
import 'package:tasky/presentation/screens/tasks/task_details_screen.dart';
import 'package:tasky/presentation/screens/welcome/welcome_screen.dart';

/// The single place that maps route names to screens.
abstract final class AppRouter {
  static Route<void>? onGenerateRoute(RouteSettings settings) {
    final page = _buildPage(settings);

    if (page == null) return null;

    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }

  static Widget? _buildPage(RouteSettings settings) {
    return switch (settings.name) {
      AppRoutes.splash => Provider<SplashController>(
        create: (context) => SplashController(
          settingsController: context.read<SettingsController>(),
          profileController: context.read<ProfileController>(),
          tasksController: context.read<TasksController>(),
          getOnboardingStatus: context.read<GetOnboardingStatus>(),
        ),
        child: const SplashScreen(),
      ),
      AppRoutes.onboarding => const OnboardingScreen(),
      AppRoutes.welcome => const WelcomeScreen(),
      AppRoutes.main => const MainScreen(),
      AppRoutes.taskForm => ChangeNotifierProvider<TaskFormController>(
        create: (context) => TaskFormController(
          tasksController: context.read<TasksController>(),
          editingTask: settings.arguments as Task?,
        ),
        child: const AddTaskScreen(),
      ),
      AppRoutes.taskDetails => TaskDetailsScreen(
        taskId: settings.arguments! as String,
      ),
      AppRoutes.editProfile => const EditProfileScreen(),
      _ => null,
    };
  }
}
