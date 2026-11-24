import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/controllers/welcome_controller.dart';
import 'package:tasky/presentation/widgets/app_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _continue(BuildContext context) async {
    final controller = context.read<WelcomeController>();
    final success = await controller.continueSave();

    if (!context.mounted) return;

    if (!success) {
      if (controller.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(controller.errorMessage!)),
        );
      }
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<WelcomeController>();
    final profileController = context.watch<ProfileController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSizes.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSizes.s48),
              Text(
                'tasky',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontSize: AppSizes.font22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: AppSizes.s12),
              Text(
                'A lighter day starts here.',
                style: theme.textTheme.headlineLarge,
              ),
              SizedBox(height: AppSizes.s20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSizes.s16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(
                    alpha: 0.16,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Small steps. Real progress.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppSizes.s8),
                    const Text('✓ Review notes'),
                    const Text('✓ Make time for a break'),
                  ],
                ),
              ),
              SizedBox(height: AppSizes.s24),
              Text(
                'Add a task in 3 seconds.\nKnow what matters today.',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: AppSizes.s24),
              TextField(
                controller: controller.nameController,
                maxLength: Limits.userName,
                textCapitalization: TextCapitalization.words,
                enabled: !profileController.isSaving,
                decoration: InputDecoration(
                  labelText: 'Your name',
                  hintText: 'Enter your name',
                  counterText: '',
                  errorText: controller.nameError,
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Let’s begin',
                onPressed:
                profileController.isSaving ? null : () => _continue(context),
                isLoading: profileController.isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
