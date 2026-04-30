import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/surah.dart';

class SurahTile extends StatelessWidget {
  const SurahTile({super.key, required this.surah, required this.onTap});

  final Surah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusCards),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.lg,
              vertical: AppSizes.md,
            ),
            child: Row(
              children: <Widget>[
                _NumberMedallion(number: surah.number),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(surah.englishName, style: AppTextStyles.h4()),
                      const SizedBox(height: 2),
                      Text(
                        '${surah.englishMeaning}  •  '
                        '${surah.revelationType.toLowerCase()} • '
                        '${surah.ayahCount} ayahs',
                        style: AppTextStyles.caption(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Text(
                  surah.arabicName,
                  style: AppTextStyles.quranArabic().copyWith(fontSize: 20),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberMedallion extends StatelessWidget {
  const _NumberMedallion({required this.number});
  final int number;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Transform.rotate(
            angle: 0.785398, // 45°
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.bgSoftGreen,
                border: Border.all(color: AppColors.primaryGreen),
              ),
            ),
          ),
          Text(
            '$number',
            style: AppTextStyles.bodySmall().copyWith(
              color: AppColors.primaryDarkGreen,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
