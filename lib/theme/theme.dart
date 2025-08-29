import 'package:flutter/material.dart';
import 'package:proxi_health/theme/colors.dart';
import 'package:proxi_health/theme/typography.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        titleTextStyle: AppTypography.headline3,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.headline1,
        displayMedium: AppTypography.headline2,
        displaySmall: AppTypography.headline3,
        bodyLarge: AppTypography.bodyText1,
        bodyMedium: AppTypography.bodyText2,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.primary,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          textStyle: AppTypography.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}