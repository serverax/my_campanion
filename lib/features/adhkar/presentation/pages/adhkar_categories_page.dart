import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/dhikr.dart';
import 'category_dhikrs_page.dart';

class AdhkarCategoriesPage extends StatelessWidget {
  const AdhkarCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adhkar')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.lg),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[
                        AppColors.primaryDarkGreen,
                        AppColors.primaryGreen,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppSizes.radiusCards),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Daily remembrance',
                        style: AppTextStyles.h3().copyWith(
                          color: AppColors.bgWhite,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        'الذكر',
                        style: AppTextStyles.h4().copyWith(
                          color: AppColors.accentGold,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: AppSizes.sm),
                      Text(
                        'Counters reset each new day. Tap a dhikr to '
                        'increment, long-press to reset just that one.',
                        style: AppTextStyles.bodySmall().copyWith(
                          color: AppColors.bgOffWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                ...DhikrCategory.values.map(_CategoryTile.new),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile(this.category);
  final DhikrCategory category;

  IconData get _icon {
    switch (category) {
      case DhikrCategory.morning:
        return Icons.wb_sunny_outlined;
      case DhikrCategory.evening:
        return Icons.nightlight_outlined;
      case DhikrCategory.afterPrayer:
        return Icons.mosque_outlined;
      case DhikrCategory.general:
        return Icons.fiber_manual_record_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.md,
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.bgSoftGreen,
          child: Icon(_icon, color: AppColors.primaryGreen),
        ),
        title: Text(category.englishName, style: AppTextStyles.h4()),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSizes.xs),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                category.arabicName,
                style: AppTextStyles.arabicBody().copyWith(
                  color: AppColors.textSecondary,
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: AppSizes.xs),
              Text(category.description, style: AppTextStyles.bodySmall()),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Get.to<void>(() => CategoryDhikrsPage(category: category)),
      ),
    );
  }
}
