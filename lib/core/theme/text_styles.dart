import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

// When Cairo, Inter, and Amiri .ttf files are bundled in assets/fonts/ and
// declared in pubspec.yaml, set fontFamily on the styles below:
//   - Headings + Arabic UI text → 'Cairo'
//   - English body text         → 'Inter'
//   - Quran verses              → 'Amiri'
class AppTextStyles {
  AppTextStyles._();

  static TextStyle h1() => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h2() => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h3() => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static TextStyle h4() => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle bodyRegular() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall() => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle caption() => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  static TextStyle buttonText() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.bgWhite,
    height: 1.2,
  );

  static TextStyle quranArabic() => const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.8,
  );

  static TextStyle arabicBody() => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.8,
  );
}
