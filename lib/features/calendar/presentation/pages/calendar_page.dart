import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/calendar_controller.dart';
import '../widgets/calendar_grid.dart';
import '../widgets/event_card.dart';

class CalendarPage extends GetView<CalendarController> {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Calendar'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Today',
            icon: const Icon(Icons.today),
            onPressed: controller.goToToday,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _TodayHeader(),
                  const SizedBox(height: AppSizes.lg),
                  _MonthHeader(),
                  const SizedBox(height: AppSizes.md),
                  const CalendarGrid(),
                  const SizedBox(height: AppSizes.xl),
                  Text('Events this month', style: AppTextStyles.h4()),
                  const SizedBox(height: AppSizes.md),
                  Obx(() {
                    final events = controller.eventsThisMonth;
                    if (events.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(AppSizes.lg),
                        decoration: BoxDecoration(
                          color: AppColors.bgOffWhite,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusCards,
                          ),
                        ),
                        child: Text(
                          'No special Islamic events this month.',
                          style: AppTextStyles.bodySmall(),
                        ),
                      );
                    }
                    return Column(
                      children: events.map((e) {
                        final greg = controller.gregorianForDay(e.hijriDay);
                        final isToday = controller.isToday(e.hijriDay);
                        return EventCard(
                          event: e,
                          gregorianDate: greg,
                          isToday: isToday,
                        );
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: AppSizes.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TodayHeader extends GetView<CalendarController> {
  @override
  Widget build(BuildContext context) {
    final today = controller.today;
    final gregNow = DateTime.now();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.primaryDarkGreen, AppColors.primaryGreen],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusModals),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Today',
            style: AppTextStyles.bodySmall().copyWith(
              color: AppColors.bgOffWhite,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            '${today.hDay} ${today.longMonthName} ${today.hYear} AH',
            style: AppTextStyles.h2().copyWith(color: AppColors.bgWhite),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            DateFormat('EEEE, d MMMM yyyy').format(gregNow),
            style: AppTextStyles.bodyRegular().copyWith(
              color: AppColors.bgOffWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends GetView<CalendarController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: controller.prevMonth,
            tooltip: 'Previous month',
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  '${controller.monthNameEn} ${controller.hYear.value} AH',
                  style: AppTextStyles.h3(),
                  textAlign: TextAlign.center,
                ),
                Text(
                  controller.monthNameAr,
                  style: AppTextStyles.arabicBody().copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: controller.nextMonth,
            tooltip: 'Next month',
          ),
        ],
      ),
    );
  }
}
