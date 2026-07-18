import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';

class IysStatusBadge extends StatelessWidget {
  const IysStatusBadge({super.key, required this.status});

  final String status;

  ({Color color, String label}) get _presentation {
    switch (status) {
      case 'SUBMITTED':
        return (color: AppColors.warning, label: 'Teyit bekleniyor');
      case 'APPROVED':
        return (color: AppColors.success, label: 'Onaylı');
      case 'REJECTED':
        return (color: AppColors.error, label: 'Reddedildi');
      case 'PENDING':
      default:
        return (color: AppColors.textMuted, label: 'Beklemede');
    }
  }

  @override
  Widget build(BuildContext context) {
    final presentation = _presentation;

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
