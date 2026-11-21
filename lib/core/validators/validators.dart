import 'package:tasky/core/enums/validation_error.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:characters/characters.dart';

abstract final class Validators {
  static ValidationError? taskTitle(String value) {
    if (value.isEmpty) return ValidationError.titleEmpty;
    if (value.characters.length > Limits.taskTitle) return ValidationError.titleTooLong;
    return null;
  }

  static ValidationError? taskDescription(String value) {
    if (value.characters.length > Limits.taskDescription) {
      return ValidationError.descriptionTooLong;
    }
    return null;
  }

  static ValidationError? userName(String value) {
    if (value.isEmpty) return ValidationError.nameEmpty;
    if (value.characters.length > Limits.userName) return ValidationError.nameTooLong;
    return null;
  }

  static ValidationError? quote(String value) {
    if (value.characters.length > Limits.quote) return ValidationError.quoteTooLong;
    return null;
  }
}
