import 'package:tasky/core/enums/validation_error.dart';
import 'package:tasky/core/constants/limits.dart';

abstract final class Validators {
  static ValidationError? taskTitle(String value) {
    if (value.isEmpty) return ValidationError.titleEmpty;
    if (value.length > Limits.taskTitle) return ValidationError.titleTooLong;
    return null;
  }

  static ValidationError? taskDescription(String value) {
    if (value.length > Limits.taskDescription) {
      return ValidationError.descriptionTooLong;
    }
    return null;
  }

  static ValidationError? userName(String value) {
    if (value.isEmpty) return ValidationError.nameEmpty;
    if (value.length > Limits.userName) return ValidationError.nameTooLong;
    return null;
  }

  static ValidationError? quote(String value) {
    if (value.length > Limits.quote) return ValidationError.quoteTooLong;
    return null;
  }
}
