
import 'package:flutter/material.dart';
import 'package:tasky/core/constants/app_sizes.dart';
import 'package:tasky/core/theme/app_colors.dart';
import 'package:tasky/core/theme/tasky_theme_extension.dart';

abstract final class ThemeFactory {
  static ThemeData create({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceSecondary,
    required Color text,
    required Color secondaryText,
    required Color placeholder,
    required Color border,
    required Color borderStrong,
    required Color primary,
    required Color onPrimary,
    required Color error,
    required Color errorSoft,
    required Color priorityHigh,
    required Color priorityHighText,
    required Color primarySoft,
    required Color primarySoftText,
    required TextTheme textTheme,
  }) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: onPrimary,

      secondary: primary,
      onSecondary: onPrimary,

      error: error,
      onError: AppColors.white,

      surface: surface,
      onSurface: text,

      surfaceContainerHighest: surfaceSecondary,
      onSurfaceVariant: secondaryText,

      outline: border,
      outlineVariant: borderStrong,

      surfaceTint: AppColors.transparent,
    );

    return ThemeData(
      splashFactory: NoSplash.splashFactory,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,

      scaffoldBackgroundColor: background,
      primaryColor: primary,
      dividerColor: border,

      textTheme: textTheme,

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(
          color: text,
          size: AppSizes.icon24,
        ),
      ),

      iconTheme: IconThemeData(
        color: text,
        size: AppSizes.icon24,
      ),

      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: AppColors.transparent,
        elevation: AppSizes.zero,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r20),
          side: BorderSide(
            color: border,
            width: AppSizes.stroke1,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: placeholder,
        ),
        labelStyle: textTheme.bodyMedium,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSizes.s16,
          vertical: AppSizes.s16,
        ),
        constraints: BoxConstraints(
          minHeight: AppSizes.inputHeight,
        ),
        border: _inputBorder(border),
        enabledBorder: _inputBorder(border),
        focusedBorder: _inputBorder(
          primary,
          width: AppSizes.stroke1_5,
        ),
        errorBorder: _inputBorder(error),
        focusedErrorBorder: _inputBorder(
          error,
          width: AppSizes.stroke1_5,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: Size(
            double.infinity,
            AppSizes.buttonHeight,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.s20,
          ),
          elevation: AppSizes.zero,
          textStyle: textTheme.labelLarge?.copyWith(
            color: onPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r14),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          minimumSize: Size(
            double.infinity,
            AppSizes.buttonHeight,
          ),
          side: BorderSide(
            color: borderStrong,
            width: AppSizes.stroke1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r14),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.r12),
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surfaceSecondary,
        selectedColor: primarySoft,
        disabledColor: surfaceSecondary,
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.s8,
          vertical: AppSizes.s4,
        ),
        side: BorderSide(
          color: border,
          width: AppSizes.stroke1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r12),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: secondaryText,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: AppSizes.zero,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primarySoft,
        surfaceTintColor: AppColors.transparent,
        height: AppSizes.bottomNavigationHeight,
        elevation: AppSizes.zero,
        labelTextStyle: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return textTheme.labelMedium?.copyWith(
                color: primary,
                fontWeight: FontWeight.w600,
              );
            }

            return textTheme.labelMedium?.copyWith(
              color: secondaryText,
            );
          },
        ),
        iconTheme: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(
                color: primary,
                size: AppSizes.icon24,
              );
            }

            return IconThemeData(
              color: secondaryText,
              size: AppSizes.icon24,
            );
          },
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: AppColors.transparent,
        elevation: AppSizes.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r28),
        ),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: AppColors.transparent,
        modalBackgroundColor: surface,
        elevation: AppSizes.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.r28),
          ),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: AppSizes.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r16),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: surfaceSecondary,
        circularTrackColor: surfaceSecondary,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return primary;
            }

            return AppColors.transparent;
          },
        ),
        checkColor: WidgetStateProperty.all(onPrimary),
        side: BorderSide(
          color: borderStrong,
          width: AppSizes.stroke1_5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.r4),
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return onPrimary;
            }

            return secondaryText;
          },
        ),
        trackColor: WidgetStateProperty.resolveWith(
              (states) {
            if (states.contains(WidgetState.selected)) {
              return primary;
            }

            return surfaceSecondary;
          },
        ),
      ),

      dividerTheme: DividerThemeData(
        color: border,
        thickness: AppSizes.stroke1,
        space: AppSizes.s16,
      ),

      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          secondaryText.withValues(alpha: 0.35),
        ),
        radius: Radius.circular(AppSizes.r8),
      ),

      extensions: [
        TaskyThemeExtension(
          surfaceSecondary: surfaceSecondary,
          borderStrong: borderStrong,
          placeholder: placeholder,
          primarySoft: primarySoft,
          primarySoftText: primarySoftText,
          priorityHigh: priorityHigh,
          priorityHighText: priorityHighText,
          errorSoft: errorSoft,
          isDark: isDark,
        ),
      ],
    );
  }

  static OutlineInputBorder _inputBorder(
      Color color, {
        double width = 1,
      }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.r14),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}
