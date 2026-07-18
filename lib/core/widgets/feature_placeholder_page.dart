import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../theme/app_dimensions.dart';
import 'app_logo_mark.dart';

class FeaturePlaceholderPage extends StatelessWidget {
  const FeaturePlaceholderPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spaceXl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppLogoMark(size: 64),
                    const SizedBox(width: AppDimensions.spaceL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: AppDimensions.spaceXs),
                          Text(
                            description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spaceM),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.14),
                        borderRadius: AppDecorations.borderRadiusL,
                      ),
                      child: Icon(icon, color: AppColors.secondary, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceL),
                const Divider(color: AppColors.border),
                const SizedBox(height: AppDimensions.spaceL),
                Text(
                  'Bu alan proje temelinde hazirlanan yer tutucudur. Bir sonraki feature dalinda gercek akis buraya baglanacaktir.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}