import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/theme/app_theme.dart';
import 'package:tasky/app/di/app_dependencies.dart';
import 'package:tasky/domain/usecases/onboarding/get_onboarding_status.dart';
import 'package:tasky/domain/usecases/onboarding/complete_onboarding.dart';
import 'package:tasky/presentation/app/app_router.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/controllers/settings_controller.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/domain/usecases/profile/save_avatar_usecase.dart';

class TaskyApp extends StatelessWidget {
  const TaskyApp({
    super.key,
    required this.dependencies,
  });

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GetOnboardingStatus>.value(value: dependencies.getOnboardingStatus),
        Provider<CompleteOnboarding>.value(value: dependencies.completeOnboarding),
        Provider<AvatarUseCase>.value(value: dependencies.avatarUseCase),

        ChangeNotifierProvider<TasksController>.value(
          value: dependencies.tasksController,
        ),

        ChangeNotifierProvider<ProfileController>.value(
          value: dependencies.profileController,
        ),

        ChangeNotifierProvider<SettingsController>.value(
          value: dependencies.settingsController,
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const _TaskyMaterialApp();
        },
      ),
    );
  }
}

class _TaskyMaterialApp extends StatelessWidget {
  const _TaskyMaterialApp();

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settings, child) {
        return MaterialApp(
          title: 'Tasky',
          debugShowCheckedModeBanner: false,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.materialThemeMode,

          locale: settings.locale,
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
