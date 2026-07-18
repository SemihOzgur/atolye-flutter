import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_placeholder_page.dart';

class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Arsiv & Yedek',
      description: 'Arsiv adaylari ve son yedek bilgisi bu bolumde gosterilecek.',
      icon: Icons.archive_rounded,
    );
  }
}