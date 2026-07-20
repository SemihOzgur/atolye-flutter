import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';
import 'skeleton_box.dart';

/// A shimmering placeholder shaped like a typical list row (title + subtitle
/// + trailing badge), for use while a list-style page is loading.
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceM,
        vertical: AppDimensions.spaceS,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SkeletonBox(width: 220, height: 16),
                const SizedBox(height: AppDimensions.spaceXs),
                SkeletonBox(width: 140, height: 12),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          const SkeletonBox(width: 72, height: 24, borderRadius: 12),
        ],
      ),
    );
  }
}

/// A column of [count] shimmering [SkeletonListTile] rows.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 6});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (_) => const SkeletonListTile()),
    );
  }
}
