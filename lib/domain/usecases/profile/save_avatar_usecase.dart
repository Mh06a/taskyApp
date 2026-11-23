import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/repositories/avatar_repository.dart';

final class AvatarUseCase {
  const AvatarUseCase({
    required this.repository,
  });

  final AvatarRepository repository;

  Future<Result<String>> saveAvatar(String sourcePath) {
    return repository.saveAvatar(sourcePath);
  }

  Future<Result<void>> deleteAvatar(String path) {
    return repository.deleteAvatar(path);
  }
}
