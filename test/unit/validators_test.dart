import 'package:flutter_test/flutter_test.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/core/enums/validation_error.dart';

void main() {
  group('Validators', () {
    test('taskTitle validates empty and too long titles', () {
      expect(Validators.taskTitle(''), ValidationError.titleEmpty);
      expect(Validators.taskTitle('Valid Title'), isNull);
      expect(Validators.taskTitle('a' * 81), ValidationError.titleTooLong);
    });

    test('taskDescription validates max length', () {
      expect(Validators.taskDescription('Valid Desc'), isNull);
      expect(Validators.taskDescription('a' * 301), ValidationError.descriptionTooLong);
    });

    test('userName validates empty and too long names', () {
      expect(Validators.userName(''), ValidationError.nameEmpty);
      expect(Validators.userName('John Doe'), isNull);
      expect(Validators.userName('a' * 41), ValidationError.nameTooLong);
    });

    test('quote validates max length', () {
      expect(Validators.quote('Valid Quote'), isNull);
      expect(Validators.quote('a' * 121), ValidationError.quoteTooLong);
    });
  });
}
