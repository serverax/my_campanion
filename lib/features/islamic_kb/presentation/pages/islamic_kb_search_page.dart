import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/islamic_kb_controller.dart';
import '../widgets/qa_card.dart';
import 'islamic_kb_detail_page.dart';

class IslamicKbSearchPage extends GetView<IslamicKbController> {
  const IslamicKbSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
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
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search questions or answers (min 2 chars)…',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: controller.onSearchChanged,
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    final list = controller.results;
                    final q = controller.query.value.trim();
                    if (q.length < 2) {
                      return Center(
                        child: Text(
                          'Type at least 2 characters to search.',
                          style: AppTextStyles.bodySmall(),
                        ),
                      );
                    }
                    if (list.isEmpty) {
                      return Center(
                        child: Text(
                          'No matches.',
                          style: AppTextStyles.bodySmall(),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.lg,
                      ),
                      itemCount: list.length,
                      itemBuilder: (_, i) => QaCard(
                        entry: list[i],
                        onTap: () => Get.to<void>(
                          () => IslamicKbDetailPage(entry: list[i]),
                        ),
                      ),
                    );
                  }),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.md),
                  color: AppColors.bgSoftGreen,
                  child: Text(
                    'General guidance — not a fatwa. For personal rulings, '
                    'consult a qualified scholar.',
                    style: AppTextStyles.caption(),
                    textAlign: TextAlign.center,
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
