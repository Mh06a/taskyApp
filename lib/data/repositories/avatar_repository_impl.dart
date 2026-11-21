import 'package:tasky/data/datasources/avatar_storage_data_source.dart';
import 'package:tasky/domain/repositories/avatar_repository.dart';

class AvatarRepositoryImpl implements AvatarRepository {
  final AvatarStorageDataSource storageService;

  AvatarRepositoryImpl({
    required this.storageService,
  });

  @override
  Future<String> saveAvatar(String sourcePath) {
    return storageService.saveAvatar(sourcePath);
  }

  @override
  Future<void> deleteAvatar(String path) {
    return storageService.deleteIfOwned(path);
  }
}
