import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/repositories/avatar_repository.dart';

final class SaveAvatarUseCase {
  const SaveAvatarUseCase(this._repository);

  final AvatarRepository _repository;

  Future<Result<String>> call(String sourcePath) {
    return _repository.saveAvatar(sourcePath);
  }
}