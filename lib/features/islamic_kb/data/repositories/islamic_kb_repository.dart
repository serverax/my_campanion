import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/islamic_qa_data.dart';
import '../../domain/entities/islamic_question.dart';

class IslamicKbRepository {
  IslamicKbRepository(this._prefs);
  final SharedPreferences _prefs;

  static const String _kHistoryKey = 'islamic_kb.history.v1';
  static const int _historyMax = 30;

  List<IslamicQuestion> all() => IslamicQaData.all;

  List<IslamicQuestion> forCategory(KbCategory c) =>
      IslamicQaData.forCategory(c);

  IslamicQuestion? byId(String id) => IslamicQaData.byId(id);

  /// Plain substring search across English question + answer (case-insensitive).
  /// Limited to 100 results.
  List<IslamicQuestion> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const <IslamicQuestion>[];
    final hits = <IslamicQuestion>[];
    for (final entry in IslamicQaData.all) {
      if (entry.questionEn.toLowerCase().contains(q) ||
          entry.answerEn.toLowerCase().contains(q) ||
          entry.questionAr.contains(query.trim())) {
        hits.add(entry);
        if (hits.length >= 100) break;
      }
    }
    return hits;
  }

  // History --------------------------------------------------------------

  /// Returns the IDs of recently-viewed entries, newest first.
  List<String> historyIds() => _prefs.getStringList(_kHistoryKey) ?? <String>[];

  Future<void> recordView(String id) async {
    final list = List<String>.of(historyIds());
    list.remove(id); // de-duplicate
    list.insert(0, id);
    if (list.length > _historyMax) {
      list.removeRange(_historyMax, list.length);
    }
    await _prefs.setStringList(_kHistoryKey, list);
  }

  Future<void> clearHistory() => _prefs.remove(_kHistoryKey).then((_) {});

  List<IslamicQuestion> recent() {
    final ids = historyIds();
    final out = <IslamicQuestion>[];
    for (final id in ids) {
      final q = byId(id);
      if (q != null) out.add(q);
    }
    return out;
  }
}
