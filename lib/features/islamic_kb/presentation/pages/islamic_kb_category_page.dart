import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../domain/entities/islamic_question.dart';
import '../controllers/islamic_kb_controller.dart';
import '../widgets/qa_card.dart';
import 'islamic_kb_detail_page.dart';

class IslamicKbCategoryPage extends StatelessWidget {
  const IslamicKbCategoryPage({super.key, required this.category});
  final KbCategory category;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<IslamicKbController>();
    final entries = controller.forCategory(category);
    return Scaffold(
      appBar: AppBar(title: Text(category.englishName)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSizes.lg),
              itemCount: entries.length,
              itemBuilder: (_, i) => QaCard(
                entry: entries[i],
                onTap: () =>
                    Get.to<void>(() => IslamicKbDetailPage(entry: entries[i])),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
