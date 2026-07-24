import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:second_project/core/constants/storage_key.dart';
import 'package:second_project/features/navigation/main_screen.dart';
import 'package:second_project/features/tasks/tasks_controller.dart';
import 'package:second_project/features/welcome/welcome_screen.dart';
import 'package:second_project/core/services/preferences_manager.dart';
import 'package:second_project/core/themes/dark_theme.dart';
import 'package:second_project/core/themes/light_theme.dart';
import 'package:second_project/core/themes/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await PreferencesManager().init();

  ThemeController().init();

  String? username = PreferencesManager().getString(StorageKey.username);
  runApp(MyApp(username: username));
}

class MyApp extends StatelessWidget {
  //step1 ---- Create vars for class :
  final String? username;

  const MyApp({super.key, this.username});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ThemeController.valueNotifier,
      builder: (context, ThemeMode value, Widget? child) {
        return ChangeNotifierProvider<TasksController>(
          create: (context) => TasksController()..init(),
          child: ScreenUtilInit(
            minTextAdapt: true,
            designSize: Size(375, 809),
            builder: (context, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Tasky',
                theme: lightTheme,
                themeMode: value,
                darkTheme: darkTheme,
                home: username == null ? WelcomeScreen() : MainScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
