import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primaryGreen,
      onPrimary: AppColors.bgWhite,
      primaryContainer: AppColors.primaryDarkGreen,
      onPrimaryContainer: AppColors.bgWhite,
      secondary: AppColors.accentGold,
      onSecondary: AppColors.textPrimary,
      surface: AppColors.bgWhite,
      onSurface: AppColors.textPrimary,
      error: AppColors.errorRed,
      onError: AppColors.bgWhite,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.bgOffWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryDarkGreen,
        foregroundColor: AppColors.bgWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h4().copyWith(color: AppColors.bgWhite),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.bgWhite,
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButtons),
          ),
          textStyle: AppTextStyles.buttonText(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusButtons),
          ),
          textStyle: AppTextStyles.buttonText().copyWith(
            color: AppColors.primaryGreen,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          minimumSize: const Size.fromHeight(AppSizes.minTouchTarget),
          textStyle: AppTextStyles.buttonText().copyWith(
            color: AppColors.primaryGreen,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgWhite,
        elevation: 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCards),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgWhite,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInputs),
          borderSide: const BorderSide(color: AppColors.textTertiary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInputs),
          borderSide: const BorderSide(color: AppColors.textTertiary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInputs),
          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusInputs),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgSoftGreen,
        selectedColor: AppColors.primaryGreen,
        labelStyle: AppTextStyles.bodySmall(),
        secondaryLabelStyle: AppTextStyles.bodySmall().copyWith(
          color: AppColors.bgWhite,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusChips),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.bgWhite,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDarkGreen,
        contentTextStyle: AppTextStyles.bodyRegular().copyWith(
          color: AppColors.bgWhite,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusCards),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData dark() {
    final base = light();
    const darkScheme = ColorScheme.dark(
      primary: AppColors.accentGold,
      onPrimary: AppColors.textPrimary,
      primaryContainer: AppColors.primaryDarkGreen,
      onPrimaryContainer: AppColors.bgWhite,
      secondary: AppColors.primaryGreen,
      onSecondary: AppColors.bgWhite,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      error: AppColors.errorRed,
      onError: AppColors.bgWhite,
    );

    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: darkScheme,
      scaffoldBackgroundColor: AppColors.darkScaffold,
      appBarTheme: base.appBarTheme.copyWith(
        backgroundColor: AppColors.darkSurface,
      ),
      cardTheme: base.cardTheme.copyWith(color: AppColors.darkSurface),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.accentGold,
        unselectedItemColor: AppColors.textTertiary,
      ),
    );
  }
}
