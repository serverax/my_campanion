import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../data/repositories/adhkar_repository.dart';
import '../../domain/entities/dhikr.dart';

class AdhkarController extends GetxController {
  AdhkarController(this._repo);
  final AdhkarRepository _repo;

  /// Map of dhikrId → reactive current count.
  final RxMap<String, int> counts = <String, int>{}.obs;

  void hydrateFor(List<Dhikr> dhikrs) {
    for (final d in dhikrs) {
      counts[d.id] = _repo.getCount(d.id);
    }
  }

  Future<void> tap(Dhikr d) async {
    final wasComplete = (counts[d.id] ?? 0) >= d.count;
    if (wasComplete) return;
    final next = await _repo.increment(d);
    counts[d.id] = next;
    if (next >= d.count) {
      // Stronger feedback when a target is reached.
      await HapticFeedback.heavyImpact();
    } else {
      await HapticFeedback.selectionClick();
    }
  }

  Future<void> resetOne(Dhikr d) async {
    await _repo.reset(d.id);
    counts[d.id] = 0;
  }

  Future<void> resetCategory(DhikrCategory category, List<Dhikr> dhikrs) async {
    await _repo.resetCategory(category);
    for (final d in dhikrs) {
      counts[d.id] = 0;
    }
  }

  bool isComplete(Dhikr d) => (counts[d.id] ?? 0) >= d.count;
}
