import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_dimensions.dart';

/// A KPI card: label + accent icon on top, a large value, and an optional
/// short description for context. If [count] is given, the value animates
/// as a count-up from 0; otherwise [value] is shown as static text (used for
/// already-formatted values such as currency).
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    this.value = '',
    this.count,
    this.icon,
    this.description,
    this.accentColor = AppColors.primary,
  }) : assert(
          count != null || value != '',
          'Provide either count or value.',
        );

  final String label;
  final String value;
  final int? count;
  final IconData? icon;
  final String? description;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppDecorations.borderRadiusXl,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spaceXs),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Icon(icon, size: 18, color: accentColor),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceM),
          // FittedBox shrinks long formatted values (e.g. currency) instead
          // of overflowing the card at the fixed displayLarge font size.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: count != null
                ? _CountUpText(
                    target: count!,
                    style: Theme.of(context).textTheme.displayLarge,
                  )
                : Text(value, style: Theme.of(context).textTheme.displayLarge),
          ),
          if (description != null) ...[
            const SizedBox(height: AppDimensions.spaceXxs),
            Text(
              description!,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _CountUpText extends StatelessWidget {
  const _CountUpText({required this.target, this.style});

  final int target;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: target),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) => Text('$value', style: style),
    );
  }
}
