import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/adhkar_data.dart';
import '../../domain/entities/dhikr.dart';

class AdhkarRepository {
  AdhkarRepository(this._prefs);
  final SharedPreferences _prefs;

  static const String _kCountPrefix = 'adhkar.count.';
  static const String _kDateKey = 'adhkar.last_seen_date';

  /// Returns the count for `dhikrId` for *today*. If the stored data is from
  /// a previous local-day, the per-dhikr counters are reset to zero.
  int getCount(String dhikrId) {
    _resetIfNewDay();
    return _prefs.getInt('$_kCountPrefix$dhikrId') ?? 0;
  }

  /// Increments the count for the given dhikr by 1, capped at the dhikr's
  /// target count. Returns the new count.
  Future<int> increment(Dhikr dhikr) async {
    _resetIfNewDay();
    final current = _prefs.getInt('$_kCountPrefix${dhikr.id}') ?? 0;
    final next = current >= dhikr.count ? dhikr.count : current + 1;
    await _prefs.setInt('$_kCountPrefix${dhikr.id}', next);
    return next;
  }

  Future<void> reset(String dhikrId) async {
    await _prefs.setInt('$_kCountPrefix$dhikrId', 0);
  }

  /// Reset all dhikrs in a category back to zero (manual user action).
  Future<void> resetCategory(DhikrCategory category) async {
    for (final d in AdhkarData.forCategory(category)) {
      await reset(d.id);
    }
  }

  void _resetIfNewDay() {
    final today = _todayKey();
    final stored = _prefs.getString(_kDateKey);
    if (stored != today) {
      // Wipe all per-dhikr counter keys.
      final keysToClear = _prefs
          .getKeys()
          .where((k) => k.startsWith(_kCountPrefix))
          .toList();
      for (final k in keysToClear) {
        _prefs.remove(k);
      }
      _prefs.setString(_kDateKey, today);
    }
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }
}
