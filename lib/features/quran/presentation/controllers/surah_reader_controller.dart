import 'package:get/get.dart';

import '../../data/repositories/quran_repository.dart';
import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';

class SurahReaderController extends GetxController {
  SurahReaderController(this._repo, this._allSurahs);
  final QuranRepository _repo;
  final List<Surah> _allSurahs;

  final RxInt surahNumber = 1.obs;
  final RxBool isLoading = true.obs;
  final RxList<Ayah> ayahs = <Ayah>[].obs;
  final RxSet<String> bookmarks = <String>{}.obs;

  Future<void> open(int number) async {
    surahNumber.value = number;
    isLoading.value = true;
    ayahs.value = await _repo.ayahsOf(number);
    bookmarks
      ..clear()
      ..addAll(_repo.bookmarkedKeys());
    isLoading.value = false;
    if (ayahs.isNotEmpty) {
      await _repo.setLastRead(number, ayahs.first.numberInSurah);
    }
  }

  Surah? get currentSurah {
    for (final s in _allSurahs) {
      if (s.number == surahNumber.value) return s;
    }
    return null;
  }

  bool get hasPrev => surahNumber.value > 1;
  bool get hasNext => surahNumber.value < 114;

  Future<void> next() async {
    if (hasNext) await open(surahNumber.value + 1);
  }

  Future<void> prev() async {
    if (hasPrev) await open(surahNumber.value - 1);
  }

  Future<void> toggleBookmark(Ayah a) async {
    await _repo.toggleBookmark(a);
    bookmarks
      ..clear()
      ..addAll(_repo.bookmarkedKeys());
  }

  bool isBookmarked(Ayah a) => bookmarks.contains(a.bookmarkKey);
}
