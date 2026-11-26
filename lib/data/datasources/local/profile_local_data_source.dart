import 'package:tasky/data/models/user_profile_model.dart';

abstract interface class ProfileLocalDataSource {
  Future<UserProfileModel?> getProfile();

  Future<void> saveProfile(UserProfileModel profile);

  Future<void> clearProfile();

  Future<void> clearUserData();
}
