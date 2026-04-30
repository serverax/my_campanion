import 'package:get/get.dart';

import '../../data/repositories/quran_repository.dart';
import '../controllers/quran_controller.dart';
import '../controllers/surah_reader_controller.dart';

class QuranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranController>(
      () => QuranController(Get.find<QuranRepository>()),
      fenix: true,
    );
    Get.lazyPut<SurahReaderController>(() {
      final c = Get.find<QuranController>();
      return SurahReaderController(Get.find<QuranRepository>(), c.surahs);
    }, fenix: true);
  }
}
