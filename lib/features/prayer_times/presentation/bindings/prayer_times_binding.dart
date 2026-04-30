import 'package:get/get.dart';

import '../../data/repositories/prayer_times_repository.dart';
import '../controllers/prayer_times_controller.dart';

class PrayerTimesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrayerTimesController>(
      () => PrayerTimesController(Get.find<PrayerTimesRepository>()),
      fenix: true,
    );
  }
}
