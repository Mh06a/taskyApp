import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/core/enums/async_status.dart';
import 'package:tasky/core/enums/validation_error.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/domain/usecases/profile/delete_avatar_usecase.dart';
import 'package:tasky/domain/usecases/profile/save_avatar_usecase.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';

class EditProfileController extends ChangeNotifier {
  EditProfileController({
    required ProfileController profileController,
    required SaveAvatarUseCase saveAvatar,
    required DeleteAvatarUseCase deleteAvatar,
  })  : _profileController = profileController,
        _saveAvatar = saveAvatar,
        _deleteAvatarUseCase = deleteAvatar {
    final profile = profileController.profile;

    _name = profile?.name ?? '';
    _quote = profile?.quote ?? '';
    _avatarPath = profile?.avatarPath;
    _originalAvatarPath = _avatarPath;
  }

  final ProfileController _profileController;
  final SaveAvatarUseCase _saveAvatar;
  final DeleteAvatarUseCase _deleteAvatarUseCase;
  final ImagePicker _imagePicker = ImagePicker();
  String _name = '';
  String _quote = '';
  String? _avatarPath;
  String? _originalAvatarPath;
  String? _pendingAvatarPath;
  String? nameError;
  String? quoteError;
  String? errorMessage;
  AsyncStatus saveStatus = AsyncStatus.initial;
  bool isPickingAvatar = false;
  bool _validated = false;
  bool _disposed = false;

  // State
  String get name => _name;
  String get quote => _quote;
  String? get avatarPath => _avatarPath;
  bool get hasAvatar => _avatarPath != null;
  bool get isSaving => saveStatus == AsyncStatus.loading;
  bool get isBusy => isSaving || isPickingAvatar;

  // Update fields
  void updateName(String value) {
    if (_disposed) return;

    _name = value;

    if (_validated) {
      _validateName();
    }

    notifyListeners();
  }

  void updateQuote(String value) {
    if (_disposed) return;

    _quote = value;

    if (_validated) {
      _validateQuote();
    }

    notifyListeners();
  }

  // Validation
  bool validate() {
    if (_disposed) return false;

    _validated = true;

    _validateName();
    _validateQuote();

    notifyListeners();

    return nameError == null && quoteError == null;
  }

  void _validateName() {
    nameError = switch (Validators.userName(_name.trim())) {
      null => null,
      ValidationError.nameEmpty => 'Name is required',
      ValidationError.nameTooLong =>
      'Name cannot exceed ${Limits.userName} characters',
      _ => null,
    };
  }

  void _validateQuote() {
    quoteError = switch (Validators.quote(_quote.trim())) {
      null => null,
      ValidationError.quoteTooLong =>
      'Quote cannot exceed ${Limits.quote} characters',
      _ => null,
    };
  }

  // Avatar
  Future<void> pickAvatar() async {
    if (_disposed || isBusy) return;

    isPickingAvatar = true;
    errorMessage = null;

    notifyListeners();

    String? savedPath;

    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 900,
      );

      if (image == null || _disposed) return;

      final result = await _saveAvatar(image.path);

      savedPath = result.when(
        ok: (path) => path,
        err: (failure) {
          debugPrint('Avatar save failed: $failure');

          if (!_disposed) {
            errorMessage = 'Could not save selected photo.';
          }

          return null;
        },
      );

      if (savedPath == null) return;

      if (_disposed) {
        await _cleanupAvatar(savedPath);
        savedPath = null;
        return;
      }

      final previousPendingPath = _pendingAvatarPath;

      _pendingAvatarPath = savedPath;
      _avatarPath = savedPath;

      savedPath = null;

      if (previousPendingPath != null) {
        await _cleanupAvatar(previousPendingPath);
      }
    } catch (error) {
      debugPrint('Avatar selection failed: $error');

      if (!_disposed) {
        errorMessage = 'Could not select photo.';
      }
    } finally {
      if (savedPath != null) {
        await _cleanupAvatar(savedPath);
      }

      isPickingAvatar = false;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  void removeAvatar() {
    if (_disposed || isBusy || !hasAvatar) return;

    _avatarPath = null;
    errorMessage = null;

    notifyListeners();
  }

  // Save profile
  Future<bool> save() async {
    if (_disposed || isBusy || !validate()) {
      return false;
    }

    saveStatus = AsyncStatus.loading;
    errorMessage = null;

    notifyListeners();

    try {
      final success = await _profileController.save(
        name: _name.trim(),
        quote: _quote.trim(),
        avatarPath: _avatarPath,
        removeAvatar: _avatarPath == null &&
            _originalAvatarPath != null,
      );

      if (success) {
        await _cleanupUncommittedAvatar();

        _originalAvatarPath =
            _profileController.profile?.avatarPath;

        _pendingAvatarPath = null;
      } else if (_disposed) {
        await _cleanupPendingAvatar();
      }

      saveStatus = success
          ? AsyncStatus.success
          : AsyncStatus.failure;

      if (!success && !_disposed) {
        errorMessage = _profileController.errorMessage ??
            'Could not save profile.';
      }

      if (!_disposed) {
        notifyListeners();
      }

      return success;
    } catch (error) {
      debugPrint('Profile save failed: $error');

      saveStatus = AsyncStatus.failure;

      if (_disposed) {
        await _cleanupPendingAvatar();
      } else {
        errorMessage = 'Could not save profile.';
        notifyListeners();
      }

      return false;
    }
  }

  // Avatar cleanup
  Future<void> _cleanupUncommittedAvatar() async {
    final pendingPath = _pendingAvatarPath;

    if (pendingPath == null) return;

    final savedPath = _profileController.profile?.avatarPath;

    if (pendingPath != savedPath) {
      await _cleanupAvatar(pendingPath);
    }
  }

  Future<void> _cleanupPendingAvatar() async {
    final pendingPath = _pendingAvatarPath;

    if (pendingPath == null) return;

    _pendingAvatarPath = null;

    final savedPath = _profileController.profile?.avatarPath;

    if (pendingPath != savedPath) {
      await _cleanupAvatar(pendingPath);
    }
  }

  Future<void> _cleanupAvatar(String path) async {
    try {
      final result = await _deleteAvatarUseCase(path);

      result.when(
        ok: (_) {},
        err: (failure) {
          debugPrint('Avatar deletion failed: $failure');
        },
      );
    } catch (error) {
      debugPrint('Avatar deletion threw an exception: $error');
    }
  }

  // Dispose
  @override
  void dispose() {
    _disposed = true;

    // If a profile save is running, let save() handle cleanup
    // after the operation completes.
    if (!isSaving) {
      unawaited(_cleanupPendingAvatar());
    }

    super.dispose();
  }
}
