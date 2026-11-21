
import 'package:flutter/material.dart';

class TaskyThemeExtension extends ThemeExtension<TaskyThemeExtension> {
  const TaskyThemeExtension({
    required this.surfaceSecondary,
    required this.borderStrong,
    required this.placeholder,
    required this.primarySoft,
    required this.primarySoftText,
    required this.priorityHigh,
    required this.priorityHighText,
    required this.errorSoft,
    required this.isDark,
  });

  final Color surfaceSecondary;
  final Color borderStrong;
  final Color placeholder;
  final Color primarySoft;
  final Color primarySoftText;
  final Color priorityHigh;
  final Color priorityHighText;
  final Color errorSoft;
  final bool isDark;

  @override
  TaskyThemeExtension copyWith({
    Color? surfaceSecondary,
    Color? borderStrong,
    Color? placeholder,
    Color? primarySoft,
    Color? primarySoftText,
    Color? priorityHigh,
    Color? priorityHighText,
    Color? errorSoft,
    bool? isDark,
  }) {
    return TaskyThemeExtension(
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      borderStrong: borderStrong ?? this.borderStrong,
      placeholder: placeholder ?? this.placeholder,
      primarySoft: primarySoft ?? this.primarySoft,
      primarySoftText: primarySoftText ?? this.primarySoftText,
      priorityHigh: priorityHigh ?? this.priorityHigh,
      priorityHighText: priorityHighText ?? this.priorityHighText,
      errorSoft: errorSoft ?? this.errorSoft,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  TaskyThemeExtension lerp(
      covariant TaskyThemeExtension? other,
      double t,
      ) {
    if (other == null) return this;

    return TaskyThemeExtension(
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
      borderStrong: Color.lerp(
        borderStrong,
        other.borderStrong,
        t,
      )!,
      placeholder: Color.lerp(
        placeholder,
        other.placeholder,
        t,
      )!,
      primarySoft: Color.lerp(
        primarySoft,
        other.primarySoft,
        t,
      )!,
      primarySoftText: Color.lerp(
        primarySoftText,
        other.primarySoftText,
        t,
      )!,
      priorityHigh: Color.lerp(
        priorityHigh,
        other.priorityHigh,
        t,
      )!,
      priorityHighText: Color.lerp(
        priorityHighText,
        other.priorityHighText,
        t,
      )!,
      errorSoft: Color.lerp(
        errorSoft,
        other.errorSoft,
        t,
      )!,
      isDark: t < 0.5 ? isDark : other.isDark,
    );
  }
}
