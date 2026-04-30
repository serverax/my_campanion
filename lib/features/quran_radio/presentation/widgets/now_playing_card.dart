import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/quran_radio_controller.dart';

class NowPlayingCard extends GetView<QuranRadioController> {
  const NowPlayingCard({super.key});

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${d.inHours}:$m:$s';
    }
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final s = controller.currentSurah.value;
      if (s == null) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.lg),
          decoration: BoxDecoration(
            color: AppColors.bgSoftGreen,
            borderRadius: BorderRadius.circular(AppSizes.radiusCards),
          ),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.headphones,
                size: AppSizes.iconMd,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Text(
                  'Pick a surah below to start listening.',
                  style: AppTextStyles.bodySmall(),
                ),
              ),
            ],
          ),
        );
      }

      final pos = controller.position.value;
      final dur = controller.duration.value;
      final progress = dur.inMilliseconds == 0
          ? 0.0
          : pos.inMilliseconds / dur.inMilliseconds;

      return Container(
        padding: const EdgeInsets.all(AppSizes.lg),
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
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        s.englishName,
                        style: AppTextStyles.h2().copyWith(
                          color: AppColors.bgWhite,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        s.englishMeaning,
                        style: AppTextStyles.bodySmall().copyWith(
                          color: AppColors.bgOffWhite,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        '${controller.reciter.englishName} • '
                        '${s.ayahCount} ayahs',
                        style: AppTextStyles.caption().copyWith(
                          color: AppColors.bgOffWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  s.arabicName,
                  style: AppTextStyles.quranArabic().copyWith(
                    color: AppColors.accentGold,
                    fontSize: 26,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4,
                activeTrackColor: AppColors.accentGold,
                inactiveTrackColor: AppColors.bgWhite.withValues(alpha: 0.2),
                thumbColor: AppColors.bgWhite,
                overlayColor: AppColors.bgWhite.withValues(alpha: 0.15),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: progress.clamp(0.0, 1.0),
                onChanged: (v) {
                  if (dur.inMilliseconds > 0) {
                    controller.seekTo(
                      Duration(milliseconds: (v * dur.inMilliseconds).round()),
                    );
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _fmt(pos),
                  style: AppTextStyles.caption().copyWith(
                    color: AppColors.bgOffWhite,
                  ),
                ),
                Text(
                  _fmt(dur),
                  style: AppTextStyles.caption().copyWith(
                    color: AppColors.bgOffWhite,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
