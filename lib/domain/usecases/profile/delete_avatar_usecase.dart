import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/repositories/avatar_repository.dart';

final class DeleteAvatarUseCase {
  const DeleteAvatarUseCase(this._repository);

  final AvatarRepository _repository;

  Future<Result<void>> call(String path) {
    return _repository.deleteAvatar(path);
  }
}