import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/surah_reader_controller.dart';
import '../widgets/ayah_card.dart';

class SurahReaderPage extends StatefulWidget {
  const SurahReaderPage({super.key, required this.surahNumber});
  final int surahNumber;

  @override
  State<SurahReaderPage> createState() => _SurahReaderPageState();
}

class _SurahReaderPageState extends State<SurahReaderPage> {
  late final SurahReaderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<SurahReaderController>();
    _controller.open(widget.surahNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final s = _controller.currentSurah;
          if (s == null) return const Text('Quran');
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                s.englishName,
                style: AppTextStyles.h4().copyWith(color: AppColors.bgWhite),
              ),
              Text(
                s.arabicName,
                style: AppTextStyles.quranArabic().copyWith(
                  color: AppColors.accentGold,
                  fontSize: 18,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          );
        }),
      ),
      body: SafeArea(
        child: Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final ayahs = _controller.ayahs;
          if (ayahs.isEmpty) {
            return const Center(child: Text('No ayahs to display.'));
          }
          final s = _controller.currentSurah;
          return GestureDetector(
            // Swipe left → next surah, right → previous surah
            onHorizontalDragEnd: (d) {
              final v = d.primaryVelocity ?? 0;
              if (v < -200) _controller.next();
              if (v > 200) _controller.prev();
            },
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppSizes.maxContentWidth,
                ),
                child: ListView(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  children: <Widget>[
                    if (s != null)
                      _SurahHeader(
                        surahName: s.englishName,
                        arabicName: s.arabicName,
                        meaning: s.englishMeaning,
                        ayahCount: s.ayahCount,
                        revelation: s.revelationType,
                      ),
                    if (_controller.surahNumber.value != 1 &&
                        _controller.surahNumber.value != 9)
                      _Bismillah(),
                    const SizedBox(height: AppSizes.md),
                    ...ayahs.map(
                      (a) => AyahCard(
                        ayah: a,
                        bookmarked: _controller.isBookmarked(a),
                        onToggleBookmark: () => _controller.toggleBookmark(a),
                      ),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    _SurahNav(
                      hasPrev: _controller.hasPrev,
                      hasNext: _controller.hasNext,
                      onPrev: _controller.prev,
                      onNext: _controller.next,
                    ),
                    const SizedBox(height: AppSizes.xl),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({
    required this.surahName,
    required this.arabicName,
    required this.meaning,
    required this.ayahCount,
    required this.revelation,
  });
  final String surahName;
  final String arabicName;
  final String meaning;
  final int ayahCount;
  final String revelation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[AppColors.primaryDarkGreen, AppColors.primaryGreen],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusModals),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  surahName,
                  style: AppTextStyles.h2().copyWith(color: AppColors.bgWhite),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  meaning,
                  style: AppTextStyles.bodySmall().copyWith(
                    color: AppColors.bgOffWhite,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  '${revelation.toLowerCase()} • $ayahCount ayahs',
                  style: AppTextStyles.caption().copyWith(
                    color: AppColors.bgOffWhite,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.md),
          Text(
            arabicName,
            style: AppTextStyles.quranArabic().copyWith(
              color: AppColors.accentGold,
              fontSize: 28,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}

class _Bismillah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
      child: Center(
        child: Text(
          'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ',
          style: AppTextStyles.quranArabic().copyWith(fontSize: 24),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}

class _SurahNav extends StatelessWidget {
  const _SurahNav({
    required this.hasPrev,
    required this.hasNext,
    required this.onPrev,
    required this.onNext,
  });
  final bool hasPrev;
  final bool hasNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.chevron_left),
            label: const Text('Previous surah'),
            onPressed: hasPrev ? onPrev : null,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.chevron_right),
            label: const Text('Next surah'),
            onPressed: hasNext ? onNext : null,
          ),
        ),
      ],
    );
  }
}
