import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/presentation/widgets/app_button.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _continue() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await context.read<ProfileController>().save(
      name: name,
      quote: 'Small steps count.',
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (!success) {
      final message =
          context.read<ProfileController>().errorMessage ??
              'Could not save your profile';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  color: theme.colorScheme.secondary.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppSizes.r16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Small steps. Real progress.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('✓ Review notes'),
                    Text('✓ Make time for a break'),
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
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Your name',
                  hintText: 'Enter your name',
                ),
              ),

              const Spacer(),

              AppButton(text: 'Let’s begin', onPressed: _continue, isLoading: _isSubmitting),
            ],
          ),
        ),
      ),
    );
  }
}