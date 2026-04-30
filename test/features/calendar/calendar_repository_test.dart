import 'package:flutter_test/flutter_test.dart';

import 'package:my_companion/features/calendar/data/repositories/calendar_repository.dart';
import 'package:my_companion/features/calendar/domain/entities/islamic_events_data.dart';

void main() {
  group('CalendarRepository', () {
    final repo = CalendarRepository();

    test('todayHijri returns a sane date', () {
      final today = repo.todayHijri();
      expect(today.hYear, greaterThan(1400));
      expect(today.hYear, lessThan(1600));
      expect(today.hMonth, inInclusiveRange(1, 12));
      expect(today.hDay, inInclusiveRange(1, 30));
    });

    test('hijriToGregorian round-trip is consistent', () {
      // Pick a known Hijri date — 1 Muharram 1447 AH
      final greg = repo.hijriToGregorian(1447, 1, 1);
      // Reconstructing from this Gregorian date should match
      final back = repo.fromGregorian(greg);
      expect(back.hYear, 1447);
      expect(back.hMonth, 1);
      expect(back.hDay, 1);
    });

    test('daysInHijriMonth is between 29 and 30', () {
      for (var m = 1; m <= 12; m++) {
        final days = repo.daysInHijriMonth(1447, m);
        expect(
          days,
          inInclusiveRange(29, 30),
          reason: 'month $m of 1447 has $days days',
        );
      }
    });

    test('eventsForMonth(1) returns Hijri new year and Ashura', () {
      final events = repo.eventsForMonth(1);
      expect(events.length, 2);
      expect(events.any((e) => e.id == 'hijri_new_year'), isTrue);
      expect(events.any((e) => e.id == 'ashura'), isTrue);
    });

    test('eventForDay returns Eid al-Fitr on 1 Shawwal', () {
      final event = repo.eventForDay(10, 1);
      expect(event, isNotNull);
      expect(event!.id, 'eid_fitr');
      expect(event.isMajor, isTrue);
    });

    test('eventForDay returns null for ordinary days', () {
      expect(repo.eventForDay(2, 5), isNull);
    });

    test('hijri month names cover all 12 months', () {
      expect(hijriMonthsEnglish.length, 13); // index 0 unused + 12 months
      expect(hijriMonthsArabic.length, 13);
      for (var m = 1; m <= 12; m++) {
        expect(hijriMonthsEnglish[m].isNotEmpty, isTrue);
        expect(hijriMonthsArabic[m].isNotEmpty, isTrue);
      }
    });
  });
}
