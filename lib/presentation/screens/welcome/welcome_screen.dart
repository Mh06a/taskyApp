import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/constants/app_routes.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/core/enums/validation_error.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/widgets/app_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _nameError;
  bool _validated = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    if (_validated) {
      _validateName();
    }
  }

  void _validateName() {
    final name = _nameController.text.trim();
    setState(() {
      _nameError = switch (Validators.userName(name)) {
        null => null,
        ValidationError.nameEmpty => 'Name is required',
        ValidationError.nameTooLong =>
        'Name cannot exceed ${Limits.userName} characters',
        _ => null,
      };
    });
  }

  Future<void> _continue() async {
    setState(() {
      _validated = true;
    });
    _validateName();

    if (_nameError != null) {
      return;
    }

    final name = _nameController.text.trim();
    final profileController = context.read<ProfileController>();

    final success = await profileController.save(
      name: name,
      quote: Limits.defaultQuote,
    );

    if (!mounted) return;

    if (!success) {
      final message = profileController.errorMessage ??
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
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                controller: _nameController,
                maxLength: Limits.userName,
                textCapitalization: TextCapitalization.words,
                enabled: !profileController.isSaving,
                decoration: InputDecoration(
                  labelText: 'Your name',
                  hintText: 'Enter your name',
                  counterText: '',
                  errorText: _nameError,
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Let’s begin',
                onPressed:
                profileController.isSaving ? null : _continue,
                isLoading: profileController.isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
