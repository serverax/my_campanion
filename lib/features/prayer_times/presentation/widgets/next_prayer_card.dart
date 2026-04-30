import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/prayer_settings.dart';
import '../controllers/prayer_times_controller.dart';

class NextPrayerCard extends GetView<PrayerTimesController> {
  const NextPrayerCard({super.key});

  String _formatDuration(Duration d) {
    if (d.isNegative) return '00:00:00';
    final h = d.inHours.remainder(99).toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pt = controller.prayerTimes.value;
      final next = controller.nextPrayer.value;
      final remaining = controller.timeUntilNext.value;
      if (pt == null) {
        return const SizedBox.shrink();
      }
      final nextTime = pt.timeForPrayer(next) ?? pt.fajr;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[AppColors.primaryDarkGreen, AppColors.primaryGreen],
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusModals),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Next prayer',
              style: AppTextStyles.bodySmall().copyWith(
                color: AppColors.bgOffWhite,
              ),
            ),
            const SizedBox(height: AppSizes.xs),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  next.englishLabel,
                  style: AppTextStyles.h1().copyWith(color: AppColors.bgWhite),
                ),
                const SizedBox(width: AppSizes.md),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    next.arabicLabel,
                    style: AppTextStyles.h3().copyWith(
                      color: AppColors.accentGold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              DateFormat('h:mm a').format(nextTime),
              style: AppTextStyles.h3().copyWith(color: AppColors.bgOffWhite),
            ),
            const SizedBox(height: AppSizes.lg),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.lg,
                vertical: AppSizes.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.bgWhite.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.radiusButtons),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.timer_outlined,
                    color: AppColors.bgWhite,
                    size: AppSizes.iconMd,
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    _formatDuration(remaining),
                    style: AppTextStyles.h4().copyWith(
                      color: AppColors.bgWhite,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
