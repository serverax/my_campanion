import 'package:hijri/hijri_calendar.dart';

import '../../domain/entities/islamic_event.dart';
import '../../domain/entities/islamic_events_data.dart';

class CalendarRepository {
  HijriCalendar todayHijri() => HijriCalendar.now();

  HijriCalendar fromGregorian(DateTime date) => HijriCalendar.fromDate(date);

  DateTime hijriToGregorian(int hYear, int hMonth, int hDay) =>
      HijriCalendar().hijriToGregorian(hYear, hMonth, hDay);

  int daysInHijriMonth(int hYear, int hMonth) =>
      HijriCalendar().getDaysInMonth(hYear, hMonth);

  DateTime firstDayOfHijriMonth(int hYear, int hMonth) =>
      hijriToGregorian(hYear, hMonth, 1);

  List<IslamicEvent> eventsForMonth(int hMonth) =>
      IslamicEventsData.forMonth(hMonth);

  IslamicEvent? eventForDay(int hMonth, int hDay) =>
      IslamicEventsData.forDay(hMonth, hDay);
}
