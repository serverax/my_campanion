import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_companion/core/services/location_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocationService', () {
    late LocationService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      service = LocationService(prefs);
    });

    test('returns null when no location is cached', () {
      expect(service.loadCachedLocation(), isNull);
    });

    test('cache + load round-trip', () async {
      await service.cacheLocation(45.0, -73.5);
      final cached = service.loadCachedLocation();
      expect(cached, isNotNull);
      expect(cached!.lat, 45.0);
      expect(cached.lon, -73.5);
    });

    test('overwriting cache replaces values', () async {
      await service.cacheLocation(0, 0);
      await service.cacheLocation(51.5, -0.1);
      final cached = service.loadCachedLocation();
      expect(cached!.lat, closeTo(51.5, 1e-9));
      expect(cached.lon, closeTo(-0.1, 1e-9));
    });
  });
}
