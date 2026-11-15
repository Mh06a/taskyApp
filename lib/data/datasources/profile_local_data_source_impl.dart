import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constants/storage_keys.dart';
import 'package:tasky/core/errors/exceptions.dart';
import 'package:tasky/data/datasources/profile_local_data_source.dart';
import 'package:tasky/data/models/user_profile_model.dart';

final class ProfileLocalDataSourceImpl
    implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<UserProfileModel?> getProfile() async {
    final raw = _preferences.getString(StorageKeys.userProfile);

    if (raw == null) return null;

    try {
      return UserProfileModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    final saved = await _preferences.setString(
      StorageKeys.userProfile,
      jsonEncode(profile.toJson()),
    );

    if (!saved) {
      throw const StorageException('Could not save the profile.');
    }
  }

  @override
  Future<void> clearProfile() async {
    final avatarPath = (await getProfile())?.avatarPath;

    final removed = await _preferences.remove(
      StorageKeys.userProfile,
    );

    if (!removed) {
      throw const StorageException('Could not clear the profile.');
    }

    if (avatarPath != null) {
      try {
        await _deleteFile(avatarPath);
      } on FileSystemException {
        // Profile is already cleared.
      }
    }
  }

  Future<void> _deleteFile(String path) async {
    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }
}