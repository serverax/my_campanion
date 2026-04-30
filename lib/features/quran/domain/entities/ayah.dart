class Ayah {
  final int surahNumber;
  final int numberInSurah;
  final String arabic;
  final String translation;

  const Ayah({
    required this.surahNumber,
    required this.numberInSurah,
    required this.arabic,
    required this.translation,
  });

  String get bookmarkKey => '$surahNumber:$numberInSurah';
}

class AyahSearchResult {
  final Ayah ayah;
  final String surahName;
  const AyahSearchResult({required this.ayah, required this.surahName});
}
