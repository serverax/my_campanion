import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:get/get.dart';

import '../../../../core/services/location_service.dart';
import '../../data/repositories/prayer_times_repository.dart';
import '../../domain/entities/prayer_settings.dart';

class PrayerTimesController extends GetxController {
  PrayerTimesController(this._repo, this._location);
  final PrayerTimesRepository _repo;
  final LocationService _location;

  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();
  final RxnString locationLabel = RxnString();
  final Rx<PrayerSettings> settings = PrayerSettings.defaults.obs;
  final Rxn<Coordinates> coordinates = Rxn<Coordinates>();
  final Rxn<PrayerTimes> prayerTimes = Rxn<PrayerTimes>();
  final Rx<Prayer> currentPrayer = Prayer.none.obs;
  final Rx<Prayer> nextPrayer = Prayer.fajr.obs;
  final Rx<Duration> timeUntilNext = Duration.zero.obs;

  Timer? _ticker;

  @override
  void onInit() {
    super.onInit();
    settings.value = _repo.loadSettings();
    _bootstrap();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    errorMessage.value = null;

    final s = settings.value;
    Coordinates? coords;
    String? label;

    if (s.hasManualLocation) {
      coords = Coordinates(s.manualLatitude!, s.manualLongitude!);
      label = (s.manualLocationName?.isNotEmpty ?? false)
          ? s.manualLocationName
          : 'Manual location';
    } else {
      final cached = _location.loadCachedLocation();
      if (cached != null) {
        coords = Coordinates(cached.lat, cached.lon);
        label = 'Last known location';
      }
      try {
        final pos = await _location.requestCurrentLocation();
        coords = Coordinates(pos.latitude, pos.longitude);
        label = 'Current location';
        await _location.cacheLocation(pos.latitude, pos.longitude);
      } on LocationException catch (e) {
        if (coords == null) {
          errorMessage.value = e.message;
        }
      } catch (e) {
        if (coords == null) {
          errorMessage.value =
              'Could not get location. Set one manually in Prayer Settings.';
        }
      }
    }

    if (coords == null) {
      isLoading.value = false;
      return;
    }

    coordinates.value = coords;
    locationLabel.value = label;
    _recalculate();
    isLoading.value = false;
  }

  void _recalculate() {
    final c = coordinates.value;
    if (c == null) return;
    prayerTimes.value = _repo.calculate(
      coords: c,
      date: DateTime.now(),
      settings: settings.value,
    );
    _tick();
  }

  void _tick() {
    final pt = prayerTimes.value;
    final c = coordinates.value;
    if (pt == null || c == null) return;

    final now = DateTime.now();
    final next = pt.nextPrayerByDateTime(now);
    final cur = pt.currentPrayerByDateTime(now);
    currentPrayer.value = cur;

    if (next == Prayer.none) {
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final tomorrowPt = _repo.calculate(
        coords: c,
        date: tomorrow,
        settings: settings.value,
      );
      nextPrayer.value = Prayer.fajr;
      timeUntilNext.value = tomorrowPt.fajr.difference(now);
    } else {
      nextPrayer.value = next;
      final t = pt.timeForPrayer(next);
      if (t != null) {
        timeUntilNext.value = t.difference(now);
      }
    }
  }

  Future<void> updateSettings(PrayerSettings newSettings) async {
    await _repo.saveSettings(newSettings);
    settings.value = newSettings;
    await _bootstrap();
  }

  Future<void> refreshLocation() async {
    await _bootstrap();
  }
}
