import 'package:tasky/data/services/database_service.dart';
import 'package:tasky/core/services/uuid_id_generator.dart';
import 'package:tasky/data/datasources/local/avatar_storage_data_source.dart';
import 'package:tasky/data/datasources/local/profile_local_data_source.dart';
import 'package:tasky/data/datasources/local/onboarding_local_data_source.dart';
import 'package:tasky/data/datasources/local/settings_local_data_source.dart';
import 'package:tasky/data/datasources/local/tasks_local_data_source.dart';
import 'package:tasky/data/repositories/avatar_repository_impl.dart';
import 'package:tasky/data/repositories/profile_repository_impl.dart';
import 'package:tasky/data/repositories/onboarding_repository_impl.dart';
import 'package:tasky/data/repositories/settings_repository_impl.dart';
import 'package:tasky/data/repositories/tasks_repository_impl.dart';
import 'package:tasky/data/services/preferences_manager.dart';
import 'package:tasky/domain/usecases/onboarding/get_onboarding_status.dart';
import 'package:tasky/domain/usecases/onboarding/complete_onboarding.dart';
import 'package:tasky/domain/usecases/profile/get_profile.dart';
import 'package:tasky/domain/usecases/profile/save_avatar_usecase.dart';
import 'package:tasky/domain/usecases/profile/save_profile.dart';
import 'package:tasky/domain/usecases/profile/clear_user_data.dart';
import 'package:tasky/domain/usecases/settings/get_settings.dart';
import 'package:tasky/domain/usecases/settings/save_settings.dart';
import 'package:tasky/domain/usecases/tasks/add_task.dart';
import 'package:tasky/domain/usecases/tasks/delete_task.dart';
import 'package:tasky/domain/usecases/tasks/filter_and_sort_tasks.dart';
import 'package:tasky/domain/usecases/tasks/get_tasks.dart';
import 'package:tasky/domain/usecases/tasks/get_task_stats.dart';
import 'package:tasky/domain/usecases/tasks/toggle_task_done.dart';
import 'package:tasky/domain/usecases/tasks/update_task.dart';
import 'package:tasky/domain/usecases/tasks/restore_task.dart';
import 'package:tasky/presentation/controllers/profile_controller.dart';
import 'package:tasky/presentation/controllers/settings_controller.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';

class AppDependencies {
  const AppDependencies({
    required this.getOnboardingStatus,
    required this.completeOnboarding,
    required this.avatarUseCase,
    required this.tasksController,
    required this.profileController,
    required this.settingsController,
  });

  final GetOnboardingStatus getOnboardingStatus;
  final CompleteOnboarding completeOnboarding;
  final AvatarUseCase avatarUseCase;
  final TasksController tasksController;
  final ProfileController profileController;
  final SettingsController settingsController;

  static Future<AppDependencies> create() async {
    // External dependencies
    final preferencesManager = await PreferencesManager.create();
    final database = DatabaseService();

    // Data sources
    final avatarStorage = AvatarStorageDataSource();
    final onboardingDataSource = OnboardingLocalDataSourceImpl(preferencesManager);
    final tasksDataSource = TasksLocalDataSourceImpl(database);
    final profileDataSource = ProfileLocalDataSourceImpl(
      database,
      avatarStorage,
    );
    final settingsDataSource = SettingsLocalDataSourceImpl(preferencesManager);

    // Repositories
    final avatarRepository = AvatarRepositoryImpl(storageService: avatarStorage);
    final onboardingRepository = OnboardingRepositoryImpl(onboardingDataSource);
    final tasksRepository = TasksRepositoryImpl(tasksDataSource);
    final profileRepository = ProfileRepositoryImpl(profileDataSource);
    final settingsRepository = SettingsRepositoryImpl(settingsDataSource);

    // Tasks controller
    final tasksController = TasksController(
      getTasks: GetTasks(tasksRepository),
      addTask: AddTask(
        repository: tasksRepository,
        idGenerator: const UuidIdGenerator(),
        clock: DateTime.now,
      ),
      updateTask: UpdateTask(tasksRepository),
      deleteTask: DeleteTask(tasksRepository),
      toggleTaskDone: ToggleTaskDone(
        repository: tasksRepository,
        clock: DateTime.now,
      ),
      filterAndSortTasks: const FilterAndSortTasks(),
      getTaskStats: const GetTaskStats(),
      restoreTask: RestoreTask(tasksRepository),
    );

    // Profile controller
    final profileController = ProfileController(
      getProfile: GetProfile(profileRepository),
      saveProfile: SaveProfile(profileRepository),
      clearUserData: ClearUserData(
        tasksRepository: tasksRepository,
        profileRepository: profileRepository,
      ),
    );

    // Settings controller
    final settingsController = SettingsController(
      getSettings: GetSettings(settingsRepository),
      saveSettings: SaveSettings(settingsRepository),
    );

    return AppDependencies(
      getOnboardingStatus: GetOnboardingStatus(onboardingRepository),
      completeOnboarding: CompleteOnboarding(onboardingRepository),
      avatarUseCase: AvatarUseCase(repository: avatarRepository),
      tasksController: tasksController,
      profileController: profileController,
      settingsController: settingsController,
    );
  }
}