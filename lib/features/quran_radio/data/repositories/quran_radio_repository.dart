import 'package:shared_preferences/shared_preferences.dart';

import '../../../quran/data/repositories/quran_repository.dart';
import '../../../quran/domain/entities/surah.dart';
import '../../domain/entities/reciter.dart';

class QuranRadioRepository {
  QuranRadioRepository(this._quranRepo, this._prefs);
  final QuranRepository _quranRepo;
  final SharedPreferences _prefs;

  static const String _kLastSurahKey = 'quran_radio.last_surah';
  static const String _kLastPositionMsKey = 'quran_radio.last_position_ms';

  Reciter get reciter => Reciter.yaserAlDosari;

  Future<List<Surah>> surahs() => _quranRepo.surahs();

  String streamingUrlFor(int surahNumber) => reciter.urlFor(surahNumber);

  int? lastPlayedSurah() => _prefs.getInt(_kLastSurahKey);

  Duration? lastPlayedPosition() {
    final ms = _prefs.getInt(_kLastPositionMsKey);
    return ms == null ? null : Duration(milliseconds: ms);
  }

  Future<void> saveProgress(int surahNumber, Duration position) async {
    await _prefs.setInt(_kLastSurahKey, surahNumber);
    await _prefs.setInt(_kLastPositionMsKey, position.inMilliseconds);
  }
}
