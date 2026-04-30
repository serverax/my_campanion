import 'package:adhan/adhan.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Qibla bearing', () {
    test('is between 0 and 360 for known cities', () {
      final cities = <Coordinates>[
        Coordinates(40.7128, -74.0060), // New York
        Coordinates(51.5074, -0.1278), // London
        Coordinates(35.6762, 139.6503), // Tokyo
        Coordinates(-33.8688, 151.2093), // Sydney
        Coordinates(30.0444, 31.2357), // Cairo
      ];
      for (final c in cities) {
        final bearing = Qibla(c).direction;
        expect(bearing, isNot(double.nan));
        expect(bearing, greaterThanOrEqualTo(0));
        expect(bearing, lessThan(360));
      }
    });

    test('points roughly north-east from New York', () {
      final ny = Coordinates(40.7128, -74.0060);
      final bearing = Qibla(ny).direction;
      // Great-circle bearing from NYC to Mecca is ~58°
      expect(bearing, inInclusiveRange(50, 70));
    });

    test('points roughly south-east from London', () {
      final london = Coordinates(51.5074, -0.1278);
      final bearing = Qibla(london).direction;
      // ~119°
      expect(bearing, inInclusiveRange(110, 130));
    });

    test('points roughly west from Tokyo', () {
      final tokyo = Coordinates(35.6762, 139.6503);
      final bearing = Qibla(tokyo).direction;
      // ~293° (WNW)
      expect(bearing, inInclusiveRange(285, 300));
    });

    test('points roughly south from Cairo', () {
      final cairo = Coordinates(30.0444, 31.2357);
      final bearing = Qibla(cairo).direction;
      // Mecca is south-east of Cairo; bearing ~136°
      expect(bearing, inInclusiveRange(125, 145));
    });
  });
}
