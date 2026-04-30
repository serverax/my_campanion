import 'package:get/get.dart';

import '../../app.dart';
import '../../features/prayer_times/presentation/bindings/prayer_times_binding.dart';
import '../../features/prayer_times/presentation/pages/prayer_settings_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/qibla/presentation/bindings/qibla_binding.dart';
import '../../features/qibla/presentation/pages/qibla_page.dart';
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
  ];
}
