import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';
import '../datasources/quran_local_data_source.dart';

class QuranRepository {
  QuranRepository(this._source, this._prefs);
  final QuranLocalDataSource _source;
  final SharedPreferences _prefs;

  static const String _kBookmarksKey = 'quran.bookmarks.v1';

  Future<List<Surah>> surahs() => _source.loadSurahList();

  Future<List<Ayah>> ayahsOf(int surahNumber) => _source.loadSurah(surahNumber);

  Future<List<AyahSearchResult>> search(String query) => _source.search(query);

  // Bookmarks ----
  /// Returns bookmarked ayahs (encoded as "surah:ayah").
  List<String> bookmarkedKeys() {
    final raw = _prefs.getStringList(_kBookmarksKey);
    return raw ?? <String>[];
  }

  bool isBookmarked(Ayah a) => bookmarkedKeys().contains(a.bookmarkKey);

  Future<void> toggleBookmark(Ayah a) async {
    final list = List<String>.of(bookmarkedKeys());
    if (list.contains(a.bookmarkKey)) {
      list.remove(a.bookmarkKey);
    } else {
      list.add(a.bookmarkKey);
    }
    await _prefs.setStringList(_kBookmarksKey, list);
  }

  Future<List<Ayah>> bookmarkedAyahs() async {
    final keys = bookmarkedKeys();
    final out = <Ayah>[];
    for (final k in keys) {
      final parts = k.split(':');
      if (parts.length != 2) continue;
      final s = int.tryParse(parts[0]);
      final n = int.tryParse(parts[1]);
      if (s == null || n == null) continue;
      final ayah = await _source.ayahAt(s, n);
      if (ayah != null) out.add(ayah);
    }
    return out;
  }

  // Last-read position --
  static const String _kLastReadKey = 'quran.last_read';

  ({int surah, int ayah})? lastRead() {
    final raw = _prefs.getString(_kLastReadKey);
    if (raw == null) return null;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      return (surah: j['surah'] as int, ayah: j['ayah'] as int);
    } catch (_) {
      return null;
    }
  }

  Future<void> setLastRead(int surah, int ayah) async {
    await _prefs.setString(
      _kLastReadKey,
      jsonEncode(<String, int>{'surah': surah, 'ayah': ayah}),
    );
  }
}
