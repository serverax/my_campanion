import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/text_styles.dart';

/// Circular compass dial.
///
/// - Cardinal labels rotate so true north stays absolute (not relative to device)
/// - The qibla arrow points toward (qiblaBearing - heading), so when the user
///   physically faces qibla, the arrow points straight up.
class CompassDial extends StatelessWidget {
  const CompassDial({
    super.key,
    required this.qiblaBearing,
    this.heading,
    this.size = 280,
  });

  final double qiblaBearing;
  final double? heading;
  final double size;

  @override
  Widget build(BuildContext context) {
    final h = heading ?? 0;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Outer ring + cardinal labels — rotated so N stays absolute
          AnimatedRotation(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            turns: -h / 360,
            child: _CompassRing(size: size),
          ),
          // Qibla arrow — rotates to (qiblaBearing - heading)
          AnimatedRotation(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            turns: (qiblaBearing - h) / 360,
            child: _QiblaArrow(size: size * 0.8),
          ),
          // Center dot
          Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryDarkGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassRing extends StatelessWidget {
  const _CompassRing({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.bgWhite,
        border: Border.all(color: AppColors.primaryGreen, width: 3),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            blurRadius: 14,
            color: Colors.black26,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ..._buildTicks(),
          _label(
            'N',
            Alignment.topCenter,
            color: AppColors.errorRed,
            bold: true,
          ),
          _label('E', Alignment.centerRight),
          _label('S', Alignment.bottomCenter),
          _label('W', Alignment.centerLeft),
        ],
      ),
    );
  }

  Widget _label(
    String text,
    AlignmentGeometry alignment, {
    Color color = AppColors.textPrimary,
    bool bold = false,
  }) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Text(
          text,
          style: AppTextStyles.h3().copyWith(
            color: color,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTicks() {
    final ticks = <Widget>[];
    for (var i = 0; i < 360; i += 15) {
      final isMajor = i % 90 == 0;
      final isMid = i % 30 == 0;
      ticks.add(
        Transform.rotate(
          angle: i * (math.pi / 180),
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: isMajor ? 3 : (isMid ? 2 : 1),
              height: isMajor ? 14 : (isMid ? 10 : 6),
              margin: const EdgeInsets.only(top: AppSizes.xs),
              color: isMajor
                  ? AppColors.primaryDarkGreen
                  : AppColors.textTertiary,
            ),
          ),
        ),
      );
    }
    return ticks;
  }
}

class _QiblaArrow extends StatelessWidget {
  const _QiblaArrow({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.navigation,
            size: size * 0.34,
            color: AppColors.accentGold,
            shadows: const <Shadow>[
              Shadow(blurRadius: 8, color: Colors.black38),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
