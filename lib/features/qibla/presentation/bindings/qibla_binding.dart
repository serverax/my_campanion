import 'package:get/get.dart';

import '../../../../core/services/location_service.dart';
import '../controllers/qibla_controller.dart';

class QiblaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QiblaController>(
      () => QiblaController(Get.find<LocationService>()),
      fenix: true,
    );
  }
}
