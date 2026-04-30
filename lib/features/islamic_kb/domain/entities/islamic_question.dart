enum KbCategory { prayer, fasting, zakat, hajj, calendar, daily, everyday }

extension KbCategoryLabel on KbCategory {
  String get englishName {
    switch (this) {
      case KbCategory.prayer:
        return 'Prayer (Salah)';
      case KbCategory.fasting:
        return 'Fasting (Sawm)';
      case KbCategory.zakat:
        return 'Zakat';
      case KbCategory.hajj:
        return 'Hajj';
      case KbCategory.calendar:
        return 'Calendar & Times';
      case KbCategory.daily:
        return 'Daily Practices';
      case KbCategory.everyday:
        return 'Everyday Life';
    }
  }

  String get arabicName {
    switch (this) {
      case KbCategory.prayer:
        return 'الصلاة';
      case KbCategory.fasting:
        return 'الصيام';
      case KbCategory.zakat:
        return 'الزكاة';
      case KbCategory.hajj:
        return 'الحج';
      case KbCategory.calendar:
        return 'التقويم والمواقيت';
      case KbCategory.daily:
        return 'العبادات اليومية';
      case KbCategory.everyday:
        return 'الحياة اليومية';
    }
  }
}

class IslamicQuestion {
  final String id;
  final KbCategory category;
  final String questionEn;
  final String questionAr;
  final String answerEn;
  final String source;

  /// Optional note covering scholarly differences between madhahib so the
  /// reader knows mainstream answers may vary in detail.
  final String? scholarlyNote;

  const IslamicQuestion({
    required this.id,
    required this.category,
    required this.questionEn,
    required this.questionAr,
    required this.answerEn,
    required this.source,
    this.scholarlyNote,
  });
}
