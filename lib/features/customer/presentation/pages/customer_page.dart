import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_placeholder_page.dart';

class CustomerPage extends StatelessWidget {
  const CustomerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Musteriler',
      description:
          'Musteri arama, detay ve IYS akislari sonraki feature dalinda buraya baglanacak.',
      icon: Icons.person_search_rounded,
    );
  }
}