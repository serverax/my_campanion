import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/services/location_service.dart';
import 'features/adhkar/data/repositories/adhkar_repository.dart';
import 'features/calendar/data/repositories/calendar_repository.dart';
import 'features/masjid_finder/data/datasources/overpass_data_source.dart';
import 'features/masjid_finder/data/repositories/masjid_repository.dart';
import 'features/prayer_times/data/repositories/prayer_times_repository.dart';
import 'features/quran/data/datasources/quran_local_data_source.dart';
import 'features/quran/data/repositories/quran_repository.dart';
import 'features/quran_radio/data/repositories/quran_radio_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.rahma.rahma_app.audio',
    androidNotificationChannelName: 'Quran Radio',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
  );

  final prefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(prefs, permanent: true);
  Get.put<LocationService>(LocationService(prefs), permanent: true);
  Get.put<PrayerTimesRepository>(PrayerTimesRepository(prefs), permanent: true);
  Get.put<CalendarRepository>(CalendarRepository(), permanent: true);
  Get.put<AdhkarRepository>(AdhkarRepository(prefs), permanent: true);
  final overpass = OverpassDataSource();
  Get.put<OverpassDataSource>(overpass, permanent: true);
  Get.put<MasjidRepository>(MasjidRepository(prefs, overpass), permanent: true);
  final quranSource = QuranLocalDataSource();
  Get.put<QuranLocalDataSource>(quranSource, permanent: true);
  final quranRepo = QuranRepository(quranSource, prefs);
  Get.put<QuranRepository>(quranRepo, permanent: true);
  Get.put<QuranRadioRepository>(
    QuranRadioRepository(quranRepo, prefs),
    permanent: true,
  );

  runApp(const RahmaApp());
}
