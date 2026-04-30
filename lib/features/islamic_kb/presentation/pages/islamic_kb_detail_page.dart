import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/islamic_qa_data.dart';
import '../../domain/entities/islamic_question.dart';
import '../controllers/islamic_kb_controller.dart';

class IslamicKbDetailPage extends StatefulWidget {
  const IslamicKbDetailPage({super.key, required this.entry});
  final IslamicQuestion entry;

  @override
  State<IslamicKbDetailPage> createState() => _IslamicKbDetailPageState();
}

class _IslamicKbDetailPageState extends State<IslamicKbDetailPage> {
  @override
  void initState() {
    super.initState();
    // Record view in history once on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<IslamicKbController>().recordView(widget.entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    return Scaffold(
      appBar: AppBar(title: Text(e.category.englishName)),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.lg),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.bgSoftGreen,
                    borderRadius: BorderRadius.circular(AppSizes.radiusCards),
                  ),
                  child: Text(
                    IslamicQaData.universalDisclaimer,
                    style: AppTextStyles.caption(),
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Text(
                  e.questionEn,
                  style: AppTextStyles.h3().copyWith(
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
                const SizedBox(height: AppSizes.xs),
                Text(
                  e.questionAr,
                  style: AppTextStyles.arabicBody().copyWith(fontSize: 18),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSizes.lg),
                const Divider(),
                const SizedBox(height: AppSizes.md),
                Text(
                  e.answerEn,
                  style: AppTextStyles.bodyRegular().copyWith(height: 1.6),
                ),
                const SizedBox(height: AppSizes.xl),
                _LabelRow(
                  icon: Icons.menu_book_outlined,
                  label: 'Source',
                  value: e.source,
                ),
                if (e.scholarlyNote != null) ...<Widget>[
                  const SizedBox(height: AppSizes.md),
                  _LabelRow(
                    icon: Icons.school_outlined,
                    label: 'Scholarly note',
                    value: e.scholarlyNote!,
                  ),
                ],
                const SizedBox(height: AppSizes.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabelRow extends StatelessWidget {
  const _LabelRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.bgOffWhite,
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSizes.radiusCards),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: AppColors.primaryGreen, size: AppSizes.iconSm),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: AppTextStyles.caption().copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDarkGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.bodySmall()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
