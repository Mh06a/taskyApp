import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/core/utils/result.dart';

Failure _mapErrorToFailure(Object e) {
  if (e is Exception) {
    return StorageFailure(cause: e);
  }
  return UnexpectedFailure(cause: e);
}

Future<Result<T>> guard<T>(
    Future<T> Function() action,
    ) async {
  try {
    return Ok<T>(await action());
  } catch (e) {
    return Err<T>(_mapErrorToFailure(e));
  }
}

Result<T> guardSync<T>(T Function() action) {
  try {
    return Ok<T>(action());
  } catch (e) {
    return Err<T>(_mapErrorToFailure(e));
  }
}
