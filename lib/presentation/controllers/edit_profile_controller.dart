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

  String get name => _name;
  String get quote => _quote;
  String? get avatarPath => _avatarPath;

  bool get hasAvatar => _avatarPath != null;
  bool get isSaving => saveStatus == AsyncStatus.loading;
  bool get isBusy => isSaving || isPickingAvatar;

  void updateName(String value) {
    _name = value;
    if (_validated) _validateName();
    notifyListeners();
  }

  void updateQuote(String value) {
    _quote = value;
    if (_validated) _validateQuote();
    notifyListeners();
  }

  bool validate() {
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

  Future<void> pickAvatar() async {
    if (isBusy) return;

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
          errorMessage = 'Could not save selected photo.';
          return null;
        },
      );

      if (savedPath == null) return;

      if (_disposed) {
        await _cleanupAvatar(savedPath);
        savedPath = null;
        return;
      }

      final previous = _pendingAvatarPath;

      _pendingAvatarPath = savedPath;
      _avatarPath = savedPath;
      savedPath = null;

      if (previous != null) await _cleanupAvatar(previous);
    } catch (error) {
      debugPrint('Avatar selection failed: $error');
      errorMessage = 'Could not select photo.';
    } finally {
      if (savedPath != null) await _cleanupAvatar(savedPath);
      isPickingAvatar = false;
      if (!_disposed) notifyListeners();
    }
  }

  void removeAvatar() {
    if (isBusy || !hasAvatar) return;

    _avatarPath = null;
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> save() async {
    if (isBusy || !validate()) return false;

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

      saveStatus = success
          ? AsyncStatus.success
          : AsyncStatus.failure;

      if (!success) {
        errorMessage = _profileController.errorMessage ??
            'Could not save profile.';
      } else {
        final pending = _pendingAvatarPath;

        if (pending != null &&
            pending != _profileController.profile?.avatarPath) {
          await _cleanupAvatar(pending);
        }

        _pendingAvatarPath = null;
      }

      notifyListeners();
      return success;
    } catch (error) {
      debugPrint('Profile save failed: $error');
      saveStatus = AsyncStatus.failure;
      errorMessage = 'Could not save profile.';
      notifyListeners();
      return false;
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

  @override
  void dispose() {
    _disposed = true;

    final pending = _pendingAvatarPath;

    if (pending != null &&
        pending != _profileController.profile?.avatarPath) {
      _cleanupAvatar(pending);
    }

    super.dispose();
  }
}