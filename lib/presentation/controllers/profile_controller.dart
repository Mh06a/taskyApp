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
  AsyncStatus _clearStatus = AsyncStatus.initial;

  String? _errorMessage;

  // State
  UserProfile? get profile => _profile;

  AsyncStatus get loadStatus => _loadStatus;
  AsyncStatus get saveStatus => _saveStatus;
  AsyncStatus get clearStatus => _clearStatus;

  String? get errorMessage => _errorMessage;

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
    if (isLoading) return;

    _loadStatus = AsyncStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
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
    } catch (error) {
      debugPrint('Controller load threw an exception: $error');
      _loadStatus = AsyncStatus.failure;
      _errorMessage = 'Something went wrong. Please try again.';
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
    if (isSaving || isClearing) return false;

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
          debugPrint('Controller save failed: $failure');
          _saveStatus = AsyncStatus.failure;
          _errorMessage = 'Something went wrong. Please try again.';
        },
      );
    } catch (error) {
      debugPrint('Controller save threw an exception: $error');
      _saveStatus = AsyncStatus.failure;
      _errorMessage = 'Something went wrong. Please try again.';
    }

    notifyListeners();
    return success;
  }

  // Clear user data
  Future<bool> clearUserData() async {
    if (isSaving || isClearing) return false;

    _clearStatus = AsyncStatus.loading;
    _errorMessage = null;
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
          debugPrint('Controller clear failed: $failure');
          _clearStatus = AsyncStatus.failure;
          _errorMessage = 'Could not clear data. Please try again.';
        },
      );
    } catch (error) {
      debugPrint('Controller clear threw an exception: $error');
      _clearStatus = AsyncStatus.failure;
      _errorMessage = 'Could not clear data. Please try again.';
    }

    notifyListeners();
    return success;
  }

  // Error
  void clearError() {
    if (_errorMessage == null) return;

    _errorMessage = null;
    notifyListeners();
  }
}