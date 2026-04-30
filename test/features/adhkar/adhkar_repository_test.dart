import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_companion/features/adhkar/data/repositories/adhkar_repository.dart';
import 'package:my_companion/features/adhkar/domain/entities/adhkar_data.dart';
import 'package:my_companion/features/adhkar/domain/entities/dhikr.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdhkarRepository', () {
    late AdhkarRepository repo;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      repo = AdhkarRepository(prefs);
    });

    test('count starts at zero', () {
      final morning = AdhkarData.forCategory(DhikrCategory.morning).first;
      expect(repo.getCount(morning.id), 0);
    });

    test(
      'increment advances by one until target is hit and then caps',
      () async {
        const test = Dhikr(
          id: 'test_target_3',
          category: DhikrCategory.general,
          arabic: 'X',
          translation: 'X',
          source: 'test',
          count: 3,
        );

        expect(await repo.increment(test), 1);
        expect(await repo.increment(test), 2);
        expect(await repo.increment(test), 3);
        // Cap holds — further increments stay at 3
        expect(await repo.increment(test), 3);
        expect(await repo.increment(test), 3);

        expect(repo.getCount(test.id), 3);
      },
    );

    test('reset returns count to zero', () async {
      const test = Dhikr(
        id: 'test_reset',
        category: DhikrCategory.general,
        arabic: 'X',
        translation: 'X',
        source: 'test',
        count: 5,
      );
      await repo.increment(test);
      await repo.increment(test);
      expect(repo.getCount(test.id), 2);
      await repo.reset(test.id);
      expect(repo.getCount(test.id), 0);
    });

    test('resetCategory clears every dhikr in that category', () async {
      final morning = AdhkarData.forCategory(DhikrCategory.morning);
      // Bump the first two morning dhikrs
      await repo.increment(morning[0]);
      await repo.increment(morning[1]);
      expect(repo.getCount(morning[0].id), 1);
      expect(repo.getCount(morning[1].id), 1);

      await repo.resetCategory(DhikrCategory.morning);

      for (final d in morning) {
        expect(repo.getCount(d.id), 0);
      }
    });

    test('AdhkarData.forCategory returns expected counts per category', () {
      expect(
        AdhkarData.forCategory(DhikrCategory.morning).length,
        greaterThanOrEqualTo(5),
      );
      expect(
        AdhkarData.forCategory(DhikrCategory.evening).length,
        greaterThanOrEqualTo(5),
      );
      expect(
        AdhkarData.forCategory(DhikrCategory.afterPrayer).length,
        greaterThanOrEqualTo(6),
      );
      expect(
        AdhkarData.forCategory(DhikrCategory.general).length,
        greaterThanOrEqualTo(3),
      );
    });

    test('every Dhikr has a non-empty Arabic + translation + source', () {
      for (final d in AdhkarData.all) {
        expect(d.arabic.trim().isNotEmpty, isTrue, reason: d.id);
        expect(d.translation.trim().isNotEmpty, isTrue, reason: d.id);
        expect(d.source.trim().isNotEmpty, isTrue, reason: d.id);
        expect(d.count, greaterThanOrEqualTo(1), reason: d.id);
      }
    });
  });
}
