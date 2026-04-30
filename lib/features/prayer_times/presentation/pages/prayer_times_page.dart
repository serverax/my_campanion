import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/prayer_times_controller.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_tile.dart';

class PrayerTimesPage extends GetView<PrayerTimesController> {
  const PrayerTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh location',
            icon: const Icon(Icons.my_location),
            onPressed: controller.refreshLocation,
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(AppRoutes.prayerSettings),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.coordinates.value == null) {
            return _LocationMissingState(
              message: controller.errorMessage.value ?? 'No location set yet.',
            );
          }
          return _Schedule();
        }),
      ),
    );
  }
}

class _LocationMissingState extends StatelessWidget {
  const _LocationMissingState({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.location_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyRegular(),
            ),
            const SizedBox(height: AppSizes.xl),
            ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text('Try GPS again'),
              onPressed: () =>
                  Get.find<PrayerTimesController>().refreshLocation(),
            ),
            const SizedBox(height: AppSizes.md),
            OutlinedButton.icon(
              icon: const Icon(Icons.edit_location_alt_outlined),
              label: const Text('Set location manually'),
              onPressed: () => Get.toNamed(AppRoutes.prayerSettings),
            ),
          ],
        ),
      ),
    );
  }
}

class _Schedule extends GetView<PrayerTimesController> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _LocationStrip(),
              const SizedBox(height: AppSizes.md),
              const NextPrayerCard(),
              const SizedBox(height: AppSizes.xl),
              Text("Today's prayers", style: AppTextStyles.h4()),
              const SizedBox(height: AppSizes.md),
              Obx(() {
                final pt = controller.prayerTimes.value;
                final next = controller.nextPrayer.value;
                final cur = controller.currentPrayer.value;
                if (pt == null) return const SizedBox.shrink();
                Widget tile(Prayer p, DateTime t, {bool optional = false}) {
                  return PrayerTile(
                    prayer: p,
                    time: t,
                    isNext: next == p,
                    isCurrent: cur == p,
                    isOptional: optional,
                  );
                }

                return Column(
                  children: <Widget>[
                    tile(Prayer.fajr, pt.fajr),
                    tile(Prayer.sunrise, pt.sunrise, optional: true),
                    tile(Prayer.dhuhr, pt.dhuhr),
                    tile(Prayer.asr, pt.asr),
                    tile(Prayer.maghrib, pt.maghrib),
                    tile(Prayer.isha, pt.isha),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationStrip extends GetView<PrayerTimesController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final c = controller.coordinates.value;
      final label = controller.locationLabel.value;
      if (c == null) return const SizedBox.shrink();
      return Row(
        children: <Widget>[
          const Icon(
            Icons.place,
            size: AppSizes.iconSm,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSizes.xs),
          Expanded(
            child: Text(
              '${label ?? 'Location'}  '
              '(${c.latitude.toStringAsFixed(2)}, ${c.longitude.toStringAsFixed(2)})',
              style: AppTextStyles.caption(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    });
  }
}
