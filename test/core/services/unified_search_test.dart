import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_companion/core/services/unified_search_service.dart';
import 'package:my_companion/features/adhkar/data/repositories/adhkar_repository.dart';
import 'package:my_companion/features/islamic_kb/data/repositories/islamic_kb_repository.dart';
import 'package:my_companion/features/quran/data/datasources/quran_local_data_source.dart';
import 'package:my_companion/features/quran/data/repositories/quran_repository.dart';
import 'package:my_companion/features/quran/domain/entities/ayah.dart';
import 'package:my_companion/features/quran/domain/entities/surah.dart';

/// In-test data source that doesn't touch the asset bundle.
class _StubQuranDataSource extends QuranLocalDataSource {
  @override
  Future<List<Surah>> loadSurahList() async => const <Surah>[];
}

/// Wraps the real QuranRepository but stubs out search to avoid hitting
/// the asset bundle. We can still exercise the aggregation logic.
class _StubQuranRepository extends QuranRepository {
  _StubQuranRepository(super.source, super.prefs);

  @override
  Future<List<AyahSearchResult>> search(String query) async =>
      const <AyahSearchResult>[];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdhkarRepository.search (added in this commit)', () {
    late AdhkarRepository repo;
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      repo = AdhkarRepository(await SharedPreferences.getInstance());
    });

    test('returns Subhanallah-style entries for "Glory"', () {
      // Note: the bundled transliterations use diacritics ("Subḥān-Allāh")
      // so a Latin "Subhanallah" query won't match. Real users either
      // search the English meaning ("Glory") or the actual Arabic text.
      final hits = repo.search('Glory');
      expect(hits.isNotEmpty, isTrue);
      expect(
        hits.any((d) => d.translation.toLowerCase().contains('glory')),
        isTrue,
      );
    });

    test('matches Arabic text directly', () {
      final hits = repo.search('سُبْحَانَ');
      expect(hits.isNotEmpty, isTrue);
    });

    test('empty query returns empty list', () {
      expect(repo.search(''), isEmpty);
      expect(repo.search('   '), isEmpty);
    });
  });

  group('UnifiedSearchService', () {
    late UnifiedSearchService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final kb = IslamicKbRepository(prefs);
      final adhkar = AdhkarRepository(prefs);
      // Use a stub Quran repo — hitting the asset bundle in widgetless
      // tests is awkward and slows things down for no real coverage.
      final quran = _StubQuranRepository(_StubQuranDataSource(), prefs);
      service = UnifiedSearchService(kb: kb, quran: quran, adhkar: adhkar);
    });

    test('queries shorter than 2 chars short-circuit', () async {
      expect(await service.search(''), isEmpty);
      expect(await service.search('a'), isEmpty);
    });

    test('finds wudu Q&A and tags it as KB', () async {
      final hits = await service.search('wudu');
      expect(hits.isNotEmpty, isTrue);
      expect(hits.any((h) => h.source == SearchSource.kb), isTrue);
      final kbHit = hits.firstWhere((h) => h.source == SearchSource.kb);
      expect(kbHit.sourceLabel, 'Knowledge');
      expect(kbHit.title.toLowerCase().contains('wudu'), isTrue);
      expect(kbHit.sourceCitation, isNotNull);
    });

    test('finds dhikr entries by English meaning and tags as Adhkar',
        () async {
      // Diacritic-stripped Latin like "subhanallah" doesn't match the
      // bundled transliteration "Subḥān-Allāh" — search the English
      // translation instead.
      final hits = await service.search('Glory');
      expect(hits.any((h) => h.source == SearchSource.adhkar), isTrue);
      final ad = hits.firstWhere((h) => h.source == SearchSource.adhkar);
      expect(ad.sourceLabel, 'Adhkar');
      expect(ad.arabic, isNotNull);
    });

    test('caps results per source at 5', () async {
      final hits = await service.search('Allah');
      // KB and Adhkar can both contribute; neither should exceed 5
      final kbCount = hits.where((h) => h.source == SearchSource.kb).length;
      final adhkarCount = hits
          .where((h) => h.source == SearchSource.adhkar)
          .length;
      expect(kbCount, lessThanOrEqualTo(5));
      expect(adhkarCount, lessThanOrEqualTo(5));
    });
  });
}
