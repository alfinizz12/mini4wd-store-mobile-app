import 'package:flutter/material.dart';
import '../style/typography.dart';
import '../style/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,

    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryBlue,
      onPrimary: Colors.white,
      secondary: AppColors.primaryRed,
      onSecondary: Colors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textLight,
      error: AppColors.danger,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 3,
      titleTextStyle: AppTypography.h2,
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      color: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    chipTheme: ChipThemeData(
      selectedColor: const Color.fromRGBO(0, 87, 255, 1),
      disabledColor: AppColors.chipUnselected,
      backgroundColor: AppColors.chipUnselected,
      labelStyle: AppTypography.body2.copyWith(color: AppColors.textLight),
      secondaryLabelStyle: AppTypography.body2.copyWith(color: Colors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
        textStyle: AppTypography.button,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: AppTypography.display.copyWith(color: AppColors.textLight),
      headlineLarge: AppTypography.h1.copyWith(color: AppColors.textLight),
      headlineMedium: AppTypography.h2.copyWith(color: AppColors.textLight),
      headlineSmall: AppTypography.h3.copyWith(color: AppColors.textLight),
      titleLarge: AppTypography.subtitle1.copyWith(color: Colors.black87),
      titleMedium: AppTypography.subtitle2.copyWith(color: Colors.black87),
      bodyLarge: AppTypography.body1.copyWith(color: Colors.black87),
      bodyMedium: AppTypography.body2.copyWith(color: Colors.black87),
      labelMedium: AppTypography.label.copyWith(color: Colors.black87),
      labelLarge: AppTypography.button.copyWith(color: Colors.white),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,

    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryBlue,
      onPrimary: Colors.white,
      secondary: AppColors.primaryRed,
      onSecondary: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textDark,
      error: AppColors.danger,
      onError: Colors.white,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 3,
    ),

    cardTheme: CardThemeData(
      elevation: 2,
      color: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    chipTheme: ChipThemeData(
      selectedColor: AppColors.primaryRed,
      disabledColor: Colors.grey.shade700,
      backgroundColor: Colors.grey.shade800,
      labelStyle: AppTypography.body2.copyWith(color: Colors.white),
      secondaryLabelStyle: AppTypography.body2.copyWith(color: Colors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
        textStyle: AppTypography.button,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: AppTypography.display.copyWith(color: AppColors.textDark),
      headlineLarge: AppTypography.h1.copyWith(color: AppColors.textDark),
      headlineMedium: AppTypography.h2.copyWith(color: AppColors.textDark),
      headlineSmall: AppTypography.h3.copyWith(color: AppColors.textDark),
      titleLarge: AppTypography.subtitle1.copyWith(color: Colors.white70),
      titleMedium: AppTypography.subtitle2.copyWith(color: Colors.white70),
      bodyLarge: AppTypography.body1.copyWith(color: Colors.white70),
      bodyMedium: AppTypography.body2.copyWith(color: Colors.white70),
      labelMedium: AppTypography.label.copyWith(color: Colors.white70),
      labelLarge: AppTypography.button.copyWith(color: Colors.white),
    ),
  );
}
