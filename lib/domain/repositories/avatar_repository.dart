
abstract class AvatarRepository {
  Future<String> saveAvatar(String sourcePath);

  Future<void> deleteAvatar(String path);
}
