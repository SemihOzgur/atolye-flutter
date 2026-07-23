import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/byte_size_formatter.dart';

/// Shows raw disk usage reported by the backend. There is no total-capacity
/// field in the API contract, so this deliberately never renders a
/// percentage/progress bar — only the existing 100GB warning threshold
/// already used elsewhere in the app.
class DiskUsageCard extends StatelessWidget {
  const DiskUsageCard({
    super.key,
    required this.usageBytes,
    required this.isWarning,
    required this.onArchiveTap,
  });

  final int usageBytes;
  final bool isWarning;
  final VoidCallback onArchiveTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = isWarning ? AppColors.error : AppColors.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDecorations.borderRadiusXl,
        border: Border.all(
          color: isWarning ? accentColor.withValues(alpha: 0.4) : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceXs),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                ),
                child: Icon(Icons.storage_rounded, color: accentColor),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Disk Kullanımı', style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      ByteSizeFormatter.formatGb(usageBytes),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isWarning) ...[
            const SizedBox(height: AppDimensions.spaceM),
            const Text(
              'Medya depolama alanı yüksek kullanım seviyesine ulaştı.',
              style: TextStyle(color: AppColors.error, fontSize: 12),
            ),
            const SizedBox(height: AppDimensions.spaceS),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onArchiveTap,
                style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                child: const Text('Arşivlemeyi Aç'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
