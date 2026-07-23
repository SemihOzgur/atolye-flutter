import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.isRefreshing,
    required this.lastUpdatedAt,
    required this.onRefresh,
  });

  final bool isRefreshing;
  final DateTime? lastUpdatedAt;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Genel Bakış', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppDimensions.spaceXxs),
              Text(
                'Atölyenizin güncel durumuna genel bakış',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (lastUpdatedAt != null)
              Text(
                'Son güncelleme: '
                '${DateFormat('dd.MM.yyyy HH:mm').format(lastUpdatedAt!)}',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            const SizedBox(height: AppDimensions.spaceXs),
            OutlinedButton.icon(
              onPressed: isRefreshing ? null : onRefresh,
              icon: isRefreshing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Yenile'),
            ),
          ],
        ),
      ],
    );
  }
}
