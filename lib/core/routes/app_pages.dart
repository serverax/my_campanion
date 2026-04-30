import 'package:get/get.dart';

import '../../app.dart';
import '../../features/adhkar/presentation/bindings/adhkar_binding.dart';
import '../../features/adhkar/presentation/pages/adhkar_categories_page.dart';
import '../../features/calendar/presentation/bindings/calendar_binding.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/masjid_finder/presentation/bindings/masjid_finder_binding.dart';
import '../../features/masjid_finder/presentation/pages/masjid_finder_page.dart';
import '../../features/prayer_times/presentation/bindings/prayer_times_binding.dart';
import '../../features/prayer_times/presentation/pages/prayer_settings_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/qibla/presentation/bindings/qibla_binding.dart';
import '../../features/qibla/presentation/pages/qibla_page.dart';
import '../../features/quran/presentation/bindings/quran_binding.dart';
import '../../features/quran/presentation/pages/surah_list_page.dart';
import '../../features/quran_radio/presentation/bindings/quran_radio_binding.dart';
import '../../features/quran_radio/presentation/pages/quran_radio_page.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(name: AppRoutes.home, page: () => const HomePage()),
    GetPage<dynamic>(
      name: AppRoutes.prayerTimes,
      page: () => const PrayerTimesPage(),
      binding: PrayerTimesBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.prayerSettings,
      page: () => const PrayerSettingsPage(),
      binding: PrayerTimesBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.qibla,
      page: () => const QiblaPage(),
      binding: QiblaBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.calendar,
      page: () => const CalendarPage(),
      binding: CalendarBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.adhkar,
      page: () => const AdhkarCategoriesPage(),
      binding: AdhkarBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.masjidFinder,
      page: () => const MasjidFinderPage(),
      binding: MasjidFinderBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.quran,
      page: () => const SurahListPage(),
      binding: QuranBinding(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.quranRadio,
      page: () => const QuranRadioPage(),
      binding: QuranRadioBinding(),
    ),
  ];
}
