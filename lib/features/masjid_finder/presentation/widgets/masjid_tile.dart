import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/masjid.dart';

class MasjidTile extends StatelessWidget {
  const MasjidTile({super.key, required this.masjid});
  final Masjid masjid;

  Future<void> _openDirections() async {
    final uri = Uri.parse(
      'https://www.google.com/maps?q=${masjid.latitude},${masjid.longitude}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final distanceLabel = masjid.distanceKm < 1.0
        ? '${(masjid.distanceKm * 1000).toStringAsFixed(0)} m'
        : '${masjid.distanceKm.toStringAsFixed(2)} km';
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusCards),
          onTap: _openDirections,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: AppColors.bgSoftGreen,
                  child: const Icon(
                    Icons.mosque_outlined,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        masjid.name,
                        style: AppTextStyles.h4(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (masjid.nameAr != null && masjid.nameAr!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSizes.xs),
                          child: Text(
                            masjid.nameAr!,
                            style: AppTextStyles.arabicBody().copyWith(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                            textDirection: TextDirection.rtl,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      const SizedBox(height: AppSizes.xs),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.directions_walk,
                            size: AppSizes.iconSm,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: AppSizes.xs),
                          Text(distanceLabel, style: AppTextStyles.bodySmall()),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
