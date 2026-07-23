import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';

/// Shows the two revenue figures the API returns (today, this month) as a
/// simple two-point line chart. There is no historical/hourly series in the
/// API contract, so this deliberately plots only these two real values —
/// no interpolated or fabricated data points in between.
class RevenueSummaryCard extends StatelessWidget {
  const RevenueSummaryCard({
    super.key,
    required this.dailyRevenue,
    required this.monthlyRevenue,
  });

  final double dailyRevenue;
  final double monthlyRevenue;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Finansal Özet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppDimensions.spaceM),
            SizedBox(
              height: 180,
              child: _RevenueLineChart(
                dailyRevenue: dailyRevenue,
                monthlyRevenue: monthlyRevenue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueLineChart extends StatelessWidget {
  const _RevenueLineChart({
    required this.dailyRevenue,
    required this.monthlyRevenue,
  });

  final double dailyRevenue;
  final double monthlyRevenue;

  static const double _topPadding = 36;
  static const double _bottomPadding = 32;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        final chartHeight = size.height - _topPadding - _bottomPadding;
        final maxValue = [
          dailyRevenue,
          monthlyRevenue,
          1.0,
        ].reduce((a, b) => a > b ? a : b);

        double yFor(double value) {
          final fraction = maxValue == 0 ? 0.0 : (value / maxValue).clamp(0, 1);
          return _topPadding + chartHeight * (1 - fraction);
        }

        final p0 = Offset(size.width * 0.22, yFor(dailyRevenue));
        final p1 = Offset(size.width * 0.78, yFor(monthlyRevenue));
        final baselineY = _topPadding + chartHeight;

        return Stack(
          children: [
            CustomPaint(
              size: size,
              painter: _RevenueLinePainter(
                p0: p0,
                p1: p1,
                baselineY: baselineY,
              ),
            ),
            ..._pointLabels(
              point: p0,
              amountLabel: CurrencyFormatter.format(dailyRevenue),
              categoryLabel: 'Bugün',
              chartHeight: size.height,
            ),
            ..._pointLabels(
              point: p1,
              amountLabel: CurrencyFormatter.format(monthlyRevenue),
              categoryLabel: 'Bu Ay',
              chartHeight: size.height,
            ),
          ],
        );
      },
    );
  }

  static const double _labelWidth = 140;

  List<Widget> _pointLabels({
    required Offset point,
    required String amountLabel,
    required String categoryLabel,
    required double chartHeight,
  }) {
    return [
      Positioned(
        left: point.dx - _labelWidth / 2,
        top: point.dy - 30,
        width: _labelWidth,
        child: Text(
          amountLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Positioned(
        left: point.dx - _labelWidth / 2,
        top: chartHeight - _bottomPadding + 8,
        width: _labelWidth,
        child: Text(
          categoryLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ),
    ];
  }
}

class _RevenueLinePainter extends CustomPainter {
  _RevenueLinePainter({
    required this.p0,
    required this.p1,
    required this.baselineY,
  });

  final Offset p0;
  final Offset p1;
  final double baselineY;

  @override
  void paint(Canvas canvas, Size size) {
    final areaPath = Path()
      ..moveTo(p0.dx, baselineY)
      ..lineTo(p0.dx, p0.dy)
      ..lineTo(p1.dx, p1.dy)
      ..lineTo(p1.dx, baselineY)
      ..close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.success.withValues(alpha: 0.16),
          AppColors.success.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(areaPath, areaPaint);

    final basePaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, baselineY),
      Offset(size.width, baselineY),
      basePaint,
    );

    final linePaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(p0, p1, linePaint);

    final dotFillPaint = Paint()..color = AppColors.success;
    final dotRingPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (final point in [p0, p1]) {
      canvas.drawCircle(point, 6, dotFillPaint);
      canvas.drawCircle(point, 6, dotRingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RevenueLinePainter oldDelegate) =>
      oldDelegate.p0 != p0 || oldDelegate.p1 != p1;
}
