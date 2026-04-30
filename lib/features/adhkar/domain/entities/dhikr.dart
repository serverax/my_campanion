enum DhikrCategory { morning, evening, afterPrayer, general }

extension DhikrCategoryLabel on DhikrCategory {
  String get englishName {
    switch (this) {
      case DhikrCategory.morning:
        return 'Morning';
      case DhikrCategory.evening:
        return 'Evening';
      case DhikrCategory.afterPrayer:
        return 'After Prayer';
      case DhikrCategory.general:
        return 'Tasbih';
    }
  }

  String get arabicName {
    switch (this) {
      case DhikrCategory.morning:
        return 'أذكار الصباح';
      case DhikrCategory.evening:
        return 'أذكار المساء';
      case DhikrCategory.afterPrayer:
        return 'أذكار بعد الصلاة';
      case DhikrCategory.general:
        return 'تسبيح';
    }
  }

  String get description {
    switch (this) {
      case DhikrCategory.morning:
        return 'Recited from Fajr until sunrise (or before noon).';
      case DhikrCategory.evening:
        return 'Recited from Asr until Maghrib (or after).';
      case DhikrCategory.afterPrayer:
        return 'Recited after each of the five obligatory prayers.';
      case DhikrCategory.general:
        return 'Glorification recited at any time.';
    }
  }
}

class Dhikr {
  final String id;
  final DhikrCategory category;
  final String arabic;
  final String? transliteration;
  final String translation;
  final String source;
  final int count;

  const Dhikr({
    required this.id,
    required this.category,
    required this.arabic,
    this.transliteration,
    required this.translation,
    required this.source,
    this.count = 1,
  });
}
