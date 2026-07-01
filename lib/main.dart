import 'package:flutter/material.dart';
import 'package:second_project/Views/main_screen.dart';
import 'package:second_project/Views/welcome_screen.dart';
import 'package:second_project/services/preferences_manager.dart';
import 'package:second_project/themes/dark_theme.dart';
import 'package:second_project/themes/light_theme.dart';
import 'package:second_project/themes/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesManager().init();

  ThemeController().init();

  String? username = PreferencesManager().getString("username");
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tasky',
          theme: lightTheme,
          themeMode: value,
          darkTheme: darkTheme,
          home: username == null ? WelcomeScreen() : MainScreen(),
        );
      },
    );
  }
}
