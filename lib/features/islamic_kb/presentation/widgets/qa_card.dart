import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/islamic_question.dart';

class QaCard extends StatelessWidget {
  const QaCard({super.key, required this.entry, required this.onTap});

  final IslamicQuestion entry;
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
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgSoftGreen,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusChips,
                        ),
                      ),
                      child: Text(
                        entry.category.englishName,
                        style: AppTextStyles.caption().copyWith(
                          color: AppColors.primaryDarkGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.textTertiary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  entry.questionEn,
                  style: AppTextStyles.bodyRegular().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  entry.questionAr,
                  style: AppTextStyles.arabicBody().copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
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
