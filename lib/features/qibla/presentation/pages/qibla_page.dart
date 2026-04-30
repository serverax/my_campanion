import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/qibla_controller.dart';
import '../widgets/compass_dial.dart';

class QiblaPage extends GetView<QiblaController> {
  const QiblaPage({super.key});

  String _cardinalLabel(double bearing) {
    const labels = <String>[
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW',
    ];
    final idx = ((bearing % 360) / 22.5).round() % 16;
    return labels[idx];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh location',
            icon: const Icon(Icons.my_location),
            onPressed: controller.reload,
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.qiblaBearing.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final bearing = controller.qiblaBearing.value;
          if (bearing == null) {
            return _MissingLocation(
              message:
                  controller.errorMessage.value ??
                  'Set a location to find Qibla.',
            );
          }
          final h = controller.heading.value;
          final c = controller.coords.value;
          final aligned =
              h != null &&
              ((bearing - h).abs() < 5 ||
                  ((bearing - h).abs() - 360).abs() < 5);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxContentWidth,
                ),
                child: Column(
                  children: <Widget>[
                    if (c != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.place,
                              size: AppSizes.iconSm,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: AppSizes.xs),
                            Text(
                              '(${c.lat.toStringAsFixed(2)}, '
                              '${c.lon.toStringAsFixed(2)})',
                              style: AppTextStyles.caption(),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppSizes.md),
                    CompassDial(qiblaBearing: bearing, heading: h, size: 300),
                    const SizedBox(height: AppSizes.xl),
                    Text(
                      '${bearing.toStringAsFixed(0)}°  ${_cardinalLabel(bearing)}',
                      style: AppTextStyles.h2(),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'bearing from your location to the Kaaba',
                      style: AppTextStyles.bodySmall(),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    if (h == null)
                      _Hint(
                        icon: Icons.info_outline,
                        text:
                            'Compass not available on this device. The bearing above is absolute (degrees from true north).',
                      )
                    else if (aligned)
                      _Hint(
                        icon: Icons.check_circle,
                        color: AppColors.successGreen,
                        text: 'You are facing Qibla. الكعبة في هذا الاتجاه',
                      )
                    else
                      _Hint(
                        icon: Icons.threed_rotation,
                        text:
                            'Hold the device flat and rotate until the gold arrow points up.',
                      ),
                    const SizedBox(height: AppSizes.lg),
                    Text(
                      'Heading and arrow update from the device magnetic '
                      'compass. For best accuracy, move the phone in a '
                      'figure-8 motion to calibrate.',
                      style: AppTextStyles.caption(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.icon, required this.text, this.color});
  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primaryGreen;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSoftGreen,
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
        border: Border.all(color: c.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: c, size: AppSizes.iconMd),
          const SizedBox(width: AppSizes.md),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall())),
        ],
      ),
    );
  }
}

class _MissingLocation extends StatelessWidget {
  const _MissingLocation({required this.message});
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
              onPressed: () => Get.find<QiblaController>().reload(),
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
