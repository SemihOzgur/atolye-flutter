import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';

class WorkOrderStatusBadge extends StatelessWidget {
  const WorkOrderStatusBadge({super.key, required this.status});

  final String status;

  static ({Color color, String label}) presentationFor(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return (color: AppColors.primary, label: 'İşlemde');
      case 'READY':
        return (color: AppColors.warning, label: 'Hazır');
      case 'DELIVERED':
        return (color: AppColors.success, label: 'Teslim Edildi');
      case 'CANCELLED':
        return (color: AppColors.error, label: 'İptal Edildi');
      case 'RECEIVED':
      default:
        return (color: AppColors.textMuted, label: 'Teslim Alındı');
    }
  }

  @override
  Widget build(BuildContext context) {
    final presentation = presentationFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceS,
        vertical: AppDimensions.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: presentation.color.withValues(alpha: 0.12),
        borderRadius: AppDecorations.borderRadiusL,
        border: Border.all(color: presentation.color.withValues(alpha: 0.4)),
      ),
      child: Text(
        presentation.label,
        style: TextStyle(color: presentation.color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
