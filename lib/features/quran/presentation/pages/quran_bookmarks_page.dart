import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../data/repositories/quran_repository.dart';
import '../../domain/entities/ayah.dart';
import 'surah_reader_page.dart';

class QuranBookmarksPage extends StatefulWidget {
  const QuranBookmarksPage({super.key});

  @override
  State<QuranBookmarksPage> createState() => _QuranBookmarksPageState();
}

class _QuranBookmarksPageState extends State<QuranBookmarksPage> {
  late Future<List<Ayah>> _future;

  @override
  void initState() {
    super.initState();
    _future = Get.find<QuranRepository>().bookmarkedAyahs();
  }

  Future<void> _refresh() async {
    final repo = Get.find<QuranRepository>();
    final list = await repo.bookmarkedAyahs();
    setState(() => _future = Future<List<Ayah>>.value(list));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: SafeArea(
        child: FutureBuilder<List<Ayah>>(
          future: _future,
          builder: (_, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final ayahs = snap.data!;
            if (ayahs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Text(
                    'No bookmarks yet. Tap the bookmark icon '
                    'on any ayah while reading.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall(),
                  ),
                ),
              );
            }
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxContentWidth,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  itemCount: ayahs.length,
                  itemBuilder: (_, i) {
                    final a = ayahs[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSizes.sm),
                      decoration: BoxDecoration(
                        color: AppColors.bgWhite,
                        border: Border.all(color: AppColors.divider),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusCards,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Get.to<void>(
                            () => SurahReaderPage(surahNumber: a.surahNumber),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.bookmark,
                                      color: AppColors.accentGold,
                                      size: AppSizes.iconSm,
                                    ),
                                    const SizedBox(width: AppSizes.xs),
                                    Text(
                                      '${a.surahNumber}:${a.numberInSurah}',
                                      style: AppTextStyles.caption().copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      tooltip: 'Remove',
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () async {
                                        await Get.find<QuranRepository>()
                                            .toggleBookmark(a);
                                        await _refresh();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSizes.xs),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    a.arabic,
                                    style: AppTextStyles.quranArabic().copyWith(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSizes.xs),
                                Text(
                                  a.translation,
                                  style: AppTextStyles.bodySmall(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
