import 'package:tasky/core/utils/result.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/domain/entities/user_profile.dart';
import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/domain/repositories/profile_repository.dart';

final class SaveProfile {
  const SaveProfile(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile>> call(UserProfile profile) async {
    final cleaned = profile.copyWith(
      name: profile.name.trim(),
      quote: profile.quote.trim(),
    );

    final error =
        Validators.userName(cleaned.name) ?? Validators.quote(cleaned.quote);
    if (error != null) return Err<UserProfile>(ValidationFailure(error));

    final saved = await _repository.saveProfile(cleaned);
    return saved.map((_) => cleaned);
  }
}
