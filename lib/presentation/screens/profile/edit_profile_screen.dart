import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/core/enums/validation_error.dart';
import 'package:tasky/domain/usecases/profile/save_avatar_usecase.dart';
import 'package:tasky/presentation/widgets/app_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _quoteController;

  late final AvatarUseCase _avatarUseCase;

  String? _avatarPath;

  /// Avatar copied into app storage during this session but not saved yet.
  String? _pendingAvatarPath;

  bool _removeAvatar = false;
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();

    _avatarUseCase = context.read<AvatarUseCase>();

    final profile = context.read<ProfileController>().profile;

    _nameController = TextEditingController(
      text: profile?.name ?? '',
    );

    _quoteController = TextEditingController(
      text: profile?.quote ?? '',
    );

    _avatarPath = profile?.avatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quoteController.dispose();

    final pending = _pendingAvatarPath;

    if (!_isSaved && pending != null) {
      _deleteAvatarQuietly(pending);
    }

    super.dispose();
  }
  void _showAvatarError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _deleteAvatarQuietly(String path) async {
    final result = await _avatarUseCase.deleteAvatar(path);

    result.when(
      ok: (_) {},
      err: (failure) {
        debugPrint('Failed to delete avatar: $failure');
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 900,
      );

      if (image == null || !mounted) return;

      final saveResult = await _avatarUseCase.saveAvatar(image.path);

      final permanentPath = saveResult.when<String?>(
        ok: (path) => path,
        err: (failure) {
          _showAvatarError('Could not save selected photo.');
          debugPrint('Avatar save failed: $failure');
          return null;
        },
      );

      if (permanentPath == null) return;

      final previousPending = _pendingAvatarPath;

      if (previousPending != null) {
        await _deleteAvatarQuietly(previousPending);
      }

      if (!mounted) {
        await _deleteAvatarQuietly(permanentPath);
        return;
      }

      setState(() {
        _pendingAvatarPath = permanentPath;
        _avatarPath = permanentPath;
        _removeAvatar = false;
      });
    } catch (e) {
      _showAvatarError('Could not select photo.');
      debugPrint('Image picker failed: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final success = await context.read<ProfileController>().save(
      name: _nameController.text.trim(),
      quote: _quoteController.text.trim(),
      avatarPath: _avatarPath,
      removeAvatar: _removeAvatar,
    );

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      _isSaved = true;

      // A picked image that was removed again before saving is unused.
      final pending = _pendingAvatarPath;
      if (pending != null && pending != _avatarPath) {
        await _deleteAvatarQuietly(pending);
      }
    }

    if (!success) {
      final message =
          context.read<ProfileController>().errorMessage ??
              'Could not save profile';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: _avatarPath != null && !_removeAvatar && File(_avatarPath!).existsSync()
                          ? FileImage(File(_avatarPath!))
                          : null,
                      child: _avatarPath == null || _removeAvatar
                          ? const Icon(
                        Icons.person_outline_rounded,
                        size: 42,
                      )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text('Change photo'),
                    ),
                    if (_avatarPath != null && !_removeAvatar)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _removeAvatar = true;
                            _avatarPath = null;
                          });
                        },
                        child: Text(
                          'Remove photo',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Display name',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _nameController,
                maxLength: Limits.userName,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Your name',
                  counterText: '',
                ),
                validator: (value) {
                  final error = Validators.userName(value?.trim() ?? '');
                  return switch (error) {
                    null => null,
                    ValidationError.nameEmpty => 'Name is required',
                    ValidationError.nameTooLong => 'Name cannot exceed ${Limits.userName} characters',
                    _ => null,
                  };
                },
              ),

              const SizedBox(height: 20),

              Text(
                'Motivational quote (optional)',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _quoteController,
                maxLength: Limits.quote,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Small steps count.',
                ),
              ),

              const SizedBox(height: 28),

              AppButton(
                text: 'Save profile',
                isLoading: _isSaving,
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}