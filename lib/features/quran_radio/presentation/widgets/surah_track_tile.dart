import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../quran/domain/entities/surah.dart';

class SurahTrackTile extends StatelessWidget {
  const SurahTrackTile({
    super.key,
    required this.surah,
    required this.isCurrent,
    required this.isPlaying,
    required this.onTap,
  });

  final Surah surah;
  final bool isCurrent;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: isCurrent ? AppColors.bgSoftGreen : AppColors.bgWhite,
        border: Border.all(
          color: isCurrent ? AppColors.primaryGreen : AppColors.divider,
        ),
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
                CircleAvatar(
                  backgroundColor: isCurrent
                      ? AppColors.primaryGreen
                      : AppColors.bgSoftGreen,
                  child: isCurrent
                      ? Icon(
                          isPlaying
                              ? Icons.equalizer_rounded
                              : Icons.pause_rounded,
                          color: AppColors.bgWhite,
                          size: AppSizes.iconSm,
                        )
                      : Text(
                          '${surah.number}',
                          style: AppTextStyles.bodySmall().copyWith(
                            color: AppColors.primaryDarkGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(surah.englishName, style: AppTextStyles.h4()),
                      Text(
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
                  style: AppTextStyles.quranArabic().copyWith(fontSize: 18),
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
