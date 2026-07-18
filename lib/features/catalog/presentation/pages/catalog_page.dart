import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_placeholder_page.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Katalog',
      description:
          'Kategori agaci, hizmet turleri, fiyat matrisi ve sarf malzemeler buraya baglanacak.',
      icon: Icons.category_rounded,
    );
  }
}