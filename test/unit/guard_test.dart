import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/core/errors/failure.dart';
import 'package:tasky/core/utils/guard.dart';

void main() {
  group('guard and guardSync', () {
    test('guard catches Exception and returns StorageFailure', () async {
      final result = await guard(() async {
        throw const FormatException('bad format');
      });
      expect(result.isErr, true);
      expect(result.failureOrNull, isA<StorageFailure>());
    });

    test('guard catches Error (e.g. StateError) and returns UnexpectedFailure', () async {
      final result = await guard(() async {
        throw StateError('bad state');
      });
      expect(result.isErr, true);
      expect(result.failureOrNull, isA<UnexpectedFailure>());
    });

    test('guardSync catches Exception and returns StorageFailure', () {
      final result = guardSync(() {
        throw const FormatException('bad format');
      });
      expect(result.isErr, true);
      expect(result.failureOrNull, isA<StorageFailure>());
    });

    test('guardSync catches Error (e.g. TypeError) and returns UnexpectedFailure', () {
      final result = guardSync(() {
        throw TypeError();
      });
      expect(result.isErr, true);
      expect(result.failureOrNull, isA<UnexpectedFailure>());
    });
  });
}
