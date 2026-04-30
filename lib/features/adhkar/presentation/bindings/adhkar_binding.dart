import 'package:get/get.dart';

import '../../data/repositories/adhkar_repository.dart';
import '../controllers/adhkar_controller.dart';

class AdhkarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdhkarController>(
      () => AdhkarController(Get.find<AdhkarRepository>()),
      fenix: true,
    );
  }
}
