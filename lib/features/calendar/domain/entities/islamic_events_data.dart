import 'islamic_event.dart';

const List<String> hijriMonthsEnglish = <String>[
  '',
  'Muharram',
  'Safar',
  "Rabi' al-Awwal",
  "Rabi' ath-Thani",
  'Jumada al-Awwal',
  'Jumada ath-Thaniyah',
  'Rajab',
  "Sha'ban",
  'Ramadan',
  'Shawwal',
  "Dhu al-Qa'dah",
  'Dhu al-Hijjah',
];

const List<String> hijriMonthsArabic = <String>[
  '',
  'محرم',
  'صفر',
  'ربيع الأول',
  'ربيع الآخر',
  'جمادى الأولى',
  'جمادى الآخرة',
  'رجب',
  'شعبان',
  'رمضان',
  'شوال',
  'ذو القعدة',
  'ذو الحجة',
];

class IslamicEventsData {
  IslamicEventsData._();

  static const List<IslamicEvent> events = <IslamicEvent>[
    IslamicEvent(
      id: 'hijri_new_year',
      name: 'Hijri New Year',
      nameAr: 'رأس السنة الهجرية',
      hijriMonth: 1,
      hijriDay: 1,
      isMajor: true,
    ),
    IslamicEvent(
      id: 'ashura',
      name: 'Day of Ashura',
      nameAr: 'يوم عاشوراء',
      hijriMonth: 1,
      hijriDay: 10,
      isMajor: true,
      notes: 'Recommended fast on the 9th and 10th of Muharram.',
    ),
    IslamicEvent(
      id: 'mawlid',
      name: "Mawlid an-Nabi (Prophet's Birthday)",
      nameAr: 'المولد النبوي',
      hijriMonth: 3,
      hijriDay: 12,
      notes: 'Observance varies by madhab and is not universally recognised.',
    ),
    IslamicEvent(
      id: 'isra_miraj',
      name: 'Isra wa al-Miʿraj',
      nameAr: 'الإسراء والمعراج',
      hijriMonth: 7,
      hijriDay: 27,
      notes:
          'The traditional date; the historical date is not unanimously authenticated.',
    ),
    IslamicEvent(
      id: 'mid_shaban',
      name: 'Mid-Shaʿban',
      nameAr: 'ليلة النصف من شعبان',
      hijriMonth: 8,
      hijriDay: 15,
      notes: 'Observance varies among scholars.',
    ),
    IslamicEvent(
      id: 'ramadan_start',
      name: 'Start of Ramadan',
      nameAr: 'بداية رمضان',
      hijriMonth: 9,
      hijriDay: 1,
      isMajor: true,
    ),
    IslamicEvent(
      id: 'laylat_alqadr',
      name: 'Laylat al-Qadr (most likely night)',
      nameAr: 'ليلة القدر',
      hijriMonth: 9,
      hijriDay: 27,
      isMajor: true,
      notes:
          'Most likely the 27th of Ramadan; sought across the last 10 odd nights.',
    ),
    IslamicEvent(
      id: 'eid_fitr',
      name: 'Eid al-Fitr',
      nameAr: 'عيد الفطر',
      hijriMonth: 10,
      hijriDay: 1,
      isMajor: true,
    ),
    IslamicEvent(
      id: 'arafah',
      name: 'Day of Arafah',
      nameAr: 'يوم عرفة',
      hijriMonth: 12,
      hijriDay: 9,
      isMajor: true,
      notes: 'Recommended fast for non-pilgrims; the greatest day of the year.',
    ),
    IslamicEvent(
      id: 'eid_adha',
      name: 'Eid al-Adha',
      nameAr: 'عيد الأضحى',
      hijriMonth: 12,
      hijriDay: 10,
      isMajor: true,
    ),
    IslamicEvent(
      id: 'tashreeq',
      name: 'Days of Tashreeq begin',
      nameAr: 'أيام التشريق',
      hijriMonth: 12,
      hijriDay: 11,
      notes:
          'Continue through 13 Dhu al-Hijjah; fasting is impermissible on these days.',
    ),
  ];

  static List<IslamicEvent> forMonth(int hijriMonth) =>
      events.where((e) => e.hijriMonth == hijriMonth).toList();

  static IslamicEvent? forDay(int hijriMonth, int hijriDay) {
    for (final e in events) {
      if (e.hijriMonth == hijriMonth && e.hijriDay == hijriDay) return e;
    }
    return null;
  }
}
