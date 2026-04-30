class Surah {
  final int number;
  final String arabicName;
  final String englishName;
  final String englishMeaning;
  final String revelationType;
  final int ayahCount;

  const Surah({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.englishMeaning,
    required this.revelationType,
    required this.ayahCount,
  });

  bool get isMeccan => revelationType.toLowerCase() == 'meccan';
}
