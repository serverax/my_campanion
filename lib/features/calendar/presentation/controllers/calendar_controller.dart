import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';

import '../../data/repositories/calendar_repository.dart';
import '../../domain/entities/islamic_event.dart';
import '../../domain/entities/islamic_events_data.dart';

class CalendarController extends GetxController {
  CalendarController(this._repo);
  final CalendarRepository _repo;

  final RxInt hYear = 0.obs;
  final RxInt hMonth = 0.obs;

  late final HijriCalendar _today;

  @override
  void onInit() {
    super.onInit();
    _today = _repo.todayHijri();
    hYear.value = _today.hYear;
    hMonth.value = _today.hMonth;
  }

  HijriCalendar get today => _today;

  int get daysInCurrentMonth =>
      _repo.daysInHijriMonth(hYear.value, hMonth.value);

  DateTime get firstDayGregorian =>
      _repo.firstDayOfHijriMonth(hYear.value, hMonth.value);

  String get monthNameEn => hijriMonthsEnglish[hMonth.value];
  String get monthNameAr => hijriMonthsArabic[hMonth.value];

  List<IslamicEvent> get eventsThisMonth => _repo.eventsForMonth(hMonth.value);

  IslamicEvent? eventForDay(int day) => _repo.eventForDay(hMonth.value, day);

  DateTime gregorianForDay(int hijriDay) =>
      _repo.hijriToGregorian(hYear.value, hMonth.value, hijriDay);

  bool isToday(int hijriDay) =>
      hYear.value == _today.hYear &&
      hMonth.value == _today.hMonth &&
      hijriDay == _today.hDay;

  void nextMonth() {
    if (hMonth.value == 12) {
      hMonth.value = 1;
      hYear.value += 1;
    } else {
      hMonth.value += 1;
    }
  }

  void prevMonth() {
    if (hMonth.value == 1) {
      hMonth.value = 12;
      hYear.value -= 1;
    } else {
      hMonth.value -= 1;
    }
  }

  void goToToday() {
    hYear.value = _today.hYear;
    hMonth.value = _today.hMonth;
  }
}
