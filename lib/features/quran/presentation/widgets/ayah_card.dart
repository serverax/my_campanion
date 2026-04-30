import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/ayah.dart';

class AyahCard extends StatelessWidget {
  const AyahCard({
    super.key,
    required this.ayah,
    required this.bookmarked,
    required this.onToggleBookmark,
  });

  final Ayah ayah;
  final bool bookmarked;
  final VoidCallback onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.lg),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: bookmarked ? AppColors.bgSoftGreen : AppColors.bgWhite,
        border: Border.all(
          color: bookmarked ? AppColors.primaryGreen : AppColors.divider,
          width: bookmarked ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(AppSizes.radiusChips),
                ),
                child: Text(
                  '${ayah.surahNumber}:${ayah.numberInSurah}',
                  style: AppTextStyles.caption().copyWith(
                    color: AppColors.bgWhite,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: bookmarked ? 'Remove bookmark' : 'Bookmark this ayah',
                icon: Icon(
                  bookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: bookmarked
                      ? AppColors.accentGold
                      : AppColors.textSecondary,
                ),
                onPressed: onToggleBookmark,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              ayah.arabic,
              style: AppTextStyles.quranArabic().copyWith(
                fontSize: 26,
                height: 2.0,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            ayah.translation,
            style: AppTextStyles.bodyRegular().copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
