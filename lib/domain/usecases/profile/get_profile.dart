import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/entities/user_profile.dart';
import 'package:tasky/domain/repositories/profile_repository.dart';

final class GetProfile {
  const GetProfile(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile?>> call() => _repository.getProfile();
}
