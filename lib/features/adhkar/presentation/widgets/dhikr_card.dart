import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/dhikr.dart';
import '../controllers/adhkar_controller.dart';

class DhikrCard extends GetView<AdhkarController> {
  const DhikrCard({super.key, required this.dhikr});
  final Dhikr dhikr;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = controller.counts[dhikr.id] ?? 0;
      final complete = current >= dhikr.count;
      final progress = dhikr.count == 0 ? 1.0 : current / dhikr.count;

      return Container(
        margin: const EdgeInsets.only(bottom: AppSizes.md),
        decoration: BoxDecoration(
          color: complete ? AppColors.bgSoftGreen : AppColors.bgWhite,
          border: Border.all(
            color: complete ? AppColors.successGreen : AppColors.divider,
            width: complete ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radiusCards),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSizes.radiusCards),
            onTap: complete ? null : () => controller.tap(dhikr),
            onLongPress: () => _confirmReset(context),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Arabic
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      dhikr.arabic,
                      style: AppTextStyles.quranArabic().copyWith(
                        fontSize: 22,
                        height: 2.0,
                      ),
                    ),
                  ),
                  if (dhikr.transliteration != null) ...<Widget>[
                    const SizedBox(height: AppSizes.sm),
                    Text(
                      dhikr.transliteration!,
                      style: AppTextStyles.bodySmall().copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSizes.sm),
                  Text(dhikr.translation, style: AppTextStyles.bodyRegular()),
                  const SizedBox(height: AppSizes.sm),
                  Text(dhikr.source, style: AppTextStyles.caption()),
                  const SizedBox(height: AppSizes.lg),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.radiusButtons),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0, 1),
                      minHeight: 10,
                      backgroundColor: AppColors.bgOffWhite,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        complete
                            ? AppColors.successGreen
                            : AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    children: <Widget>[
                      Icon(
                        complete ? Icons.check_circle : Icons.touch_app,
                        size: AppSizes.iconSm,
                        color: complete
                            ? AppColors.successGreen
                            : AppColors.primaryGreen,
                      ),
                      const SizedBox(width: AppSizes.xs),
                      Text(
                        complete ? 'Done' : 'Tap to count',
                        style: AppTextStyles.caption().copyWith(
                          color: complete
                              ? AppColors.successGreen
                              : AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '$current / ${dhikr.count}',
                        style: AppTextStyles.h4().copyWith(
                          color: complete
                              ? AppColors.successGreen
                              : AppColors.primaryDarkGreen,
                          fontFeatures: const <FontFeature>[
                            FontFeature.tabularFigures(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _confirmReset(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset count?'),
        content: Text(
          'Set the count for this dhikr back to zero?',
          style: AppTextStyles.bodyRegular(),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.resetOne(dhikr);
              Navigator.of(ctx).pop();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
