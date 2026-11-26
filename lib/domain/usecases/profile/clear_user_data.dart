import 'package:tasky/core/utils/result.dart';
import 'package:tasky/domain/repositories/profile_repository.dart';
import 'package:tasky/domain/repositories/tasks_repository.dart';

/// Deletes all tasks and the profile atomically in a database transaction. App settings are kept on purpose.
final class ClearUserData {
  const ClearUserData({
    required TasksRepository tasksRepository,
    required ProfileRepository profileRepository,
  }) : _tasks = tasksRepository,
       _profile = profileRepository;

  // ignore: unused_field
  final TasksRepository _tasks;
  final ProfileRepository _profile;

  Future<Result<void>> call() async {
    return _profile.clearUserData();
  }
}
