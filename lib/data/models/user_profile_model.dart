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


  factory UserProfileModel.fromJson(
    Map<String, dynamic> json, {
    String? avatarPath,
  }) {
    return UserProfileModel(
      name: json['name'] as String,
      quote: json['quote'] as String? ?? '',
      avatarPath: avatarPath,
    );
  }

  Map<String, dynamic> toJson({String? avatarFileName}) {
    return {
      'name': name,
      'quote': quote,
      'avatarFile': avatarFileName,
    };
  }
}
