import 'package:adhan/adhan.dart';

class PrayerSettings {
  final CalculationMethod method;
  final Madhab madhab;
  final double? manualLatitude;
  final double? manualLongitude;
  final String? manualLocationName;

  const PrayerSettings({
    required this.method,
    required this.madhab,
    this.manualLatitude,
    this.manualLongitude,
    this.manualLocationName,
  });

  static const PrayerSettings defaults = PrayerSettings(
    method: CalculationMethod.muslim_world_league,
    madhab: Madhab.shafi,
  );

  bool get hasManualLocation =>
      manualLatitude != null && manualLongitude != null;

  PrayerSettings copyWith({
    CalculationMethod? method,
    Madhab? madhab,
    double? manualLatitude,
    double? manualLongitude,
    String? manualLocationName,
    bool clearManualLocation = false,
  }) {
    if (clearManualLocation) {
      return PrayerSettings(
        method: method ?? this.method,
        madhab: madhab ?? this.madhab,
      );
    }
    return PrayerSettings(
      method: method ?? this.method,
      madhab: madhab ?? this.madhab,
      manualLatitude: manualLatitude ?? this.manualLatitude,
      manualLongitude: manualLongitude ?? this.manualLongitude,
      manualLocationName: manualLocationName ?? this.manualLocationName,
    );
  }
}

extension CalculationMethodLabel on CalculationMethod {
  String get displayName {
    switch (this) {
      case CalculationMethod.muslim_world_league:
        return 'Muslim World League';
      case CalculationMethod.egyptian:
        return 'Egyptian General Authority';
      case CalculationMethod.karachi:
        return 'University of Karachi';
      case CalculationMethod.umm_al_qura:
        return 'Umm al-Qura, Makkah';
      case CalculationMethod.dubai:
        return 'Dubai';
      case CalculationMethod.moon_sighting_committee:
        return 'Moon Sighting Committee';
      case CalculationMethod.north_america:
        return 'North America (ISNA)';
      case CalculationMethod.kuwait:
        return 'Kuwait';
      case CalculationMethod.qatar:
        return 'Qatar';
      case CalculationMethod.singapore:
        return 'Singapore';
      case CalculationMethod.turkey:
        return 'Turkey (Diyanet)';
      case CalculationMethod.tehran:
        return 'Tehran';
      case CalculationMethod.other:
        return 'Custom';
    }
  }
}

extension MadhabLabel on Madhab {
  String get displayName {
    switch (this) {
      case Madhab.shafi:
        return 'Shafiʿi / Maliki / Hanbali';
      case Madhab.hanafi:
        return 'Hanafi';
    }
  }
}

extension PrayerLabel on Prayer {
  String get englishLabel {
    switch (this) {
      case Prayer.fajr:
        return 'Fajr';
      case Prayer.sunrise:
        return 'Sunrise';
      case Prayer.dhuhr:
        return 'Dhuhr';
      case Prayer.asr:
        return 'Asr';
      case Prayer.maghrib:
        return 'Maghrib';
      case Prayer.isha:
        return 'Isha';
      case Prayer.none:
        return '—';
    }
  }

  String get arabicLabel {
    switch (this) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      case Prayer.none:
        return '';
    }
  }
}
