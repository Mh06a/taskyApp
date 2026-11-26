import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/domain/entities/user_profile.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/domain/repositories/profile_repository.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';
import 'package:tasky/domain/repositories/avatar_repository.dart';
import 'package:tasky/domain/usecases/profile/save_profile.dart';
import 'package:tasky/domain/usecases/profile/delete_avatar_usecase.dart';
import 'package:tasky/domain/usecases/profile/clear_user_data.dart';

class FakeProfileRepository implements ProfileRepository {
  UserProfile? profile;

  @override
  Future<Result<UserProfile?>> getProfile() async => Ok(profile);

  @override
  Future<Result<bool>> saveProfile(UserProfile profile) async {
    this.profile = profile;
    return const Ok(true);
  }

  @override
  Future<Result<bool>> clearProfile() async {
    profile = null;
    return const Ok(true);
  }

  @override
  Future<Result<void>> clearUserData() async {
    profile = null;
    return const Ok(null);
  }
}

class FailingProfileRepository implements ProfileRepository {
  UserProfile? profile = const UserProfile(name: 'Test');

  @override
  Future<Result<UserProfile?>> getProfile() async => Ok(profile);

  @override
  Future<Result<bool>> saveProfile(UserProfile profile) async => const Ok(true);

  @override
  Future<Result<bool>> clearProfile() async => const Ok(true);

  @override
  Future<Result<void>> clearUserData() async => Err(StorageFailure());
}

class FakeTasksRepositoryForProfileTests implements TasksRepository {
  @override
  Future<Result<List<Task>>> getTasks() async => const Ok([]);
  @override
  Future<Result<void>> addTask(Task task) async => const Ok(null);
  @override
  Future<Result<void>> updateTask(Task task) async => const Ok(null);
  @override
  Future<Result<void>> deleteTask(String id) async => const Ok(null);
  @override
  Future<Result<void>> deleteAllTasks() async => const Ok(null);
}

class FakeAvatarRepository implements AvatarRepository {
  @override
  Future<Result<String>> saveAvatar(String sourcePath) async => Ok(sourcePath);
  @override
  Future<Result<void>> deleteAvatar(String path) async => const Ok(null);
}

void main() {
  group('SaveProfile usecase', () {
    test('saves profile successfully and cleans old avatar if changed', () async {
      final repo = FakeProfileRepository();
      repo.profile = const UserProfile(name: 'Old Name', avatarPath: 'old.jpg');

      final deleteAvatar = DeleteAvatarUseCase(FakeAvatarRepository());
      final saveProfile = SaveProfile(repo, deleteAvatar);
      final result = await saveProfile(const UserProfile(name: 'New Name', avatarPath: 'new.jpg'));

      expect(result.isOk, true);
      expect(result.valueOrNull?.name, 'New Name');
      expect(repo.profile?.avatarPath, 'new.jpg');
    });
  });

  group('ClearUserData usecase', () {
    test('success clears user data successfully', () async {
      final profileRepo = FakeProfileRepository();
      profileRepo.profile = const UserProfile(name: 'Test');
      final clearUserData = ClearUserData(
        tasksRepository: FakeTasksRepositoryForProfileTests(),
        profileRepository: profileRepo,
      );

      final result = await clearUserData();
      expect(result.isOk, true);
      expect(profileRepo.profile, isNull);
    });

    test('failure leaves no partial result when repository fails', () async {
      final profileRepo = FailingProfileRepository();
      final clearUserData = ClearUserData(
        tasksRepository: FakeTasksRepositoryForProfileTests(),
        profileRepository: profileRepo,
      );

      final result = await clearUserData();
      expect(result.isErr, true);
      expect(profileRepo.profile, isNotNull);
    });
  });
}
