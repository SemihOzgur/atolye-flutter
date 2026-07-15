import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';

abstract class AppDecorations {
  static BorderRadius get borderRadiusM =>
      BorderRadius.circular(AppDimensions.radiusM);

  static BorderRadius get borderRadiusL =>
      BorderRadius.circular(AppDimensions.radiusL);

  static BorderRadius get borderRadiusXl =>
      BorderRadius.circular(AppDimensions.radiusXl);

  static BoxShadow get softShadow => const BoxShadow(
        color: AppColors.shadow,
        blurRadius: 24,
        offset: Offset(0, 12),
      );

  static OutlineInputBorder get outlineBorder => OutlineInputBorder(
        borderRadius: borderRadiusM,
        borderSide: const BorderSide(color: AppColors.borderSoft),
      );
}
