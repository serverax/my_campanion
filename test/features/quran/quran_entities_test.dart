import 'package:flutter_test/flutter_test.dart';

import 'package:my_companion/features/quran/domain/entities/ayah.dart';
import 'package:my_companion/features/quran/domain/entities/surah.dart';

void main() {
  group('Surah', () {
    test('isMeccan reflects revelationType', () {
      const meccan = Surah(
        number: 1,
        arabicName: 'الفاتحة',
        englishName: 'Al-Faatiha',
        englishMeaning: 'The Opening',
        revelationType: 'Meccan',
        ayahCount: 7,
      );
      const medinan = Surah(
        number: 2,
        arabicName: 'البقرة',
        englishName: 'Al-Baqara',
        englishMeaning: 'The Cow',
        revelationType: 'Medinan',
        ayahCount: 286,
      );
      expect(meccan.isMeccan, isTrue);
      expect(medinan.isMeccan, isFalse);
    });
  });

  group('Ayah', () {
    test('bookmarkKey is stable surah:ayah', () {
      const a = Ayah(
        surahNumber: 36,
        numberInSurah: 9,
        arabic: 'foo',
        translation: 'bar',
      );
      expect(a.bookmarkKey, '36:9');
    });
  });
}
