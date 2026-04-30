import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../../domain/entities/masjid.dart';

class OverpassException implements Exception {
  final String message;
  const OverpassException(this.message);
  @override
  String toString() => 'OverpassException: $message';
}

class OverpassDataSource {
  OverpassDataSource({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  static const String _endpoint = 'https://overpass-api.de/api/interpreter';
  static const String _userAgent =
      'RahmaApp/1.0 (com.rahma.rahma_app; +https://github.com/serverax/my_campanion)';

  /// Fetch mosques within `radiusMeters` of (lat, lon) from OpenStreetMap
  /// via the Overpass API. Returns a list sorted by distance ascending.
  Future<List<Masjid>> fetchNearbyMosques({
    required double lat,
    required double lon,
    required int radiusMeters,
  }) async {
    final query =
        '''
[out:json][timeout:25];
(
  node["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$lat,$lon);
  way["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$lat,$lon);
  relation["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$lat,$lon);
);
out center tags;
''';

    final response = await _client.post(
      Uri.parse(_endpoint),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'User-Agent': _userAgent,
      },
      body: <String, String>{'data': query},
    );

    if (response.statusCode != 200) {
      throw OverpassException(
        'Overpass API returned HTTP ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return parseElements(json, originLat: lat, originLon: lon);
  }

  static List<Masjid> parseElements(
    Map<String, dynamic> json, {
    required double originLat,
    required double originLon,
  }) {
    final elements = json['elements'] as List<dynamic>? ?? <dynamic>[];
    final masjids = <Masjid>[];

    for (final raw in elements) {
      final el = raw as Map<String, dynamic>;
      final tags =
          (el['tags'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
      final name =
          (tags['name'] ?? tags['name:en'] ?? tags['name:ar'] ?? 'Masjid')
              as String;
      final nameEn = tags['name:en'] as String?;
      final nameAr = tags['name:ar'] as String?;

      double? lat;
      double? lon;
      if (el['lat'] != null && el['lon'] != null) {
        lat = (el['lat'] as num).toDouble();
        lon = (el['lon'] as num).toDouble();
      } else if (el['center'] is Map) {
        final c = el['center'] as Map<String, dynamic>;
        lat = (c['lat'] as num?)?.toDouble();
        lon = (c['lon'] as num?)?.toDouble();
      }
      if (lat == null || lon == null) continue;

      masjids.add(
        Masjid(
          id: '${el['type']}_${el['id']}',
          name: name,
          nameEn: nameEn,
          nameAr: nameAr,
          latitude: lat,
          longitude: lon,
          distanceKm: haversineKm(originLat, originLon, lat, lon),
        ),
      );
    }

    masjids.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return masjids;
  }

  void close() => _client.close();
}

/// Great-circle distance in kilometres between two lat/lon pairs.
double haversineKm(double lat1, double lon1, double lat2, double lon2) {
  const double earthKm = 6371.0;
  const double degToRad = math.pi / 180.0;
  final dLat = (lat2 - lat1) * degToRad;
  final dLon = (lon2 - lon1) * degToRad;
  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1 * degToRad) *
          math.cos(lat2 * degToRad) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthKm * c;
}
