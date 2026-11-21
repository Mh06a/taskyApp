import 'package:tasky/data/models/user_profile_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasky/core/constants/storage_keys.dart';
import 'package:tasky/core/errors/exceptions.dart';
import 'package:tasky/data/datasources/avatar_storage_data_source.dart';


abstract interface class ProfileLocalDataSource {
  Future<UserProfileModel?> getProfile();

  Future<void> saveProfile(UserProfileModel profile);

  Future<void> clearProfile();
}



final class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl(this._preferences, this._avatarStorage);

  static const String _avatarFileKey = 'avatarFile';
  static const String _legacyAvatarPathKey = 'avatarPath';
  final SharedPreferences _preferences;
  final AvatarStorageDataSource _avatarStorage;

  //getProfile
  @override
  Future<UserProfileModel?> getProfile() async {
    final json = _readJson();

    if (json == null) return null;

    try {
      final avatarPath = await _resolveAvatarPath(json);

      return UserProfileModel.fromJson(json, avatarPath: avatarPath);
    } on TypeError {
      return null;
    }
  }

  //saveProfile
  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    final previousPath = (await getProfile())?.avatarPath;
    final avatarPath = profile.avatarPath;
    final avatarFileName = avatarPath == null
        ? null
        : await _avatarStorage.fileNameIfOwned(avatarPath);

    final saved = await _preferences.setString(
      StorageKeys.userProfile,
      jsonEncode(profile.toJson(avatarFileName: avatarFileName)),
    );

    if (!saved) {
      throw const StorageException('Could not save the profile.');
    }

    if (previousPath != null && previousPath != avatarPath) {
      await _avatarStorage.deleteIfOwned(previousPath);
    }
  }

  //clearProfile
  @override
  Future<void> clearProfile() async {
    final avatarPath = (await getProfile())?.avatarPath;

    final removed = await _preferences.remove(StorageKeys.userProfile);

    if (!removed) {
      throw const StorageException('Could not clear the profile.');
    }

    if (avatarPath == null) return;

    try {
      await _avatarStorage.deleteIfOwned(avatarPath);
    } on FileSystemException {
      // The profile is already cleared; file cleanup is best-effort.
    }
  }

  Map<String, dynamic>? _readJson() {
    final raw = _preferences.getString(StorageKeys.userProfile);

    if (raw == null) return null;

    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }


  Future<String?> _resolveAvatarPath(Map<String, dynamic> json) async {
    final fileName = json[_avatarFileKey];

    if (fileName is String) return _avatarStorage.resolve(fileName);

    final legacyPath = json[_legacyAvatarPathKey];

    if (legacyPath is! String) return null;

    final legacyFileName = await _avatarStorage.fileNameIfOwned(legacyPath);

    if (legacyFileName == null) return null;

    return _avatarStorage.resolve(legacyFileName);
  }
}
