import 'package:tasky/domain/entities/user_profile.dart';

final class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.name,
    super.quote,
    super.avatarPath,
  });

  factory UserProfileModel.fromEntity(UserProfile profile) {
    return UserProfileModel(
      name: profile.name,
      quote: profile.quote,
      avatarPath: profile.avatarPath,
    );
  }

  factory UserProfileModel.fromMap(
      Map<String, dynamic> map, {
        String? avatarPath,
      }) {
    return UserProfileModel(
      name: map['name'] as String,
      quote: map['quote'] as String? ?? '',
      avatarPath: avatarPath,
    );
  }

  Map<String, dynamic> toMap({
    String? avatarFileName,
  }) {
    return {
      'name': name,
      'quote': quote,
      'avatar_file': avatarFileName,
    };
  }
}
