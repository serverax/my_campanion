import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';
import '../controllers/calendar_controller.dart';

class CalendarGrid extends GetView<CalendarController> {
  const CalendarGrid({super.key});

  static const List<String> _weekdayLabels = <String>[
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Recompute when month changes
      final _ = controller.hMonth.value;
      final firstGreg = controller.firstDayGregorian;
      // DateTime.weekday: 1=Monday … 7=Sunday. Convert to 0=Sunday … 6=Saturday.
      final firstWeekday = firstGreg.weekday % 7;
      final daysInMonth = controller.daysInCurrentMonth;
      final cells = <_DayCell?>[];

      for (var i = 0; i < firstWeekday; i++) {
        cells.add(null);
      }
      for (var d = 1; d <= daysInMonth; d++) {
        final greg = controller.gregorianForDay(d);
        cells.add(
          _DayCell(
            hijriDay: d,
            gregorianDay: greg.day,
            hasEvent: controller.eventForDay(d) != null,
            isToday: controller.isToday(d),
          ),
        );
      }
      while (cells.length % 7 != 0) {
        cells.add(null);
      }

      return Container(
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(AppSizes.radiusCards),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: _weekdayLabels
                  .map(
                    (d) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.xs,
                        ),
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption().copyWith(
                            fontWeight: FontWeight.w600,
                            color: d == 'Fri'
                                ? AppColors.primaryGreen
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Divider(height: 1),
            const SizedBox(height: AppSizes.xs),
            ...List.generate((cells.length / 7).ceil(), (row) {
              return Row(
                children: List.generate(7, (col) {
                  final cell = cells[row * 7 + col];
                  return Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: cell == null
                          ? const SizedBox.shrink()
                          : _DayTile(cell: cell),
                    ),
                  );
                }),
              );
            }),
          ],
        ),
      );
    });
  }
}

class _DayCell {
  final int hijriDay;
  final int gregorianDay;
  final bool hasEvent;
  final bool isToday;
  const _DayCell({
    required this.hijriDay,
    required this.gregorianDay,
    required this.hasEvent,
    required this.isToday,
  });
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.cell});
  final _DayCell cell;

  @override
  Widget build(BuildContext context) {
    final bg = cell.isToday
        ? AppColors.primaryGreen
        : (cell.hasEvent ? AppColors.bgSoftGreen : Colors.transparent);
    final fg = cell.isToday ? AppColors.bgWhite : AppColors.textPrimary;
    final fgSmall = cell.isToday ? AppColors.bgWhite : AppColors.textTertiary;

    final controller = Get.find<CalendarController>();
    final greg = controller.gregorianForDay(cell.hijriDay);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(AppSizes.radiusButtons),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusButtons),
          onTap: () => _showDetails(context, controller, cell, greg),
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${cell.hijriDay}',
                      style: AppTextStyles.bodyRegular().copyWith(
                        color: fg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${cell.gregorianDay}',
                      style: AppTextStyles.caption().copyWith(color: fgSmall),
                    ),
                  ],
                ),
              ),
              if (cell.hasEvent && !cell.isToday)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(
    BuildContext context,
    CalendarController controller,
    _DayCell cell,
    DateTime greg,
  ) {
    final event = controller.eventForDay(cell.hijriDay);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusModals),
        ),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${cell.hijriDay} ${controller.monthNameEn} ${controller.hYear.value} AH',
              style: AppTextStyles.h3(),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              DateFormat('EEEE, d MMMM yyyy').format(greg),
              style: AppTextStyles.bodyRegular(),
            ),
            if (event != null) ...<Widget>[
              const SizedBox(height: AppSizes.lg),
              const Divider(),
              const SizedBox(height: AppSizes.md),
              Text(event.name, style: AppTextStyles.h4()),
              const SizedBox(height: AppSizes.xs),
              Text(
                event.nameAr,
                style: AppTextStyles.arabicBody(),
                textDirection: TextDirection.rtl,
              ),
              if (event.notes != null) ...<Widget>[
                const SizedBox(height: AppSizes.md),
                Text(event.notes!, style: AppTextStyles.bodySmall()),
              ],
            ],
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }
}
