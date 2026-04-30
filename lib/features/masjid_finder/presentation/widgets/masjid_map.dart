import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/masjid.dart';

class MasjidMap extends StatefulWidget {
  const MasjidMap({
    super.key,
    required this.masjids,
    required this.userLat,
    required this.userLon,
  });
  final List<Masjid> masjids;
  final double userLat;
  final double userLon;

  @override
  State<MasjidMap> createState() => _MasjidMapState();
}

class _MasjidMapState extends State<MasjidMap> {
  Masjid? _selected;

  @override
  Widget build(BuildContext context) {
    final user = LatLng(widget.userLat, widget.userLon);
    return Stack(
      children: <Widget>[
        FlutterMap(
          options: MapOptions(
            initialCenter: user,
            initialZoom: 14,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            onTap: (_, __) => setState(() => _selected = null),
          ),
          children: <Widget>[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.rahma.rahma_app',
              maxZoom: 19,
            ),
            MarkerLayer(
              markers: <Marker>[
                Marker(
                  point: user,
                  width: 20,
                  height: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.bgWhite, width: 3),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(color: Colors.black26, blurRadius: 4),
                      ],
                    ),
                  ),
                ),
                ...widget.masjids.map(
                  (m) => Marker(
                    point: LatLng(m.latitude, m.longitude),
                    width: 36,
                    height: 36,
                    child: GestureDetector(
                      onTap: () => setState(() => _selected = m),
                      child: const Icon(
                        Icons.mosque,
                        color: AppColors.accentGold,
                        size: 36,
                        shadows: <Shadow>[
                          Shadow(blurRadius: 4, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (_selected != null)
          Positioned(
            left: AppSizes.md,
            right: AppSizes.md,
            bottom: AppSizes.md,
            child: _SelectedCard(
              masjid: _selected!,
              onClose: () => setState(() => _selected = null),
            ),
          ),
      ],
    );
  }
}

class _SelectedCard extends StatelessWidget {
  const _SelectedCard({required this.masjid, required this.onClose});
  final Masjid masjid;
  final VoidCallback onClose;

  Future<void> _openDirections() async {
    final uri = Uri.parse(
      'https://www.google.com/maps?q=${masjid.latitude},${masjid.longitude}',
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgWhite,
      borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(masjid.name, style: AppTextStyles.h4())),
                IconButton(icon: const Icon(Icons.close), onPressed: onClose),
              ],
            ),
            if (masjid.nameAr != null && masjid.nameAr!.isNotEmpty)
              Text(
                masjid.nameAr!,
                style: AppTextStyles.arabicBody().copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textDirection: TextDirection.rtl,
              ),
            const SizedBox(height: AppSizes.xs),
            Text(
              masjid.distanceKm < 1
                  ? '${(masjid.distanceKm * 1000).toStringAsFixed(0)} m away'
                  : '${masjid.distanceKm.toStringAsFixed(2)} km away',
              style: AppTextStyles.bodySmall(),
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                label: const Text('Get directions'),
                onPressed: _openDirections,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
