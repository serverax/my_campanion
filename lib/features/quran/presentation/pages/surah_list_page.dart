import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/quran_controller.dart';
import '../widgets/surah_tile.dart';
import 'quran_bookmarks_page.dart';
import 'quran_search_page.dart';
import 'surah_reader_page.dart';

class SurahListPage extends GetView<QuranController> {
  const SurahListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () => Get.to<void>(() => const QuranSearchPage()),
          ),
          IconButton(
            tooltip: 'Bookmarks',
            icon: const Icon(Icons.bookmarks_outlined),
            onPressed: () => Get.to<void>(() => const QuranBookmarksPage()),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.value != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Text(
                  controller.errorMessage.value!,
                  style: AppTextStyles.bodyRegular(),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.maxContentWidth,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Filter by name or surah number…',
                        prefixIcon: Icon(Icons.filter_list),
                      ),
                      onChanged: (v) => controller.filter.value = v,
                    ),
                  ),
                  if (controller.lastRead != null)
                    _LastReadBanner(
                      surah: controller.lastRead!.surah,
                      ayah: controller.lastRead!.ayah,
                    ),
                  Expanded(
                    child: Obx(() {
                      final list = controller.filteredSurahs;
                      if (list.isEmpty) {
                        return Center(
                          child: Text(
                            'No surah matches your filter.',
                            style: AppTextStyles.bodySmall(),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.lg,
                        ),
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final s = list[i];
                          return SurahTile(
                            surah: s,
                            onTap: () => Get.to<void>(
                              () => SurahReaderPage(surahNumber: s.number),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _LastReadBanner extends StatelessWidget {
  const _LastReadBanner({required this.surah, required this.ayah});
  final int surah;
  final int ayah;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.bgSoftGreen,
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.history,
            color: AppColors.primaryGreen,
            size: AppSizes.iconSm,
          ),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              'Continue from Surah $surah, ayah $ayah',
              style: AppTextStyles.bodySmall(),
            ),
          ),
          TextButton(
            onPressed: () =>
                Get.to<void>(() => SurahReaderPage(surahNumber: surah)),
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }
}
