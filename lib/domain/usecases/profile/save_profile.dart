import 'dart:developer' as developer;

import 'package:tasky/core/utils/result.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/domain/entities/user_profile.dart';
import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/domain/repositories/profile_repository.dart';
import 'package:tasky/domain/usecases/profile/delete_avatar_usecase.dart';

final class SaveProfile {
  const SaveProfile(
      this._repository,
      this._deleteAvatar,
      );

  final ProfileRepository _repository;
  final DeleteAvatarUseCase _deleteAvatar;

  Future<Result<UserProfile>> call(UserProfile profile) async {
    final cleaned = profile.copyWith(
      name: profile.name.trim(),
      quote: profile.quote.trim(),
    );

    final error =
        Validators.userName(cleaned.name) ??
            Validators.quote(cleaned.quote);

    if (error != null) {
      return Err<UserProfile>(ValidationFailure(error));
    }

    // Get the existing profile before updating it.
    final currentResult = await _repository.getProfile();

    if (currentResult.isErr) {
      return Err<UserProfile>(currentResult.failureOrNull!);
    }

    final previousProfile = currentResult.valueOrNull;

    // Persist the updated profile first.
    final saveResult = await _repository.saveProfile(cleaned);

    if (saveResult.isErr) {
      return Err<UserProfile>(saveResult.failureOrNull!);
    }

    // Delete the old avatar only after profile persistence succeeds.
    final previousAvatarPath = previousProfile?.avatarPath;
    final newAvatarPath = cleaned.avatarPath;

    if (previousAvatarPath != null &&
        previousAvatarPath != newAvatarPath) {
      final deleteResult = await _deleteAvatar(previousAvatarPath);

      deleteResult.when(
        ok: (_) {},
        err: (failure) {
          developer.log(
            'Profile saved, but old avatar cleanup failed.',
            name: 'tasky.profile',
            error: failure,
          );
        },
      );
    }

    return Ok<UserProfile>(cleaned);
  }
}
