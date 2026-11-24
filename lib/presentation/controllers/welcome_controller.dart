import 'package:flutter/material.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/core/enums/validation_error.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/presentation/controllers/error_message_mixin.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';

class WelcomeController extends ChangeNotifier with ErrorMessageMixin {
  WelcomeController({
    required ProfileController profileController,
  }) : _profileController = profileController {
    nameController.addListener(_onNameChanged);
  }

  final ProfileController _profileController;
  final TextEditingController nameController = TextEditingController();

  String? _nameError;
  bool _validated = false;

  String? get nameError => _nameError;
  bool get isSaving => _profileController.isSaving;

  void _onNameChanged() {
    if (_validated) {
      _validateName();
    }
  }

  void _validateName() {
    final name = nameController.text.trim();
    _nameError = switch (Validators.userName(name)) {
      null => null,
      ValidationError.nameEmpty => 'Name is required',
      ValidationError.nameTooLong =>
      'Name cannot exceed ${Limits.userName} characters',
      _ => null,
    };
    notifyListeners();
  }

  Future<bool> continueSave() async {
    _validated = true;
    _validateName();

    if (_nameError != null) {
      return false;
    }

    clearError();
    final name = nameController.text.trim();
    final success = await _profileController.save(
      name: name,
      quote: Limits.defaultQuote,
    );

    if (!success) {
      errorMessage = _profileController.errorMessage ??
          'Could not save your profile';
    }

    notifyListeners();
    return success;
  }

  @override
  void dispose() {
    nameController.removeListener(_onNameChanged);
    nameController.dispose();
    super.dispose();
  }
}
