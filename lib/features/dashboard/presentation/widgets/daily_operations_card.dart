import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';

/// Compares today's received vs. delivered counts as two proportional bars.
/// The API only returns today's totals (no hourly/historical series), so
/// this intentionally stays a simple side-by-side comparison rather than a
/// fabricated time series.
class DailyOperationsCard extends StatelessWidget {
  const DailyOperationsCard({
    super.key,
    required this.receivedToday,
    required this.deliveredToday,
  });

  final int receivedToday;
  final int deliveredToday;

  @override
  Widget build(BuildContext context) {
    final maxValue = [
      receivedToday,
      deliveredToday,
      1,
    ].reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bugünkü Operasyon', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppDimensions.spaceM),
            _ComparisonBar(
              label: 'Alınan',
              value: receivedToday,
              maxValue: maxValue,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppDimensions.spaceM),
            _ComparisonBar(
              label: 'Teslim',
              value: deliveredToday,
              maxValue: maxValue,
              color: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonBar extends StatelessWidget {
  const _ComparisonBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final String label;
  final int value;
  final int maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fraction = maxValue == 0 ? 0.0 : value / maxValue;

    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: AppDecorations.borderRadiusM,
            child: Stack(
              children: [
                Container(height: 16, color: AppColors.surfaceMuted),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: fraction),
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  builder: (context, animatedFraction, _) => FractionallySizedBox(
                    widthFactor: animatedFraction.clamp(0, 1),
                    child: Container(height: 16, color: color),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.spaceS),
        SizedBox(
          width: 28,
          child: Text(
            '$value',
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
