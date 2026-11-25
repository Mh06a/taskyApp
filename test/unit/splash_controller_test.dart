import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/core/services/id_generator.dart';
import 'package:tasky/domain/repositories/onboarding_repository.dart';
import 'package:tasky/domain/repositories/settings_repository.dart';
import 'package:tasky/domain/repositories/profile_repository.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';
import 'package:tasky/domain/repositories/avatar_repository.dart';
import 'package:tasky/domain/usecases/onboarding/get_onboarding_status.dart';
import 'package:tasky/domain/usecases/settings/get_settings.dart';
import 'package:tasky/domain/usecases/settings/save_settings.dart';
import 'package:tasky/domain/usecases/profile/get_profile.dart';
import 'package:tasky/domain/usecases/profile/save_profile.dart';
import 'package:tasky/domain/usecases/profile/clear_user_data.dart';
import 'package:tasky/domain/usecases/profile/delete_avatar_usecase.dart';
import 'package:tasky/domain/usecases/tasks/get_tasks.dart';
import 'package:tasky/domain/usecases/tasks/add_task.dart';
import 'package:tasky/domain/usecases/tasks/update_task.dart';
import 'package:tasky/domain/usecases/tasks/delete_task.dart';
import 'package:tasky/domain/usecases/tasks/toggle_task_done.dart';
import 'package:tasky/domain/usecases/tasks/filter_and_sort_tasks.dart';
import 'package:tasky/domain/usecases/tasks/get_task_stats.dart';
import 'package:tasky/domain/usecases/tasks/restore_task.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/controllers/settings_controller.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';
import 'package:tasky/presentation/controllers/splash_controller.dart';
import 'package:tasky/presentation/screens/splash/splash_destination.dart';
import 'package:tasky/domain/entities/user_profile.dart';
import 'package:tasky/domain/entities/app_settings.dart';
import 'package:tasky/domain/entities/task.dart';

class FakeOnboardingRepo implements OnboardingRepository {
  Result<bool> result = const Ok(true);

  @override
  Result<bool> isCompleted() => result;

  @override
  Future<Result<void>> setCompleted() async => const Ok(null);
}

class FakeSettingsRepo implements SettingsRepository {
  @override
  Future<Result<AppSettings>> getSettings() async => const Ok(AppSettings());

  @override
  Future<Result<bool>> saveSettings(AppSettings settings) async => const Ok(true);
}

class FakeProfileRepo implements ProfileRepository {
  @override
  Future<Result<UserProfile?>> getProfile() async => const Ok(null);
  @override
  Future<Result<bool>> saveProfile(UserProfile profile) async => const Ok(true);
  @override
  Future<Result<bool>> clearProfile() async => const Ok(true);
}

class FakeTasksRepo implements TasksRepository {
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

class FakeAvatarRepo implements AvatarRepository {
  @override
  Future<Result<String>> saveAvatar(String sourcePath) async => const Ok('');
  @override
  Future<Result<void>> deleteAvatar(String path) async => const Ok(null);
}

class FakeIdGenerator implements IdGenerator {
  @override
  String generate() => '1';
}

class FakeSettingsController extends SettingsController {
  FakeSettingsController()
      : super(
          getSettings: GetSettings(FakeSettingsRepo()),
          saveSettings: SaveSettings(FakeSettingsRepo()),
        );
}

class FakeProfileController extends ProfileController {
  FakeProfileController({this.userProfile})
      : super(
          getProfile: GetProfile(FakeProfileRepo()),
          saveProfile: SaveProfile(FakeProfileRepo(), DeleteAvatarUseCase(FakeAvatarRepo())),
          clearUserData: ClearUserData(
            tasksRepository: FakeTasksRepo(),
            profileRepository: FakeProfileRepo(),
          ),
        );

  final UserProfile? userProfile;

  @override
  UserProfile? get profile => userProfile;

  @override
  Future<void> loadProfile() async {}
}

class FakeTasksController extends TasksController {
  FakeTasksController()
      : super(
          getTasks: GetTasks(FakeTasksRepo()),
          addTask: AddTask(repository: FakeTasksRepo(), idGenerator: FakeIdGenerator(), clock: DateTime.now),
          updateTask: UpdateTask(FakeTasksRepo()),
          deleteTask: DeleteTask(FakeTasksRepo()),
          toggleTaskDone: ToggleTaskDone(repository: FakeTasksRepo(), clock: DateTime.now),
          filterAndSortTasks: const FilterAndSortTasks(),
          getTaskStats: const GetTaskStats(),
          restoreTask: RestoreTask(FakeTasksRepo()),
          clock: DateTime.now,
        );

  @override
  Future<void> loadTasks() async {}
}

void main() {
  group('SplashController destination logic', () {
    test('returns onboarding when onboarding is not completed', () async {
      final repo = FakeOnboardingRepo()..result = const Ok(false);
      final splash = SplashController(
        settingsController: FakeSettingsController(),
        profileController: FakeProfileController(),
        tasksController: FakeTasksController(),
        getOnboardingStatus: GetOnboardingStatus(repo),
      );

      final dest = await splash.resolveDestination();
      expect(dest, SplashDestination.onboarding);
    });

    test('treats onboarding flag unreadable (Err) as not completed (onboarding)', () async {
      final repo = FakeOnboardingRepo()..result = Err(StorageFailure());
      final splash = SplashController(
        settingsController: FakeSettingsController(),
        profileController: FakeProfileController(),
        tasksController: FakeTasksController(),
        getOnboardingStatus: GetOnboardingStatus(repo),
      );

      final dest = await splash.resolveDestination();
      expect(dest, SplashDestination.onboarding);
    });

    test('returns welcome when onboarding completed but profile is null', () async {
      final repo = FakeOnboardingRepo()..result = const Ok(true);
      final splash = SplashController(
        settingsController: FakeSettingsController(),
        profileController: FakeProfileController(userProfile: null),
        tasksController: FakeTasksController(),
        getOnboardingStatus: GetOnboardingStatus(repo),
      );

      final dest = await splash.resolveDestination();
      expect(dest, SplashDestination.welcome);
    });

    test('returns main when onboarding completed and profile exists', () async {
      final repo = FakeOnboardingRepo()..result = const Ok(true);
      final splash = SplashController(
        settingsController: FakeSettingsController(),
        profileController: FakeProfileController(userProfile: const UserProfile(name: 'Test')),
        tasksController: FakeTasksController(),
        getOnboardingStatus: GetOnboardingStatus(repo),
      );

      final dest = await splash.resolveDestination();
      expect(dest, SplashDestination.main);
    });
  });
}
