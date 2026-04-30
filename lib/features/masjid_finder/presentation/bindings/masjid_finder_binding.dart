import 'package:get/get.dart';

import '../../../../core/services/location_service.dart';
import '../../data/repositories/masjid_repository.dart';
import '../controllers/masjid_finder_controller.dart';

class MasjidFinderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MasjidFinderController>(
      () => MasjidFinderController(
        Get.find<MasjidRepository>(),
        Get.find<LocationService>(),
      ),
      fenix: true,
    );
  }
}
