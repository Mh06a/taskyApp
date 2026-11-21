import 'package:tasky/domain/repositories/avatar_repository.dart';

class AvatarUseCase {
  final AvatarRepository repository;

  AvatarUseCase({
    required this.repository,
  });

  Future<String> saveAvatar(String sourcePath) {
    return repository.saveAvatar(sourcePath);
  }

  Future<void> deleteAvatar(String path) {
    return repository.deleteAvatar(path);
  }
}
