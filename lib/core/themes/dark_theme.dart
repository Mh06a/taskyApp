import 'package:flutter/material.dart';
import 'package:second_project/core/constants/app_sizes.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  scaffoldBackgroundColor: const Color(0xFF181818),

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF15B86C),

    primaryContainer: Color(0xFF282828),

    surface: Color(0xFF282828),

    onSurface: Color(0xFFFFFCFC),

    secondary: Color(0xFFC6C6C6),

    outline: Color(0xFF6E6E6E),

    error: Colors.red,
  ),

  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: const Color(0xFF181818),
    iconTheme: const IconThemeData(color: Color(0xFFFFFCFC)),
    titleTextStyle: TextStyle(
      color: const Color(0xFFFFFCFC),
      fontSize: AppSizes.font20,
      fontWeight: FontWeight.w400,
    ),
  ),

  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: Color(0xFFFFFCFC),
      fontSize: AppSizes.font30,
      fontWeight: FontWeight.w400,
    ),

    displayMedium: TextStyle(
      color: Color(0xFFFFFCFC),
      fontSize: AppSizes.font24,
      fontWeight: FontWeight.w400,
    ),

    displaySmall: TextStyle(
      color: Color(0xFFFFFCFC),
      fontSize: AppSizes.font16,
      fontWeight: FontWeight.w400,
    ),

    labelMedium: TextStyle(
      color: Color(0xFFFFFCFC),
      fontSize: AppSizes.font20,
      fontWeight: FontWeight.w400,
    ),

    labelSmall: TextStyle(
      color: Color(0xFFC6C6C6),
      fontSize: AppSizes.font14,
      fontWeight: FontWeight.w400,
    ),

    // this for not done task :
    titleMedium: TextStyle(
      color: Color(0xFFFFFCFC),
      fontSize: AppSizes.font16,
      fontWeight: FontWeight.w400,
    ),

    titleSmall: TextStyle(
      color: Color(0xFFC6C6C6),
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
      foregroundColor: const Color(0xFFFFFCFC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.r12),
      ),
    ),
  ),

  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: Color(0xFF6E6E6E), width: AppSizes.w2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.r4),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF282828),

    hintStyle: const TextStyle(color: Color(0xFF6D6D6D)),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.r16),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.r16),
      borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.r16),
      borderSide: const BorderSide(color: Color(0xFF15B86C)),
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF181818),
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: Color(0xFFC6C6C6),
    selectedItemColor: Color(0xFF15B86C),
  ),

  splashFactory: NoSplash.splashFactory,

  popupMenuTheme: PopupMenuThemeData(
    color: Color(0xFF181818),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(AppSizes.r16),
      side: BorderSide(color: Color(0xFF15B86C), width: 1.0),
    ),
    elevation: 2,
    shadowColor: Color(0xFF15B86C),
    labelTextStyle: WidgetStateProperty.all(
      TextStyle(fontSize: AppSizes.font15),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Colors.white)),
  ),
);
