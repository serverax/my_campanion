import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../../domain/entities/ayah.dart';
import '../../domain/entities/surah.dart';

/// Loads the bundled Quran JSON files (Arabic Quran-Uthmani + Sahih
/// International English) and exposes them via a small in-memory model.
///
/// Source attribution:
///   Arabic text:      Tanzil Quran-Uthmani (CC BY-ND 3.0)
///   English text:     Sahih International translation
///   API used to mirror both: https://alquran.cloud
class QuranLocalDataSource {
  Map<int, _RawSurah>? _ar;
  Map<int, _RawSurah>? _en;
  Future<void>? _loading;

  Future<void> _ensureLoaded() {
    if (_ar != null && _en != null) return Future<void>.value();
    return _loading ??= _loadOnce();
  }

  Future<void> _loadOnce() async {
    final arRaw = await rootBundle.loadString('assets/data/quran-ar.json');
    final enRaw = await rootBundle.loadString('assets/data/quran-en.json');
    final ar =
        (jsonDecode(arRaw) as Map<String, dynamic>)['data']
            as Map<String, dynamic>;
    final en =
        (jsonDecode(enRaw) as Map<String, dynamic>)['data']
            as Map<String, dynamic>;
    final arSurahs = (ar['surahs'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final enSurahs = (en['surahs'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    _ar = <int, _RawSurah>{
      for (final s in arSurahs) (s['number'] as int): _RawSurah.fromJson(s),
    };
    _en = <int, _RawSurah>{
      for (final s in enSurahs) (s['number'] as int): _RawSurah.fromJson(s),
    };
  }

  Future<List<Surah>> loadSurahList() async {
    await _ensureLoaded();
    final list = <Surah>[];
    for (final num in _ar!.keys.toList()..sort()) {
      final a = _ar![num]!;
      final e = _en![num]!;
      list.add(
        Surah(
          number: a.number,
          arabicName: a.name,
          englishName: e.englishName,
          englishMeaning: e.englishNameTranslation,
          revelationType: a.revelationType,
          ayahCount: a.ayahs.length,
        ),
      );
    }
    return list;
  }

  Future<List<Ayah>> loadSurah(int surahNumber) async {
    await _ensureLoaded();
    final ar = _ar![surahNumber];
    final en = _en![surahNumber];
    if (ar == null || en == null) return const <Ayah>[];
    final out = <Ayah>[];
    for (var i = 0; i < ar.ayahs.length; i++) {
      out.add(
        Ayah(
          surahNumber: surahNumber,
          numberInSurah: ar.ayahs[i].numberInSurah,
          arabic: ar.ayahs[i].text,
          translation: en.ayahs[i].text,
        ),
      );
    }
    return out;
  }

  Future<Ayah?> ayahAt(int surahNumber, int ayahNumberInSurah) async {
    await _ensureLoaded();
    final ar = _ar![surahNumber];
    final en = _en![surahNumber];
    if (ar == null || en == null) return null;
    for (var i = 0; i < ar.ayahs.length; i++) {
      if (ar.ayahs[i].numberInSurah == ayahNumberInSurah) {
        return Ayah(
          surahNumber: surahNumber,
          numberInSurah: ayahNumberInSurah,
          arabic: ar.ayahs[i].text,
          translation: en.ayahs[i].text,
        );
      }
    }
    return null;
  }

  /// Plain substring search across the English translation. Returns up to
  /// [limit] matches with surah context. Case-insensitive.
  Future<List<AyahSearchResult>> search(String query, {int limit = 200}) async {
    await _ensureLoaded();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const <AyahSearchResult>[];
    final results = <AyahSearchResult>[];
    for (final num in _ar!.keys.toList()..sort()) {
      final ar = _ar![num]!;
      final en = _en![num]!;
      for (var i = 0; i < ar.ayahs.length; i++) {
        final hay = en.ayahs[i].text.toLowerCase();
        if (hay.contains(q)) {
          results.add(
            AyahSearchResult(
              ayah: Ayah(
                surahNumber: num,
                numberInSurah: ar.ayahs[i].numberInSurah,
                arabic: ar.ayahs[i].text,
                translation: en.ayahs[i].text,
              ),
              surahName: en.englishName,
            ),
          );
          if (results.length >= limit) return results;
        }
      }
    }
    return results;
  }
}

class _RawSurah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final List<_RawAyah> ayahs;

  _RawSurah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory _RawSurah.fromJson(Map<String, dynamic> j) => _RawSurah(
    number: j['number'] as int,
    name: j['name'] as String,
    englishName: j['englishName'] as String,
    englishNameTranslation: j['englishNameTranslation'] as String,
    revelationType: j['revelationType'] as String,
    ayahs: (j['ayahs'] as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(_RawAyah.fromJson)
        .toList(),
  );
}

class _RawAyah {
  final int numberInSurah;
  final String text;
  _RawAyah({required this.numberInSurah, required this.text});
  factory _RawAyah.fromJson(Map<String, dynamic> j) => _RawAyah(
    numberInSurah: j['numberInSurah'] as int,
    text: j['text'] as String,
  );
}
