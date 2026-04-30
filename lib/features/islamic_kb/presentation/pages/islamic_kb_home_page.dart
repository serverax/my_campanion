import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/islamic_qa_data.dart';
import '../../domain/entities/islamic_question.dart';
import '../controllers/islamic_kb_controller.dart';
import '../widgets/qa_card.dart';
import 'islamic_kb_category_page.dart';
import 'islamic_kb_detail_page.dart';
import 'islamic_kb_search_page.dart';

class IslamicKbHomePage extends GetView<IslamicKbController> {
  const IslamicKbHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Knowledge'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () => Get.to<void>(() => const IslamicKbSearchPage()),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.lg),
              children: <Widget>[
                _DisclaimerCard(),
                const SizedBox(height: AppSizes.lg),
                Text('Categories', style: AppTextStyles.h4()),
                const SizedBox(height: AppSizes.md),
                ...KbCategory.values.map((c) => _CategoryTile(category: c)),
                const SizedBox(height: AppSizes.xl),
                Obx(() {
                  if (controller.recent.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('Recently viewed', style: AppTextStyles.h4()),
                          const Spacer(),
                          TextButton(
                            onPressed: controller.clearHistory,
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.md),
                      ...controller.recent
                          .take(5)
                          .map(
                            (q) => QaCard(
                              entry: q,
                              onTap: () => Get.to<void>(
                                () => IslamicKbDetailPage(entry: q),
                              ),
                            ),
                          ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DisclaimerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.bgSoftGreen,
        border: Border.all(color: AppColors.primaryGreen),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.info_outline,
            color: AppColors.primaryGreen,
            size: AppSizes.iconMd,
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Text(
              IslamicQaData.universalDisclaimer,
              style: AppTextStyles.bodySmall(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category});
  final KbCategory category;

  IconData get _icon {
    switch (category) {
      case KbCategory.prayer:
        return Icons.access_time;
      case KbCategory.fasting:
        return Icons.no_food;
      case KbCategory.zakat:
        return Icons.volunteer_activism;
      case KbCategory.hajj:
        return Icons.flag_outlined;
      case KbCategory.calendar:
        return Icons.calendar_month;
      case KbCategory.daily:
        return Icons.menu_book;
      case KbCategory.everyday:
        return Icons.lightbulb_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = IslamicQaData.forCategory(category).length;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.lg,
          vertical: AppSizes.xs,
        ),
        leading: CircleAvatar(
          backgroundColor: AppColors.bgSoftGreen,
          child: Icon(_icon, color: AppColors.primaryGreen),
        ),
        title: Text(category.englishName, style: AppTextStyles.h4()),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            children: <Widget>[
              Text(
                category.arabicName,
                style: AppTextStyles.arabicBody().copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
                textDirection: TextDirection.rtl,
              ),
              const Spacer(),
              Text('$count entries', style: AppTextStyles.caption()),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () =>
            Get.to<void>(() => IslamicKbCategoryPage(category: category)),
      ),
    );
  }
}
