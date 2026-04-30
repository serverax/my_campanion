import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/repositories/quran_repository.dart';
import '../../domain/entities/ayah.dart';
import 'surah_reader_page.dart';

class QuranSearchPage extends StatefulWidget {
  const QuranSearchPage({super.key});

  @override
  State<QuranSearchPage> createState() => _QuranSearchPageState();
}

class _QuranSearchPageState extends State<QuranSearchPage> {
  final TextEditingController _ctrl = TextEditingController();
  Timer? _debounce;
  bool _searching = false;
  List<AyahSearchResult> _results = const <AyahSearchResult>[];

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () => _run(q));
  }

  Future<void> _run(String q) async {
    if (q.trim().length < 2) {
      setState(() {
        _results = const <AyahSearchResult>[];
        _searching = false;
      });
      return;
    }
    setState(() => _searching = true);
    final repo = Get.find<QuranRepository>();
    final results = await repo.search(q);
    if (!mounted) return;
    setState(() {
      _results = results;
      _searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Quran')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  child: TextField(
                    controller: _ctrl,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText:
                          'Search English translation (min 2 characters)…',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: _onChanged,
                  ),
                ),
                if (_searching) const LinearProgressIndicator(),
                Expanded(
                  child: _results.isEmpty
                      ? Center(
                          child: Text(
                            _ctrl.text.trim().length < 2
                                ? 'Type at least 2 characters to search.'
                                : 'No matches.',
                            style: AppTextStyles.bodySmall(),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.lg,
                          ),
                          itemCount: _results.length,
                          itemBuilder: (_, i) =>
                              _SearchResultTile(result: _results[i]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.result});
  final AyahSearchResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.to<void>(
            () => SurahReaderPage(surahNumber: result.ayah.surahNumber),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(AppSizes.radiusChips),
                    ),
                    child: Text(
                      '${result.ayah.surahNumber}:${result.ayah.numberInSurah}',
                      style: AppTextStyles.caption().copyWith(
                        color: AppColors.bgWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Text(
                    result.surahName,
                    style: AppTextStyles.bodySmall().copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  result.ayah.arabic,
                  style: AppTextStyles.quranArabic().copyWith(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                result.ayah.translation,
                style: AppTextStyles.bodySmall(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
