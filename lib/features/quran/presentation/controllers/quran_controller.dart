import 'package:get/get.dart';

import '../../data/repositories/quran_repository.dart';
import '../../domain/entities/surah.dart';

class QuranController extends GetxController {
  QuranController(this._repo);
  final QuranRepository _repo;

  final RxBool isLoading = true.obs;
  final RxnString errorMessage = RxnString();
  final RxList<Surah> surahs = <Surah>[].obs;
  final RxString filter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    try {
      surahs.value = await _repo.surahs();
    } catch (e) {
      errorMessage.value = 'Failed to load Quran data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  List<Surah> get filteredSurahs {
    final q = filter.value.trim().toLowerCase();
    if (q.isEmpty) return surahs;
    return surahs.where((s) {
      if (s.number.toString() == q) return true;
      if (s.englishName.toLowerCase().contains(q)) return true;
      if (s.englishMeaning.toLowerCase().contains(q)) return true;
      if (s.arabicName.contains(filter.value.trim())) return true;
      return false;
    }).toList();
  }

  ({int surah, int ayah})? get lastRead => _repo.lastRead();
}
