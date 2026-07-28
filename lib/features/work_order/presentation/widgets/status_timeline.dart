import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../data/dto/status_log_dto.dart';
import 'work_order_status_badge.dart';

/// Durum geçmişini eskiden yeniye kompakt bir liste olarak gösterir.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({super.key, required this.history});

  final List<StatusLogDto> history;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final log in history) _TimelineRow(log: log),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.log});

  final StatusLogDto log;

  @override
  Widget build(BuildContext context) {
    final label = WorkOrderStatusBadge.presentationFor(log.newStatus).label;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.circle,
              size: 8,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  '${log.changedBy} · '
                  '${DateFormat('dd.MM.yyyy HH:mm').format(log.changedAt.toLocal())}',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
