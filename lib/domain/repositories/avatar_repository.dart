import 'package:tasky/core/utils/result.dart';

abstract class AvatarRepository {
  Future<Result<String>> saveAvatar(String sourcePath);

  Future<Result<void>> deleteAvatar(String path);
}