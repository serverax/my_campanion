import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/prayer_settings.dart';
import '../controllers/prayer_times_controller.dart';

class PrayerSettingsPage extends StatefulWidget {
  const PrayerSettingsPage({super.key});

  @override
  State<PrayerSettingsPage> createState() => _PrayerSettingsPageState();
}

class _PrayerSettingsPageState extends State<PrayerSettingsPage> {
  late final PrayerTimesController _controller;
  late final TextEditingController _latCtrl;
  late final TextEditingController _lonCtrl;
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PrayerTimesController>();
    final s = _controller.settings.value;
    _latCtrl = TextEditingController(
      text: s.manualLatitude?.toStringAsFixed(4) ?? '',
    );
    _lonCtrl = TextEditingController(
      text: s.manualLongitude?.toStringAsFixed(4) ?? '',
    );
    _nameCtrl = TextEditingController(text: s.manualLocationName ?? '');
  }

  @override
  void dispose() {
    _latCtrl.dispose();
    _lonCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prayer Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.lg),
          children: <Widget>[
            Text('Calculation method', style: AppTextStyles.h4()),
            const SizedBox(height: AppSizes.sm),
            Obx(
              () => DropdownButtonFormField<CalculationMethod>(
                initialValue: _controller.settings.value.method,
                isExpanded: true,
                items: CalculationMethod.values
                    .map(
                      (m) => DropdownMenuItem<CalculationMethod>(
                        value: m,
                        child: Text(m.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (m) {
                  if (m == null) return;
                  _controller.updateSettings(
                    _controller.settings.value.copyWith(method: m),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSizes.xl),
            Text('Madhab (Asr calculation)', style: AppTextStyles.h4()),
            const SizedBox(height: AppSizes.sm),
            Obx(() {
              final current = _controller.settings.value.madhab;
              return Column(
                children: Madhab.values
                    .map(
                      (m) => RadioListTile<Madhab>(
                        value: m,
                        groupValue: current,
                        onChanged: (selected) {
                          if (selected == null) return;
                          _controller.updateSettings(
                            _controller.settings.value.copyWith(
                              madhab: selected,
                            ),
                          );
                        },
                        title: Text(m.displayName),
                      ),
                    )
                    .toList(),
              );
            }),
            const SizedBox(height: AppSizes.xl),
            Text('Manual location', style: AppTextStyles.h4()),
            Text(
              'Override GPS by entering coordinates. Leave fields blank to use GPS.',
              style: AppTextStyles.bodySmall(),
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Location name (optional)',
                hintText: 'e.g. Cairo',
              ),
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _latCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^-?\d*\.?\d*'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Latitude (-90 to 90)',
                      hintText: 'e.g. 30.0444',
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: TextField(
                    controller: _lonCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^-?\d*\.?\d*'),
                      ),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Longitude (-180 to 180)',
                      hintText: 'e.g. 31.2357',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save manual location'),
                    onPressed: _saveManualLocation,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            OutlinedButton.icon(
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Clear manual & use GPS'),
              onPressed: _clearManualLocation,
            ),
          ],
        ),
      ),
    );
  }

  void _saveManualLocation() {
    final lat = double.tryParse(_latCtrl.text.trim());
    final lon = double.tryParse(_lonCtrl.text.trim());
    if (lat == null ||
        lon == null ||
        lat < -90 ||
        lat > 90 ||
        lon < -180 ||
        lon > 180) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.errorRed,
          content: Text(
            'Invalid coordinates. Latitude -90 to 90, longitude -180 to 180.',
            style: AppTextStyles.bodySmall().copyWith(color: AppColors.bgWhite),
          ),
        ),
      );
      return;
    }
    final name = _nameCtrl.text.trim();
    _controller.updateSettings(
      _controller.settings.value.copyWith(
        manualLatitude: lat,
        manualLongitude: lon,
        manualLocationName: name.isEmpty ? null : name,
      ),
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Location saved.')));
  }

  void _clearManualLocation() {
    _latCtrl.clear();
    _lonCtrl.clear();
    _nameCtrl.clear();
    final s = _controller.settings.value;
    _controller.updateSettings(s.copyWith(clearManualLocation: true));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Switched to GPS.')));
  }
}
