import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/masjid_finder_controller.dart';
import '../widgets/masjid_map.dart';
import '../widgets/masjid_tile.dart';

class MasjidFinderPage extends GetView<MasjidFinderController> {
  const MasjidFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masjid Finder'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.load(forceRefresh: true),
          ),
          Obx(
            () => IconButton(
              tooltip: controller.view.value == MasjidView.list
                  ? 'Show map'
                  : 'Show list',
              icon: Icon(
                controller.view.value == MasjidView.list
                    ? Icons.map_outlined
                    : Icons.list,
              ),
              onPressed: controller.toggleView,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.masjids.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.value != null &&
              controller.origin.value == null) {
            return _ErrorState(message: controller.errorMessage.value!);
          }
          if (controller.masjids.isEmpty) {
            return _EmptyState();
          }
          return controller.view.value == MasjidView.list
              ? _ListView()
              : _MapView();
        }),
      ),
    );
  }
}

class _ListView extends GetView<MasjidFinderController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
        child: Column(
          children: <Widget>[
            _OriginStrip(),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  itemCount: controller.masjids.length,
                  itemBuilder: (_, i) =>
                      MasjidTile(masjid: controller.masjids[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapView extends GetView<MasjidFinderController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final origin = controller.origin.value;
      if (origin == null) return const SizedBox.shrink();
      return MasjidMap(
        masjids: controller.masjids,
        userLat: origin.lat,
        userLon: origin.lon,
      );
    });
  }
}

class _OriginStrip extends GetView<MasjidFinderController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final origin = controller.origin.value;
      if (origin == null) return const SizedBox.shrink();
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.sm,
        ),
        color: AppColors.bgSoftGreen,
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.place,
              size: AppSizes.iconSm,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: AppSizes.xs),
            Expanded(
              child: Text(
                '${controller.masjids.length} mosques within 5 km '
                '(${origin.lat.toStringAsFixed(2)}, '
                '${origin.lon.toStringAsFixed(2)})',
                style: AppTextStyles.caption(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _EmptyState extends GetView<MasjidFinderController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.location_searching,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'No mosques found within 5 km.',
              style: AppTextStyles.bodyRegular(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
              onPressed: () => controller.load(forceRefresh: true),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});
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
              style: AppTextStyles.bodyRegular(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xl),
            ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text('Try GPS again'),
              onPressed: () => Get.find<MasjidFinderController>().load(),
            ),
            const SizedBox(height: AppSizes.md),
            OutlinedButton.icon(
              icon: const Icon(Icons.edit_location_alt_outlined),
              label: const Text('Set location in Prayer Settings'),
              onPressed: () => Get.toNamed(AppRoutes.prayerSettings),
            ),
          ],
        ),
      ),
    );
  }
}
