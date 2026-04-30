import 'dart:async';

import 'package:get/get.dart';

import '../../data/repositories/islamic_kb_repository.dart';
import '../../domain/entities/islamic_question.dart';

class IslamicKbController extends GetxController {
  IslamicKbController(this._repo);
  final IslamicKbRepository _repo;

  final RxString query = ''.obs;
  final RxList<IslamicQuestion> results = <IslamicQuestion>[].obs;
  final RxList<IslamicQuestion> recent = <IslamicQuestion>[].obs;
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    _loadRecent();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  void _loadRecent() {
    recent.value = _repo.recent();
  }

  void onSearchChanged(String q) {
    query.value = q;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      results.value = q.trim().length < 2
          ? const <IslamicQuestion>[]
          : _repo.search(q);
    });
  }

  List<IslamicQuestion> forCategory(KbCategory c) => _repo.forCategory(c);

  Future<void> recordView(IslamicQuestion q) async {
    await _repo.recordView(q.id);
    _loadRecent();
  }

  Future<void> clearHistory() async {
    await _repo.clearHistory();
    _loadRecent();
  }
}
