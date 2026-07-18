import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_placeholder_page.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Sosyal Medya',
      description: 'Paylasim listeleri ve medya onizleme akisi burada tamamlanacak.',
      icon: Icons.campaign_rounded,
    );
  }
}