import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<Result<UserProfile?>> getProfile();

  Future<Result<void>> saveProfile(UserProfile profile);

  Future<Result<void>> clearProfile();
}
