import 'package:flutter_test/flutter_test.dart';

import 'package:my_companion/features/quran_radio/domain/entities/reciter.dart';

void main() {
  group('Reciter URL builder', () {
    test('zero-pads surah number to 3 digits', () {
      final r = Reciter.yaserAlDosari;
      expect(r.urlFor(1), 'https://server11.mp3quran.net/yasser/001.mp3');
      expect(r.urlFor(36), 'https://server11.mp3quran.net/yasser/036.mp3');
      expect(r.urlFor(114), 'https://server11.mp3quran.net/yasser/114.mp3');
    });

    test('reciter metadata is populated', () {
      final r = Reciter.yaserAlDosari;
      expect(r.id, 'yaser_aldosari');
      expect(r.englishName.isNotEmpty, isTrue);
      expect(r.arabicName.isNotEmpty, isTrue);
      expect(r.urlPattern.contains('{surah}'), isTrue);
    });
  });
}
