import 'package:adhan/adhan.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_companion/features/prayer_times/data/repositories/prayer_times_repository.dart';
import 'package:my_companion/features/prayer_times/domain/entities/prayer_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PrayerTimesRepository', () {
    late PrayerTimesRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repo = PrayerTimesRepository(prefs);
    });

    test('produces ordered times for Mecca on the summer solstice', () {
      final mecca = Coordinates(21.4225, 39.8262);
      final times = repo.calculate(
        coords: mecca,
        date: DateTime(2026, 6, 21),
        settings: const PrayerSettings(
          method: CalculationMethod.umm_al_qura,
          madhab: Madhab.shafi,
        ),
      );

      expect(times.fajr.isBefore(times.sunrise), isTrue);
      expect(times.sunrise.isBefore(times.dhuhr), isTrue);
      expect(times.dhuhr.isBefore(times.asr), isTrue);
      expect(times.asr.isBefore(times.maghrib), isTrue);
      expect(times.maghrib.isBefore(times.isha), isTrue);

      // Mecca summer solstice: total fajr→isha span ~13-18 h
      final span = times.isha.difference(times.fajr);
      expect(span.inHours, inInclusiveRange(11, 19));
    });

    test('settings load+save round-trip', () async {
      const original = PrayerSettings(
        method: CalculationMethod.karachi,
        madhab: Madhab.hanafi,
        manualLatitude: 30.0444,
        manualLongitude: 31.2357,
        manualLocationName: 'Cairo',
      );
      await repo.saveSettings(original);
      final loaded = repo.loadSettings();
      expect(loaded.method, CalculationMethod.karachi);
      expect(loaded.madhab, Madhab.hanafi);
      expect(loaded.manualLatitude, closeTo(30.0444, 1e-6));
      expect(loaded.manualLongitude, closeTo(31.2357, 1e-6));
      expect(loaded.manualLocationName, 'Cairo');
      expect(loaded.hasManualLocation, isTrue);
    });

    test('clearing manual location persists null', () async {
      const withManual = PrayerSettings(
        method: CalculationMethod.muslim_world_league,
        madhab: Madhab.shafi,
        manualLatitude: 30.0,
        manualLongitude: 31.0,
        manualLocationName: 'Test',
      );
      await repo.saveSettings(withManual);
      final cleared = withManual.copyWith(clearManualLocation: true);
      await repo.saveSettings(cleared);

      final loaded = repo.loadSettings();
      expect(loaded.hasManualLocation, isFalse);
      expect(loaded.manualLatitude, isNull);
      expect(loaded.manualLongitude, isNull);
      expect(loaded.manualLocationName, isNull);
    });
  });
}
