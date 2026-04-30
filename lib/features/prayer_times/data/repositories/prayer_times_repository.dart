import 'package:adhan/adhan.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/prayer_settings.dart';

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);
  @override
  String toString() => message;
}

class PrayerTimesRepository {
  PrayerTimesRepository(this._prefs);
  final SharedPreferences _prefs;

  static const String _kMethodIdx = 'pt.method_idx';
  static const String _kMadhabIdx = 'pt.madhab_idx';
  static const String _kManualLat = 'pt.manual_lat';
  static const String _kManualLon = 'pt.manual_lon';
  static const String _kManualName = 'pt.manual_name';
  static const String _kCachedLat = 'pt.cached_lat';
  static const String _kCachedLon = 'pt.cached_lon';

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

  Future<void> cacheLastLocation(double lat, double lon) async {
    await _prefs.setDouble(_kCachedLat, lat);
    await _prefs.setDouble(_kCachedLon, lon);
  }

  ({double lat, double lon})? loadCachedLocation() {
    final lat = _prefs.getDouble(_kCachedLat);
    final lon = _prefs.getDouble(_kCachedLon);
    if (lat == null || lon == null) return null;
    return (lat: lat, lon: lon);
  }

  Future<Position> requestCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationException(
        'Location services are turned off. Enable GPS in your device settings.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const LocationException('Location permission denied.');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permission permanently denied. Open app settings to grant it.',
      );
    }

    if (kIsWeb) {
      return Geolocator.getCurrentPosition();
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 15),
      ),
    );
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
