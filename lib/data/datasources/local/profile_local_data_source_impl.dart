import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:tasky/data/constants/profile_table.dart';
import 'package:tasky/data/constants/tasks_table.dart';
import 'package:tasky/core/errors/exceptions.dart';
import 'package:tasky/data/datasources/local/avatar_storage_data_source.dart';
import 'package:tasky/data/datasources/local/profile_local_data_source.dart';
import 'package:tasky/data/models/user_profile_model.dart';
import 'package:tasky/data/services/database_service.dart';

final class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  const ProfileLocalDataSourceImpl(
      this._databaseService,
      this._avatarStorage,
      );

  final DatabaseService _databaseService;
  final AvatarStorageDataSource _avatarStorage;

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

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    final db = await _databaseService.database;

    final avatarPath = profile.avatarPath;

    String? avatarFileName;

    if (avatarPath != null) {
      avatarFileName = await _avatarStorage.fileNameIfOwned(avatarPath);

      if (avatarFileName == null) {
        throw const StorageException(
          'Avatar file is invalid or not owned by the application.',
        );
      }
    }

    final data = profile.toMap(
      avatarFileName: avatarFileName,
    );

    data[ProfileTable.id] = ProfileTable.defaultId;

    await db.insert(
      ProfileTable.name,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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

  @override
  Future<void> clearUserData() async {
    final db = await _databaseService.database;

    // Read avatar path before deleting rows
    final rows = await db.query(
      ProfileTable.name,
      where: '${ProfileTable.id} = ?',
      whereArgs: [ProfileTable.defaultId],
      limit: 1,
    );

    String? avatarPath;
    if (rows.isNotEmpty) {
      final row = rows.first;
      final avatarFileName = row[ProfileTable.avatarFile];
      avatarPath = avatarFileName is String
          ? await _avatarStorage.resolve(avatarFileName)
          : null;
    }

    // Delete tasks table and profile table inside db.transaction atomically
    await db.transaction((txn) async {
      await txn.delete(TasksTable.name);
      await txn.delete(
        ProfileTable.name,
        where: '${ProfileTable.id} = ?',
        whereArgs: [ProfileTable.defaultId],
      );
    });

    // Delete the avatar FILE only after the transaction commits, best-effort
    if (avatarPath == null) return;

    try {
      await _avatarStorage.deleteIfOwned(avatarPath);
    } on FileSystemException {
      // Avatar cleanup is best-effort.
    }
  }
}
