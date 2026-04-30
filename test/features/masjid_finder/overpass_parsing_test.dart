import 'package:flutter_test/flutter_test.dart';

import 'package:my_companion/features/masjid_finder/data/datasources/overpass_data_source.dart';

void main() {
  group('OverpassDataSource.parseElements', () {
    const cairoLat = 30.0444;
    const cairoLon = 31.2357;

    test('parses node + way + relation, drops malformed entries', () {
      final json = <String, dynamic>{
        'elements': <Map<String, dynamic>>[
          // node with direct lat/lon
          <String, dynamic>{
            'type': 'node',
            'id': 1,
            'lat': 30.0500,
            'lon': 31.2450,
            'tags': <String, String>{
              'amenity': 'place_of_worship',
              'religion': 'muslim',
              'name': 'Al-Azhar Mosque',
              'name:en': 'Al-Azhar Mosque',
              'name:ar': 'الأزهر الشريف',
            },
          },
          // way with center
          <String, dynamic>{
            'type': 'way',
            'id': 2,
            'center': <String, dynamic>{'lat': 30.0470, 'lon': 31.2380},
            'tags': <String, String>{
              'amenity': 'place_of_worship',
              'religion': 'muslim',
              'name': 'Sayyida Zaynab Mosque',
            },
          },
          // relation with center
          <String, dynamic>{
            'type': 'relation',
            'id': 3,
            'center': <String, dynamic>{'lat': 30.0420, 'lon': 31.2300},
            'tags': <String, String>{
              'amenity': 'place_of_worship',
              'religion': 'muslim',
            }, // no name → falls back to "Masjid"
          },
          // malformed — no lat/lon and no center
          <String, dynamic>{
            'type': 'node',
            'id': 4,
            'tags': <String, String>{'name': 'Ghost Mosque'},
          },
        ],
      };
      final masjids = OverpassDataSource.parseElements(
        json,
        originLat: cairoLat,
        originLon: cairoLon,
      );

      expect(masjids.length, 3);
      expect(masjids.any((m) => m.id == 'node_1'), isTrue);
      expect(masjids.any((m) => m.id == 'way_2'), isTrue);
      expect(masjids.any((m) => m.id == 'relation_3'), isTrue);
      // The unnamed relation falls back to "Masjid"
      expect(masjids.firstWhere((m) => m.id == 'relation_3').name, 'Masjid');
    });

    test('sorts by distance ascending', () {
      final json = <String, dynamic>{
        'elements': <Map<String, dynamic>>[
          <String, dynamic>{
            'type': 'node',
            'id': 1,
            'lat': 30.10,
            'lon': 31.30,
            'tags': <String, String>{'name': 'far'},
          },
          <String, dynamic>{
            'type': 'node',
            'id': 2,
            'lat': 30.045,
            'lon': 31.236,
            'tags': <String, String>{'name': 'near'},
          },
          <String, dynamic>{
            'type': 'node',
            'id': 3,
            'lat': 30.06,
            'lon': 31.24,
            'tags': <String, String>{'name': 'mid'},
          },
        ],
      };
      final masjids = OverpassDataSource.parseElements(
        json,
        originLat: cairoLat,
        originLon: cairoLon,
      );
      expect(masjids.map((m) => m.name).toList(), <String>[
        'near',
        'mid',
        'far',
      ]);
    });

    test('haversine: ~3.4 km between Times Square and Central Park', () {
      final d = haversineKm(40.7580, -73.9855, 40.7829, -73.9654);
      expect(d, closeTo(3.0, 0.5));
    });

    test('haversine: zero distance is zero', () {
      expect(haversineKm(0, 0, 0, 0), 0.0);
    });

    test('empty elements returns empty list', () {
      final masjids = OverpassDataSource.parseElements(
        <String, dynamic>{'elements': <dynamic>[]},
        originLat: 0,
        originLon: 0,
      );
      expect(masjids, isEmpty);
    });
  });
}
