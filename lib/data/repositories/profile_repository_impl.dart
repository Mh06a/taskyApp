import 'package:tasky/core/utils/guard.dart';
import 'package:tasky/core/utils/result.dart';
import 'package:tasky/data/datasources/local/profile_local_data_source.dart';
import 'package:tasky/data/models/user_profile_model.dart';
import 'package:tasky/domain/entities/user_profile.dart';
import 'package:tasky/domain/repositories/profile_repository.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileLocalDataSource _dataSource;

  @override
  Future<Result<UserProfile?>> getProfile() {
    return guard<UserProfile?>(_dataSource.getProfile);
  }

  @override
  Future<Result<void>> saveProfile(UserProfile profile) {
    return guard<void>(
      () => _dataSource.saveProfile(UserProfileModel.fromEntity(profile)),
    );
  }

  @override
  Future<Result<void>> clearProfile() {
    return guard<void>(_dataSource.clearProfile);
  }
}
