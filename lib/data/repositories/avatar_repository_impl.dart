import 'package:tasky/core/utils/guard.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/data/datasources/local/avatar_storage_data_source.dart';
import 'package:tasky/domain/repositories/avatar_repository.dart';

class AvatarRepositoryImpl implements AvatarRepository {
  final AvatarStorageDataSource storageService;

  AvatarRepositoryImpl({
    required this.storageService,
  });

  @override
  Future<Result<String>> saveAvatar(String sourcePath) {
    return guard<String>(
          () => storageService.saveAvatar(sourcePath),
    );
  }

  @override
  Future<Result<void>> deleteAvatar(String path) {
    return guard<void>(
          () => storageService.deleteIfOwned(path),
    );
  }
}