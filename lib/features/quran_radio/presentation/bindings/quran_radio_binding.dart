import 'package:get/get.dart';

import '../../data/repositories/quran_radio_repository.dart';
import '../controllers/quran_radio_controller.dart';

class QuranRadioBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranRadioController>(
      () => QuranRadioController(Get.find<QuranRadioRepository>()),
      fenix: true,
    );
  }
}
