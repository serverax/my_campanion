import '../../features/adhkar/data/repositories/adhkar_repository.dart';
import '../../features/adhkar/domain/entities/adhkar_data.dart';
import '../../features/adhkar/domain/entities/dhikr.dart';
import '../../features/islamic_kb/data/repositories/islamic_kb_repository.dart';
import '../../features/islamic_kb/domain/entities/islamic_question.dart';
import '../../features/quran/data/repositories/quran_repository.dart';
import '../../features/quran/domain/entities/ayah.dart';

enum SearchSource { kb, adhkar, quran }

class SearchHit {
  final SearchSource source;
  final String id;
  final String title;
  final String? arabic;
  final String snippet;
  final String? sourceCitation;

  /// Carries the original entity so the page can navigate to the right
  /// detail view without doing another lookup.
  final Object payload;

  const SearchHit({
    required this.source,
    required this.id,
    required this.title,
    required this.snippet,
    required this.payload,
    this.arabic,
    this.sourceCitation,
  });

  String get sourceLabel {
    switch (source) {
      case SearchSource.kb:
        return 'Knowledge';
      case SearchSource.adhkar:
        return 'Adhkar';
      case SearchSource.quran:
        return 'Quran';
    }
  }
}

/// In-memory aggregate search across the three text corpora the app already
/// bundles: the Islamic Knowledge Pool (30 Q&A), the Adhkar collection
/// (19 dhikrs), and the full Quran (6,236 ayahs, English + Arabic).
///
/// Linear case-insensitive substring scan — sub-50 ms on the corpus we
/// have. Replace with FTS5 only if the corpus grows past ~50k items.
class UnifiedSearchService {
  UnifiedSearchService({
    required IslamicKbRepository kb,
    required QuranRepository quran,
    required AdhkarRepository adhkar,
  }) : _kb = kb,
       _quran = quran,
       _adhkar = adhkar;

  final IslamicKbRepository _kb;
  final QuranRepository _quran;
  // ignore: unused_field — held for parity / future per-instance state
  final AdhkarRepository _adhkar;

  static const int _capPerSource = 5;

  Future<List<SearchHit>> search(String query) async {
    final q = query.trim();
    if (q.length < 2) return const <SearchHit>[];
    final out = <SearchHit>[];

    // KB first — most likely to contain a direct answer to a user question
    final kbHits = _kb.search(q).take(_capPerSource);
    for (final e in kbHits) {
      out.add(_kbHit(e));
    }

    // Adhkar
    for (final d in _searchAdhkar(q).take(_capPerSource)) {
      out.add(_adhkarHit(d));
    }

    // Quran — largest corpus, run last so it doesn't drown smaller sources
    final quranHits = await _quran.search(q);
    for (final r in quranHits.take(_capPerSource)) {
      out.add(_quranHit(r));
    }

    return out;
  }

  Iterable<Dhikr> _searchAdhkar(String query) {
    final ql = query.toLowerCase();
    return AdhkarData.all.where((d) {
      if (d.translation.toLowerCase().contains(ql)) return true;
      final tr = d.transliteration;
      if (tr != null && tr.toLowerCase().contains(ql)) return true;
      if (d.arabic.contains(query)) return true;
      if (d.source.toLowerCase().contains(ql)) return true;
      return false;
    });
  }

  SearchHit _kbHit(IslamicQuestion e) => SearchHit(
    source: SearchSource.kb,
    id: e.id,
    title: e.questionEn,
    arabic: e.questionAr,
    snippet: e.answerEn,
    sourceCitation: e.source,
    payload: e,
  );

  SearchHit _adhkarHit(Dhikr d) => SearchHit(
    source: SearchSource.adhkar,
    id: d.id,
    title: d.translation,
    arabic: d.arabic,
    snippet: '${d.category.englishName} — recite ${d.count}×',
    sourceCitation: d.source,
    payload: d,
  );

  SearchHit _quranHit(AyahSearchResult r) => SearchHit(
    source: SearchSource.quran,
    id: '${r.ayah.surahNumber}:${r.ayah.numberInSurah}',
    title: '${r.surahName} (${r.ayah.surahNumber}:${r.ayah.numberInSurah})',
    arabic: r.ayah.arabic,
    snippet: r.ayah.translation,
    sourceCitation: 'Quran-Uthmani · Sahih International',
    payload: r.ayah,
  );
}
