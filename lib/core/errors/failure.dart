import 'package:tasky/core/enums/validation_error.dart';

sealed class Failure {
  const Failure({this.cause});

  final Object? cause;
}

final class ValidationFailure extends Failure {
  const ValidationFailure(this.error);

  final ValidationError error;

  @override
  String toString() => 'ValidationFailure($error)';
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure(this.id);

  final String id;

  @override
  String toString() => 'NotFoundFailure($id)';
}

final class StorageFailure extends Failure {
  const StorageFailure({super.cause});

  @override
  String toString() => 'StorageFailure($cause)';
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.cause});

  @override
  String toString() => 'UnexpectedFailure($cause)';
}
