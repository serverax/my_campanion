import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/prayer_settings.dart';

class PrayerTile extends StatelessWidget {
  const PrayerTile({
    super.key,
    required this.prayer,
    required this.time,
    this.isNext = false,
    this.isCurrent = false,
    this.isOptional = false,
  });

  final Prayer prayer;
  final DateTime time;
  final bool isNext;
  final bool isCurrent;
  final bool isOptional;

  @override
  Widget build(BuildContext context) {
    final highlighted = isNext || isCurrent;
    final bg = highlighted
        ? AppColors.bgSoftGreen
        : (isOptional ? AppColors.bgOffWhite : AppColors.bgWhite);
    final border = isNext
        ? Border.all(color: AppColors.primaryGreen, width: 2)
        : Border.all(color: AppColors.divider);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: border,
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Row(
        children: <Widget>[
          if (isNext)
            const Icon(
              Icons.arrow_forward,
              color: AppColors.primaryGreen,
              size: AppSizes.iconMd,
            )
          else if (isCurrent)
            const Icon(
              Icons.brightness_1,
              color: AppColors.primaryGreen,
              size: AppSizes.iconSm,
            )
          else
            SizedBox(
              width: AppSizes.iconMd,
              child: isOptional
                  ? const Icon(
                      Icons.wb_sunny_outlined,
                      color: AppColors.textTertiary,
                      size: AppSizes.iconSm,
                    )
                  : null,
            ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  prayer.englishLabel,
                  style: AppTextStyles.h4().copyWith(
                    color: isOptional
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  prayer.arabicLabel,
                  style: AppTextStyles.arabicBody().copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          Text(
            DateFormat('h:mm a').format(time),
            style: AppTextStyles.h4().copyWith(
              color: highlighted
                  ? AppColors.primaryDarkGreen
                  : AppColors.textPrimary,
              fontWeight: highlighted ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
