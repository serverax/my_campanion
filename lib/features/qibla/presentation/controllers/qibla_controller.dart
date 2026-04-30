import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';

import '../../../../core/services/location_service.dart';

class QiblaController extends GetxController {
  QiblaController(this._location);
  final LocationService _location;

  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();

  /// Bearing from current location to the Kaaba, 0-360° clockwise from true north.
  final RxnDouble qiblaBearing = RxnDouble();

  /// Device's facing direction, 0-360° from magnetic north. null on platforms with no compass.
  final RxnDouble heading = RxnDouble();

  final Rxn<({double lat, double lon})> coords =
      Rxn<({double lat, double lon})>();

  StreamSubscription<CompassEvent>? _compassSub;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
    _startCompass();
  }

  @override
  void onClose() {
    _compassSub?.cancel();
    super.onClose();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    errorMessage.value = null;

    // Show cached coords immediately if available
    final cached = _location.loadCachedLocation();
    if (cached != null) {
      coords.value = cached;
      qiblaBearing.value = Qibla(Coordinates(cached.lat, cached.lon)).direction;
    }

    try {
      final pos = await _location.requestCurrentLocation();
      coords.value = (lat: pos.latitude, lon: pos.longitude);
      qiblaBearing.value = Qibla(
        Coordinates(pos.latitude, pos.longitude),
      ).direction;
      await _location.cacheLocation(pos.latitude, pos.longitude);
    } on LocationException catch (e) {
      if (qiblaBearing.value == null) {
        errorMessage.value = e.message;
      }
    } catch (_) {
      if (qiblaBearing.value == null) {
        errorMessage.value =
            'Could not determine Qibla. Set a location in Prayer Settings.';
      }
    }
    isLoading.value = false;
  }

  void _startCompass() {
    final stream = FlutterCompass.events;
    if (stream == null) {
      return; // Platform without a compass (web, desktop)
    }
    _compassSub = stream.listen((event) {
      heading.value = event.heading;
    });
  }

  Future<void> reload() async => _bootstrap();
}
