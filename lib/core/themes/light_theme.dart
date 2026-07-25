import 'package:flutter/material.dart';
import 'package:second_project/core/constants/app_sizes.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  scaffoldBackgroundColor: const Color(0xFFF6F7F9),

  colorScheme: const ColorScheme.light(
    primary: Color(0xFF15B86C),

    primaryContainer: Color(0xFFFFFFFF),

    surface: Color(0xFFFFFFFF),

    onSurface: Color(0xFF161F1B),

    secondary: Color(0xFF3A4640),

    outline: Color(0xFFD1DAD6),

    error: Colors.red,
  ),

  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Color(0xFFF6F7F9),
    iconTheme: IconThemeData(color: Color(0xFF161F1B)),
    titleTextStyle: TextStyle(
      color: Color(0xFF161F1B),
      fontSize: AppSizes.font20,
      fontWeight: FontWeight.w400,
    ),
  ),

  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFF161F1B),
      fontSize: AppSizes.font30,
      fontWeight: FontWeight.w400,
    ),

    displayMedium: TextStyle(
      color: Color(0xFF161F1B),
      fontSize: AppSizes.font24,
      fontWeight: FontWeight.w400,
    ),

    displaySmall: TextStyle(
      color: Color(0xFF161F1B),
      fontSize: AppSizes.font16,
      fontWeight: FontWeight.w400,
    ),

    labelMedium: TextStyle(
      color: Color(0xFF161F1B),
      fontSize: AppSizes.font20,
      fontWeight: FontWeight.w400,
    ),

    labelSmall: TextStyle(
      color: Color(0xFF3A4640),
      fontSize: AppSizes.font14,
      fontWeight: FontWeight.w400,
    ),

    // this for not done task :
    titleMedium: TextStyle(
      color: Color(0xFF161F1B),
      fontSize: AppSizes.font16,
      fontWeight: FontWeight.w400,
    ),

    titleSmall: TextStyle(
      color: Color(0xFF3A4640),
      fontSize: AppSizes.font15,
      fontWeight: FontWeight.w400,
    ),

    // this for done task :
    headlineSmall: TextStyle(
      color: Color(0xFFA0A0A0),
      fontSize: AppSizes.font16,
      fontWeight: FontWeight.w400,
      decoration: TextDecoration.lineThrough,
      decorationColor: Color(0xFF49454F),
      overflow: TextOverflow.ellipsis,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF15B86C),
      foregroundColor: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
    ),
  ),

  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: Color(0xFFD1DAD6), width: AppSizes.w2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.r4),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFFFFFFFF),

    hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.r16),
      borderSide: const BorderSide(color: Color(0xFFD1DAD6)),
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.r16),
      borderSide: const BorderSide(color: Color(0xFFD1DAD6)),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.r16),
      borderSide: const BorderSide(color: Color(0xFF15B86C)),
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFF6F7F9),
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Color(0xFF3A4640),
    selectedItemColor: Color(0xFF14A662),
  ),

  splashFactory: NoSplash.splashFactory,

  popupMenuTheme: PopupMenuThemeData(
    color: Color(0xFFF6F7F9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(AppSizes.r16),
      side: BorderSide(color: Color(0xFF15B86C), width: 1.0),
    ),
    elevation: 2,
    shadowColor: Color(0xFF15B86C),
    labelTextStyle: WidgetStateProperty.all(
      TextStyle(fontSize: AppSizes.font15, color: Colors.black),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.black)),
  ),
);
