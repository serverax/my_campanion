import 'package:get/get.dart';

import '../../app.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(name: AppRoutes.home, page: () => const HomePage()),
    // Feature routes will be appended here as they're built:
    //   GetPage(name: AppRoutes.quran,        page: () => const SurahListPage(), binding: QuranBinding()),
    //   GetPage(name: AppRoutes.prayerTimes,  page: () => const PrayerTimesPage(), binding: PrayerTimesBinding()),
    //   ...
  ];
}
