import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/repositories/profile_repository.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';

/// Deletes all tasks and the profile. App settings are kept on purpose.
final class ClearUserData {
  const ClearUserData({
    required TasksRepository tasksRepository,
    required ProfileRepository profileRepository,
  }) : _tasks = tasksRepository,
       _profile = profileRepository;

  final TasksRepository _tasks;
  final ProfileRepository _profile;

  Future<Result<void>> call() async {
    final tasksResult = await _tasks.deleteAllTasks();
    if (tasksResult is Err<void>) return tasksResult;
    return _profile.clearProfile();
  }
}
