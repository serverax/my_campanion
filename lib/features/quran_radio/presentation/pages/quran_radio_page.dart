import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/quran_radio_controller.dart';
import '../widgets/now_playing_card.dart';
import '../widgets/player_controls.dart';
import '../widgets/surah_track_tile.dart';

class QuranRadioPage extends GetView<QuranRadioController> {
  const QuranRadioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quran Radio')),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.value != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Text(
                  controller.errorMessage.value!,
                  style: AppTextStyles.bodyRegular(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: const NowPlayingCard(),
                  ),
                  const PlayerControls(),
                  const SizedBox(height: AppSizes.md),
                  _ReciterStrip(),
                  Expanded(
                    child: Obx(() {
                      final list = controller.surahs;
                      final cur = controller.currentSurah.value;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.lg,
                          vertical: AppSizes.sm,
                        ),
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final s = list[i];
                          final isCurrent =
                              cur != null && cur.number == s.number;
                          return SurahTrackTile(
                            surah: s,
                            isCurrent: isCurrent,
                            isPlaying: isCurrent && controller.isPlaying.value,
                            onTap: () => controller.play(s),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ReciterStrip extends GetView<QuranRadioController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.record_voice_over,
            size: AppSizes.iconSm,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSizes.xs),
          Expanded(
            child: Text(
              '${controller.reciter.englishName} '
              '— ${controller.reciter.description}',
              style: AppTextStyles.caption(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            controller.reciter.arabicName,
            style: AppTextStyles.bodySmall().copyWith(
              color: AppColors.textSecondary,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
