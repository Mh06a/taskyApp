import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AvatarStorageDataSource {
  static const String _avatarDirectoryName = 'avatars';

  static const Set<String> _allowedExtensions = {
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
  };

  @visibleForTesting
  static bool isValidFileName(String fileName) {
    if (fileName.isEmpty) return false;
    if (fileName == '.' || fileName == '..') return false;
    if (fileName != p.basename(fileName)) return false;
    return true;
  }

  Future<Directory> _getAvatarDirectory() async {
    final appDirectory = await getApplicationSupportDirectory();
    final avatarDirectory = Directory(
      p.join(appDirectory.path, _avatarDirectoryName),
    );

    if (!await avatarDirectory.exists()) {
      await avatarDirectory.create(recursive: true);
    }

    return avatarDirectory;
  }

  Future<String> saveAvatar(String sourcePath) async {
    final sourceFile = File(sourcePath);

    if (!await sourceFile.exists()) {
      throw const FileSystemException('Source image does not exist.');
    }

    final avatarDirectory = await _getAvatarDirectory();
    final fileName =
        'avatar_${DateTime.now().microsecondsSinceEpoch}'
        '${_safeExtension(sourcePath)}';

    final savedFile = await sourceFile.copy(
      p.join(avatarDirectory.path, fileName),
    );

    return savedFile.path;
  }


  Future<String?> resolve(String fileName) async {
    if (!isValidFileName(fileName)) return null;

    final avatarDirectory = await _getAvatarDirectory();
    final joinedPath = p.join(avatarDirectory.path, fileName);

    if (!p.isWithin(avatarDirectory.path, joinedPath)) {
      return null;
    }

    return joinedPath;
  }


  Future<String?> fileNameIfOwned(String path) async {
    if (path.isEmpty) return null;

    final file = File(path);

    if (!await file.exists()) return null;

    if (!await _isOwned(path)) return null;

    return p.basename(path);
  }

  Future<void> deleteIfOwned(String path) async {
    if (!await _isOwned(path)) return;

    final file = File(path);

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<bool> _isOwned(String path) async {
    if (path.isEmpty) return false;

    final avatarDirectory = await _getAvatarDirectory();
    final directoryPath = await avatarDirectory.resolveSymbolicLinks();
    final filePath = await _canonicalPath(path);

    return p.isWithin(directoryPath, filePath);
  }

  Future<String> _canonicalPath(String path) async {
    final file = File(path);

    if (await file.exists()) {
      return file.resolveSymbolicLinks();
    }

    return p.canonicalize(path);
  }

  String _safeExtension(String path) {
    final extension = p.extension(path).toLowerCase();

    return _allowedExtensions.contains(extension) ? extension : '.jpg';
  }
}
