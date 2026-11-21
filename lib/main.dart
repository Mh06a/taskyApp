import 'package:flutter/material.dart';
import 'package:tasky/app/di/app_dependencies.dart';
import 'package:tasky/presentation/app/tasky_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dependencies = await AppDependencies.create();

  runApp(
    TaskyApp(
      dependencies: dependencies,
    ),
  );
}