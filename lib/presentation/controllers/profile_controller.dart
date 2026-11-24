import 'package:flutter/foundation.dart';
import 'package:tasky/core/enums/async_status.dart';
import 'package:tasky/domain/entities/user_profile.dart';
import 'package:tasky/domain/usecases/profile/clear_user_data.dart';
import 'package:tasky/domain/usecases/profile/get_profile.dart';
import 'package:tasky/domain/usecases/profile/save_profile.dart';
import 'package:tasky/presentation/controllers/error_message_mixin.dart';

class ProfileController extends ChangeNotifier with ErrorMessageMixin {
  ProfileController({
    required GetProfile getProfile,
    required SaveProfile saveProfile,
    required ClearUserData clearUserData,
  })  : _getProfile = getProfile,
        _saveProfile = saveProfile,
        _clearUserData = clearUserData;

  final GetProfile _getProfile;
  final SaveProfile _saveProfile;
  final ClearUserData _clearUserData;

  UserProfile? _profile;

  AsyncStatus _loadStatus = AsyncStatus.initial;
  AsyncStatus _saveStatus = AsyncStatus.initial;
  AsyncStatus _clearStatus = AsyncStatus.initial;

  // State

  UserProfile? get profile => _profile;

  AsyncStatus get loadStatus => _loadStatus;
  AsyncStatus get saveStatus => _saveStatus;
  AsyncStatus get clearStatus => _clearStatus;

  bool get isLoading => _loadStatus == AsyncStatus.loading;
  bool get isSaving => _saveStatus == AsyncStatus.loading;
  bool get isClearing => _clearStatus == AsyncStatus.loading;

  // Derived

  String get displayName {
    final name = _profile?.name.trim() ?? '';
    return name.isEmpty ? 'Your name' : name;
  }

  // Load

  Future<void> loadProfile() async {
    if (isLoading || isSaving || isClearing) return;

    _loadStatus = AsyncStatus.loading;
    clearError();
    notifyListeners();

    try {
      final result = await _getProfile();

      result.when(
        ok: (profile) {
          _profile = profile;
          _loadStatus = AsyncStatus.success;
        },
        err: (failure) {
          debugPrint('Profile load failed: $failure');
          _loadStatus = AsyncStatus.failure;
          errorMessage = 'Something went wrong. Please try again.';
        },
      );
    } catch (error) {
      debugPrint('Profile load threw an exception: $error');
      _loadStatus = AsyncStatus.failure;
      errorMessage = 'Something went wrong. Please try again.';
    }

    notifyListeners();
  }

  // Save

  Future<bool> save({
    required String name,
    String quote = '',
    String? avatarPath,
    bool removeAvatar = false,
  }) async {
    if (isLoading || isSaving || isClearing) return false;

    _saveStatus = AsyncStatus.loading;
    clearError();
    notifyListeners();

    final current = _profile;

    final updatedProfile = UserProfile(
      name: name,
      quote: quote,
      avatarPath: removeAvatar
          ? null
          : avatarPath ?? current?.avatarPath,
    );

    var success = false;

    try {
      final result = await _saveProfile(updatedProfile);

      result.when(
        ok: (savedProfile) {
          _profile = savedProfile;
          _saveStatus = AsyncStatus.success;
          success = true;
        },
        err: (failure) {
          debugPrint('Profile save failed: $failure');
          _saveStatus = AsyncStatus.failure;
          errorMessage = 'Something went wrong. Please try again.';
        },
      );
    } catch (error) {
      debugPrint('Profile save threw an exception: $error');
      _saveStatus = AsyncStatus.failure;
      errorMessage = 'Something went wrong. Please try again.';
    }

    notifyListeners();
    return success;
  }

  // Clear user data

  Future<bool> clearUserData() async {
    if (isLoading || isSaving || isClearing) return false;

    _clearStatus = AsyncStatus.loading;
    clearError();
    notifyListeners();

    var success = false;

    try {
      final result = await _clearUserData();

      result.when(
        ok: (_) {
          _profile = null;
          _clearStatus = AsyncStatus.success;
          success = true;
        },
        err: (failure) {
          debugPrint('Profile clear failed: $failure');
          _clearStatus = AsyncStatus.failure;
          errorMessage = 'Could not clear data. Please try again.';
        },
      );
    } catch (error) {
      debugPrint('Profile clear threw an exception: $error');
      _clearStatus = AsyncStatus.failure;
      errorMessage = 'Could not clear data. Please try again.';
    }

    notifyListeners();
    return success;
  }
}
