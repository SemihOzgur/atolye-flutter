import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';

class OverdueReadyCard extends StatelessWidget {
  const OverdueReadyCard({
    super.key,
    required this.overdueCount,
    required this.onTap,
  });

  final int overdueCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppDecorations.borderRadiusXl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spaceL),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.08),
          borderRadius: AppDecorations.borderRadiusXl,
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            const SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '7+ gündür teslim bekleyen işler',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXxs),
                  Text(
                    '$overdueCount iş emri uzun süredir READY durumunda bekliyor.',
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  const Text(
                    'READY işlerini görüntüle',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.error),
          ],
        ),
      ),
    );
  }
}
