import 'package:adhan/adhan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/prayer_settings.dart';

class PrayerTimesRepository {
  PrayerTimesRepository(this._prefs);
  final SharedPreferences _prefs;

  static const String _kMethodIdx = 'pt.method_idx';
  static const String _kMadhabIdx = 'pt.madhab_idx';
  static const String _kManualLat = 'pt.manual_lat';
  static const String _kManualLon = 'pt.manual_lon';
  static const String _kManualName = 'pt.manual_name';

  PrayerSettings loadSettings() {
    final mIdx = _prefs.getInt(_kMethodIdx);
    final madIdx = _prefs.getInt(_kMadhabIdx);
    return PrayerSettings(
      method:
          (mIdx != null && mIdx >= 0 && mIdx < CalculationMethod.values.length)
          ? CalculationMethod.values[mIdx]
          : PrayerSettings.defaults.method,
      madhab: (madIdx != null && madIdx >= 0 && madIdx < Madhab.values.length)
          ? Madhab.values[madIdx]
          : PrayerSettings.defaults.madhab,
      manualLatitude: _prefs.getDouble(_kManualLat),
      manualLongitude: _prefs.getDouble(_kManualLon),
      manualLocationName: _prefs.getString(_kManualName),
    );
  }

  Future<void> saveSettings(PrayerSettings settings) async {
    await _prefs.setInt(_kMethodIdx, settings.method.index);
    await _prefs.setInt(_kMadhabIdx, settings.madhab.index);
    if (settings.manualLatitude != null && settings.manualLongitude != null) {
      await _prefs.setDouble(_kManualLat, settings.manualLatitude!);
      await _prefs.setDouble(_kManualLon, settings.manualLongitude!);
    } else {
      await _prefs.remove(_kManualLat);
      await _prefs.remove(_kManualLon);
    }
    if (settings.manualLocationName != null &&
        settings.manualLocationName!.isNotEmpty) {
      await _prefs.setString(_kManualName, settings.manualLocationName!);
    } else {
      await _prefs.remove(_kManualName);
    }
  }

  PrayerTimes calculate({
    required Coordinates coords,
    required DateTime date,
    required PrayerSettings settings,
  }) {
    final params = settings.method.getParameters();
    params.madhab = settings.madhab;
    return PrayerTimes(
      coords,
      DateComponents(date.year, date.month, date.day),
      params,
    );
  }
}
