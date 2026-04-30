import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/services/location_service.dart';
import 'features/adhkar/data/repositories/adhkar_repository.dart';
import 'features/calendar/data/repositories/calendar_repository.dart';
import 'features/prayer_times/data/repositories/prayer_times_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs, permanent: true);
  Get.put<LocationService>(LocationService(prefs), permanent: true);
  Get.put<PrayerTimesRepository>(PrayerTimesRepository(prefs), permanent: true);
  Get.put<CalendarRepository>(CalendarRepository(), permanent: true);
  Get.put<AdhkarRepository>(AdhkarRepository(prefs), permanent: true);
  runApp(const RahmaApp());
}
