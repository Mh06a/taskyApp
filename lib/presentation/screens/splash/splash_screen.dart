import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _start();
    });
  }

  Future<void> _start() async {
    final navigator = Navigator.of(context);

    final destination = await context
        .read<SplashController>()
        .resolveDestination();

    if (!mounted) return;

    navigator.pushReplacementNamed(destination.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppSizes.splashLogo,
              height: AppSizes.splashLogo,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(AppSizes.r24),
              ),
              child: Icon(
                Icons.check_rounded,
                color: theme.colorScheme.onPrimary,
                size: AppSizes.icon32,
              ),
            ),
            SizedBox(height: AppSizes.s16),
            Text(
              'tasky',
              style: theme.textTheme.headlineLarge?.copyWith(
                fontSize: AppSizes.font32,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: AppSizes.s8),
            Text(
              'A little focus. A lighter day.',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}