import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/islamic_event.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.gregorianDate,
    required this.isToday,
  });

  final IslamicEvent event;
  final DateTime gregorianDate;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: isToday ? AppColors.bgSoftGreen : AppColors.bgWhite,
        border: Border.all(
          color: isToday ? AppColors.primaryGreen : AppColors.divider,
          width: isToday ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              if (event.isMajor)
                const Padding(
                  padding: EdgeInsets.only(right: AppSizes.sm),
                  child: Icon(
                    Icons.star,
                    color: AppColors.accentGold,
                    size: AppSizes.iconMd,
                  ),
                ),
              Expanded(child: Text(event.name, style: AppTextStyles.h4())),
            ],
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            event.nameAr,
            style: AppTextStyles.arabicBody().copyWith(
              color: AppColors.textSecondary,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: AppSizes.sm),
          Row(
            children: <Widget>[
              const Icon(
                Icons.calendar_today,
                size: AppSizes.iconSm,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSizes.xs),
              Text(
                DateFormat('EEE, d MMM yyyy').format(gregorianDate),
                style: AppTextStyles.bodySmall(),
              ),
            ],
          ),
          if (event.notes != null) ...<Widget>[
            const SizedBox(height: AppSizes.md),
            Text(event.notes!, style: AppTextStyles.caption()),
          ],
        ],
      ),
    );
  }
}
