import 'package:get/get.dart';

import '../../../../core/services/location_service.dart';
import '../../data/repositories/prayer_times_repository.dart';
import '../controllers/prayer_times_controller.dart';

class PrayerTimesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrayerTimesController>(
      () => PrayerTimesController(
        Get.find<PrayerTimesRepository>(),
        Get.find<LocationService>(),
      ),
      fenix: true,
    );
  }
}
