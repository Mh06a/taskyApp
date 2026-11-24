import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/usecases/onboarding/complete_onboarding.dart';
import 'package:tasky/domain/usecases/onboarding/get_onboarding_status.dart';
import 'package:tasky/domain/usecases/profile/delete_avatar_usecase.dart';
import 'package:tasky/domain/usecases/profile/save_avatar_usecase.dart';
import 'package:tasky/presentation/controllers/edit_profile_controller.dart';
import 'package:tasky/presentation/controllers/main_controller.dart';
import 'package:tasky/presentation/controllers/onboarding_controller.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/controllers/settings_controller.dart';
import 'package:tasky/presentation/controllers/splash_controller.dart';
import 'package:tasky/presentation/controllers/task_form_controller.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/presentation/controllers/welcome_controller.dart';
import 'package:tasky/presentation/screens/main/main_screen.dart';
import 'package:tasky/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:tasky/presentation/screens/profile/edit_profile_screen.dart';
import 'package:tasky/presentation/screens/splash/splash_screen.dart';
import 'package:tasky/presentation/screens/tasks/add_task_screen.dart';
import 'package:tasky/presentation/screens/tasks/task_details_screen.dart';
import 'package:tasky/presentation/screens/welcome/welcome_screen.dart';

/// Maps application route names to their corresponding screens.
abstract final class AppRouter {
  static Route<void>? onGenerateRoute(RouteSettings settings) {
    final page = _buildPage(settings);

    if (page == null) return null;

    return MaterialPageRoute<void>(
      builder: (_) => page,
      settings: settings,
    );
  }

  static Widget? _buildPage(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return Provider<SplashController>(
          create: (context) => SplashController(
            settingsController: context.read<SettingsController>(),
            profileController: context.read<ProfileController>(),
            tasksController: context.read<TasksController>(),
            getOnboardingStatus: context.read<GetOnboardingStatus>(),
          ),
          child: const SplashScreen(),
        );

      case AppRoutes.onboarding:
        return ChangeNotifierProvider<OnboardingController>(
          create: (context) => OnboardingController(
            completeOnboarding: context.read<CompleteOnboarding>(),
          ),
          child: const OnboardingScreen(),
        );

      case AppRoutes.welcome:
        return ChangeNotifierProvider<WelcomeController>(
          create: (context) => WelcomeController(
            profileController: context.read<ProfileController>(),
          ),
          child: const WelcomeScreen(),
        );

      case AppRoutes.main:
        return ChangeNotifierProvider<MainController>(
          create: (_) => MainController(),
          child: const MainScreen(),
        );

      case AppRoutes.taskForm:
        return _buildTaskFormPage(settings.arguments);

      case AppRoutes.taskDetails:
        return _buildTaskDetailsPage(settings.arguments);

      case AppRoutes.editProfile:
        return _buildEditProfilePage();

      default:
        return null;
    }
  }

  static Widget? _buildTaskFormPage(Object? arguments) {
    if (arguments != null && arguments is! Task) {
      return null;
    }

    final editingTask = arguments as Task?;

    return ChangeNotifierProvider<TaskFormController>(
      create: (context) => TaskFormController(
        tasksController: context.read<TasksController>(),
        editingTask: editingTask,
      ),
      child: const AddTaskScreen(),
    );
  }

  static Widget _buildEditProfilePage() {
    return ChangeNotifierProvider<EditProfileController>(
      create: (context) => EditProfileController(
        profileController: context.read<ProfileController>(),
        saveAvatar: context.read<SaveAvatarUseCase>(),
        deleteAvatar: context.read<DeleteAvatarUseCase>(),
      ),
      child: const EditProfileScreen(),
    );
  }

  static Widget? _buildTaskDetailsPage(Object? arguments) {
    if (arguments is! String || arguments.isEmpty) {
      return null;
    }

    return TaskDetailsScreen(taskId: arguments);
  }
}
