import 'package:flutter/material.dart';
import 'package:tasky/core/enums/async_status.dart';
import 'package:tasky/domain/entities/user_profile.dart';
import 'package:tasky/domain/usecases/profile/get_profile.dart';
import 'package:tasky/domain/usecases/profile/save_profile.dart';
import 'package:tasky/domain/usecases/profile/clear_user_data.dart';

class ProfileController extends ChangeNotifier {
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
  String? _errorMessage;

  // State
  UserProfile? get profile => _profile;
  AsyncStatus get loadStatus => _loadStatus;
  AsyncStatus get saveStatus => _saveStatus;
  String? get errorMessage => _errorMessage;

  // Compatibility
  bool get isLoading => _loadStatus == AsyncStatus.loading;
  bool get isSaving => _saveStatus == AsyncStatus.loading;

  // Derived
  String get displayName {
    final name = _profile?.name.trim() ?? '';
    return name.isEmpty ? 'Your name' : name;
  }

  // Load
  Future<void> loadProfile() async {
    _loadStatus = AsyncStatus.loading;
    _errorMessage = null;

    notifyListeners();

    final result = await _getProfile();

    result.when(
      ok: (profile) {
        _profile = profile;
        _loadStatus = AsyncStatus.success;
      },
      err: (failure) {
        debugPrint('Controller load failed: $failure');
        _loadStatus = AsyncStatus.failure;
        _errorMessage = 'Something went wrong. Please try again.';
      },
    );

    notifyListeners();
  }

  // Save
  Future<bool> save({
    required String name,
    String quote = '',
    String? avatarPath,
    bool removeAvatar = false,
  }) async {
    _saveStatus = AsyncStatus.loading;
    _errorMessage = null;

    notifyListeners();

    final current = _profile;

    final updatedProfile = UserProfile(
      name: name,
      quote: quote,
      avatarPath: removeAvatar
          ? null
          : avatarPath ?? current?.avatarPath,
    );

    final result = await _saveProfile(updatedProfile);

    var success = false;

    result.when(
      ok: (savedProfile) {
        _profile = savedProfile;
        _saveStatus = AsyncStatus.success;
        success = true;
      },
      err: (failure) {
        debugPrint('Controller save failed: $failure');
        _saveStatus = AsyncStatus.failure;
        _errorMessage = 'Something went wrong. Please try again.';
      },
    );

    notifyListeners();

    return success;
  }

  Future<bool> clearUserData() async {
    _saveStatus = AsyncStatus.loading;
    _errorMessage = null;
    notifyListeners();
    final result = await _clearUserData();
    var success = false;
    result.when(
      ok: (_) { _profile = null; _saveStatus = AsyncStatus.success; success = true; },
      err: (_) { _saveStatus = AsyncStatus.failure; _errorMessage = 'Could not clear data. Please try again.'; },
    );
    notifyListeners();
    return success;
  }

  // Error
  void clearError() {
    _errorMessage = null;

    if (_saveStatus == AsyncStatus.failure) {
      _saveStatus = AsyncStatus.initial;
    }

    notifyListeners();
  }
}