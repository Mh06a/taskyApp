import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/core/utils/result.dart';

Future<Result<T>> guard<T>(
    Future<T> Function() action,
    ) async {
  try {
    return Ok<T>(await action());
  } catch (e) {
    return Err<T>(StorageFailure(cause: e));
  }
}

Result<T> guardSync<T>(T Function() action) {
  try {
    return Ok<T>(action());
  } catch (e) {
    return Err<T>(StorageFailure(cause: e));
  }
}
