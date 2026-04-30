import 'package:get/get.dart';

import '../../data/repositories/calendar_repository.dart';
import '../controllers/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(
      () => CalendarController(Get.find<CalendarRepository>()),
      fenix: true,
    );
  }
}
