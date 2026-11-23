import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:tasky/core/constants/database_constants.dart';
import 'package:tasky/data/datasources/local/avatar_storage_data_source.dart';
import 'package:tasky/data/models/user_profile_model.dart';
import 'package:tasky/data/services/database_service.dart';

abstract interface class ProfileLocalDataSource {
  Future<UserProfileModel?> getProfile();

  Future<void> saveProfile(UserProfileModel profile);

  Future<void> clearProfile();
}

final class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl(
      this._databaseService,
      this._avatarStorage,
      );

  final DatabaseService _databaseService;
  final AvatarStorageDataSource _avatarStorage;

  //getProfile
  @override
  Future<UserProfileModel?> getProfile() async {
    final db = await _databaseService.database;

    final rows = await db.query(
      ProfileTable.name,
      where: '${ProfileTable.id} = ?',
      whereArgs: [ProfileTable.defaultId],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final row = rows.first;

    final avatarFileName = row[ProfileTable.avatarFile];

    final avatarPath = avatarFileName is String
        ? await _avatarStorage.resolve(avatarFileName)
        : null;

    return UserProfileModel.fromMap(
      row,
      avatarPath: avatarPath,
    );
  }

  //saveProfile
  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    final db = await _databaseService.database;

    final previousPath = (await getProfile())?.avatarPath;

    final avatarPath = profile.avatarPath;

    final avatarFileName = avatarPath == null
        ? null
        : await _avatarStorage.fileNameIfOwned(avatarPath);

    final data = profile.toMap(
      avatarFileName: avatarFileName,
    );

    data[ProfileTable.id] = ProfileTable.defaultId;

    await db.insert(
      ProfileTable.name,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (previousPath != null && previousPath != avatarPath) {
      await _avatarStorage.deleteIfOwned(previousPath);
    }
  }

  //clearProfile
  @override
  Future<void> clearProfile() async {
    final db = await _databaseService.database;

    final avatarPath = (await getProfile())?.avatarPath;

    await db.delete(
      ProfileTable.name,
      where: '${ProfileTable.id} = ?',
      whereArgs: [ProfileTable.defaultId],
    );

    if (avatarPath == null) return;

    try {
      await _avatarStorage.deleteIfOwned(avatarPath);
    } on FileSystemException {
      // Profile is already deleted.
      // Avatar cleanup is best-effort.
    }
  }
}
