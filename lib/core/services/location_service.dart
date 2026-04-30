import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationException implements Exception {
  final String message;
  const LocationException(this.message);
  @override
  String toString() => message;
}

class LocationService {
  LocationService(this._prefs);
  final SharedPreferences _prefs;

  static const String _kCachedLat = 'loc.cached_lat';
  static const String _kCachedLon = 'loc.cached_lon';

  Future<void> cacheLocation(double lat, double lon) async {
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
}
