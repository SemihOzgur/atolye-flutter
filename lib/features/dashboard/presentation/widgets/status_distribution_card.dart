import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../work_order/presentation/widgets/work_order_status_badge.dart';

class _StatusSegment {
  const _StatusSegment({
    required this.status,
    required this.count,
  });

  final String status;
  final int count;
}

/// Donut chart of work order status counts, reusing the same status colors
/// and labels shown everywhere else in the app (WorkOrderStatusBadge).
class StatusDistributionCard extends StatelessWidget {
  const StatusDistributionCard({
    super.key,
    required this.receivedCount,
    required this.inProgressCount,
    required this.readyCount,
  });

  final int receivedCount;
  final int inProgressCount;
  final int readyCount;

  @override
  Widget build(BuildContext context) {
    final segments = [
      _StatusSegment(status: 'RECEIVED', count: receivedCount),
      _StatusSegment(status: 'IN_PROGRESS', count: inProgressCount),
      _StatusSegment(status: 'READY', count: readyCount),
    ];
    final total = receivedCount + inProgressCount + readyCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('İş Durumu Dağılımı', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppDimensions.spaceM),
            if (total == 0)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.spaceL),
                child: Text(
                  'Henüz iş emri yok.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final chart = _DonutChart(segments: segments, total: total);
                  final legend = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: segments
                        .map((s) => _LegendRow(segment: s))
                        .toList(),
                  );

                  if (constraints.maxWidth < 340) {
                    return Column(
                      children: [
                        chart,
                        const SizedBox(height: AppDimensions.spaceM),
                        legend,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      chart,
                      const SizedBox(width: AppDimensions.spaceXl),
                      Expanded(child: legend),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _DonutChart extends StatelessWidget {
  const _DonutChart({required this.segments, required this.total});

  final List<_StatusSegment> segments;
  final int total;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: CustomPaint(
        painter: _DonutPainter(segments: segments, total: total),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$total', style: Theme.of(context).textTheme.headlineMedium),
              const Text(
                'İş Emri',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.segments, required this.total});

  final List<_StatusSegment> segments;
  final int total;

  static const double _strokeWidth = 20;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (math.min(size.width, size.height) - _strokeWidth) / 2;
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    var startAngle = -math.pi / 2;
    for (final segment in segments) {
      if (segment.count == 0) continue;
      final sweep = (segment.count / total) * 2 * math.pi;
      final paint = Paint()
        ..color = WorkOrderStatusBadge.presentationFor(segment.status).color
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(arcRect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.segments != segments || oldDelegate.total != total;
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.segment});

  final _StatusSegment segment;

  @override
  Widget build(BuildContext context) {
    final presentation = WorkOrderStatusBadge.presentationFor(segment.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXxs),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: presentation.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceS),
          Expanded(child: Text(presentation.label)),
          Text(
            '${segment.count}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
