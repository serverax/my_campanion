import 'package:get/get.dart';

import '../../data/repositories/islamic_kb_repository.dart';
import '../controllers/islamic_kb_controller.dart';

class IslamicKbBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IslamicKbController>(
      () => IslamicKbController(Get.find<IslamicKbRepository>()),
      fenix: true,
    );
  }
}
