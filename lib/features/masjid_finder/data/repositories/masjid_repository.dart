import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/masjid.dart';
import '../datasources/overpass_data_source.dart';

class MasjidRepository {
  MasjidRepository(this._prefs, this._source);
  final SharedPreferences _prefs;
  final OverpassDataSource _source;

  static const String _kCacheKey = 'masjid.cache.v1';
  static const Duration _ttl = Duration(hours: 24);
  static const double _radiusKmDelta = 1.0; // re-fetch if user moved >1 km
  static const int _radiusMeters = 5000; // 5 km

  /// Returns mosques within 5 km of (lat, lon). Uses a 24-hour cache when
  /// the user has not moved more than ~1 km from the cached origin; otherwise
  /// fetches fresh from Overpass and updates the cache.
  Future<List<Masjid>> findNearby({
    required double lat,
    required double lon,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _readCache(lat: lat, lon: lon);
      if (cached != null) return cached;
    }

    final results = await _source.fetchNearbyMosques(
      lat: lat,
      lon: lon,
      radiusMeters: _radiusMeters,
    );
    await _writeCache(lat: lat, lon: lon, masjids: results);
    return results;
  }

  List<Masjid>? _readCache({required double lat, required double lon}) {
    final raw = _prefs.getString(_kCacheKey);
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final ts = DateTime.fromMillisecondsSinceEpoch(
        json['timestamp'] as int,
        isUtc: true,
      );
      if (DateTime.now().toUtc().difference(ts) > _ttl) return null;

      final originLat = (json['originLat'] as num).toDouble();
      final originLon = (json['originLon'] as num).toDouble();
      final movedKm = haversineKm(lat, lon, originLat, originLon);
      if (movedKm > _radiusKmDelta) return null;

      final list = (json['masjids'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Masjid.fromJson)
          .toList();
      // Refresh distances against current location
      return list
          .map(
            (m) => Masjid(
              id: m.id,
              name: m.name,
              nameEn: m.nameEn,
              nameAr: m.nameAr,
              latitude: m.latitude,
              longitude: m.longitude,
              distanceKm: haversineKm(lat, lon, m.latitude, m.longitude),
            ),
          )
          .toList()
        ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache({
    required double lat,
    required double lon,
    required List<Masjid> masjids,
  }) async {
    final json = <String, dynamic>{
      'timestamp': DateTime.now().toUtc().millisecondsSinceEpoch,
      'originLat': lat,
      'originLon': lon,
      'masjids': masjids.map((m) => m.toJson()).toList(),
    };
    await _prefs.setString(_kCacheKey, jsonEncode(json));
  }

  Future<void> clearCache() => _prefs.remove(_kCacheKey).then((_) {});
}
