import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_companion/features/islamic_kb/data/repositories/islamic_kb_repository.dart';
import 'package:my_companion/features/islamic_kb/domain/entities/islamic_qa_data.dart';
import 'package:my_companion/features/islamic_kb/domain/entities/islamic_question.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('IslamicQaData', () {
    test('contains exactly 30 entries', () {
      expect(IslamicQaData.all.length, 30);
    });

    test('every entry has non-empty content + a source', () {
      for (final q in IslamicQaData.all) {
        expect(q.id.startsWith('kb_'), isTrue, reason: q.id);
        expect(q.questionEn.trim().isNotEmpty, isTrue, reason: q.id);
        expect(q.questionAr.trim().isNotEmpty, isTrue, reason: q.id);
        expect(q.answerEn.trim().length, greaterThan(50), reason: q.id);
        expect(q.source.trim().isNotEmpty, isTrue, reason: q.id);
      }
    });

    test('every category has at least one entry', () {
      for (final c in KbCategory.values) {
        expect(
          IslamicQaData.forCategory(c).isNotEmpty,
          isTrue,
          reason: c.toString(),
        );
      }
    });

    test('byId resolves a known entry', () {
      expect(IslamicQaData.byId('kb_001'), isNotNull);
      expect(IslamicQaData.byId('kb_030'), isNotNull);
      expect(IslamicQaData.byId('kb_xyz'), isNull);
    });
  });

  group('IslamicKbRepository', () {
    late IslamicKbRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repo = IslamicKbRepository(prefs);
    });

    test('search "wudu" returns entries about wudu', () {
      final results = repo.search('wudu');
      expect(results.isNotEmpty, isTrue);
      expect(results.any((q) => q.id == 'kb_001'), isTrue);
    });

    test('search "fasting" finds entries in the Fasting category', () {
      final results = repo.search('fasting');
      expect(results.isNotEmpty, isTrue);
      expect(results.any((q) => q.category == KbCategory.fasting), isTrue);
    });

    test('search Arabic phrase finds matching entry', () {
      final results = repo.search('الزكاة');
      expect(results.isNotEmpty, isTrue);
    });

    test('history is empty initially', () {
      expect(repo.historyIds(), isEmpty);
    });

    test('recordView pushes to front and de-duplicates', () async {
      await repo.recordView('kb_001');
      await repo.recordView('kb_002');
      await repo.recordView('kb_001');
      expect(repo.historyIds(), <String>['kb_001', 'kb_002']);
    });

    test('clearHistory empties the list', () async {
      await repo.recordView('kb_005');
      expect(repo.historyIds(), isNotEmpty);
      await repo.clearHistory();
      expect(repo.historyIds(), isEmpty);
    });

    test(
      'recent() returns full IslamicQuestion objects newest first',
      () async {
        await repo.recordView('kb_010');
        await repo.recordView('kb_017');
        final recent = repo.recent();
        expect(recent.length, 2);
        expect(recent.first.id, 'kb_017');
        expect(recent.last.id, 'kb_010');
      },
    );
  });
}
