import 'package:flutter/material.dart';

import '../../../../core/widgets/feature_placeholder_page.dart';

class WorkOrderPage extends StatelessWidget {
  const WorkOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Is Emirleri',
      description: 'Is emri olusturma, durum degisimi ve gecmis burada calisacak.',
      icon: Icons.work_rounded,
    );
  }
}