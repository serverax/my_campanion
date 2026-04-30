class Reciter {
  final String id;
  final String englishName;
  final String arabicName;
  final String description;

  /// URL pattern with `{surah}` placeholder. e.g.
  /// `https://server11.mp3quran.net/yasser/{surah}.mp3`
  /// where {surah} expands to a zero-padded 3-digit surah number (001..114).
  final String urlPattern;

  const Reciter({
    required this.id,
    required this.englishName,
    required this.arabicName,
    required this.description,
    required this.urlPattern,
  });

  /// Build the streaming URL for a given surah number (1..114).
  String urlFor(int surahNumber) {
    final padded = surahNumber.toString().padLeft(3, '0');
    return urlPattern.replaceAll('{surah}', padded);
  }

  static const Reciter yaserAlDosari = Reciter(
    id: 'yaser_aldosari',
    englishName: 'Yaser Al-Dosari',
    arabicName: 'ياسر الدوسري',
    description: 'Imam of Masjid al-Haram, Mecca',
    urlPattern: 'https://server11.mp3quran.net/yasser/{surah}.mp3',
  );
}
