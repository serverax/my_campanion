import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../controllers/quran_radio_controller.dart';

class PlayerControls extends GetView<QuranRadioController> {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasTrack = controller.currentSurah.value != null;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            iconSize: 36,
            tooltip: 'Previous surah',
            icon: const Icon(Icons.skip_previous_rounded),
            color: hasTrack
                ? AppColors.primaryDarkGreen
                : AppColors.textTertiary,
            onPressed: hasTrack ? controller.previous : null,
          ),
          const SizedBox(width: AppSizes.md),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen,
            ),
            child: IconButton(
              iconSize: 56,
              tooltip: controller.isPlaying.value ? 'Pause' : 'Play',
              icon: controller.isBuffering.value
                  ? const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.bgWhite,
                        ),
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(
                      controller.isPlaying.value
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: AppColors.bgWhite,
                    ),
              onPressed: hasTrack
                  ? controller.togglePlayPause
                  : controller.resumeLastIfAvailable,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          IconButton(
            iconSize: 36,
            tooltip: 'Next surah',
            icon: const Icon(Icons.skip_next_rounded),
            color: hasTrack
                ? AppColors.primaryDarkGreen
                : AppColors.textTertiary,
            onPressed: hasTrack ? controller.next : null,
          ),
        ],
      );
    });
  }
}
