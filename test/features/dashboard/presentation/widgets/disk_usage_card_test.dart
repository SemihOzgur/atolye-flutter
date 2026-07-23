import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/dashboard/presentation/widgets/disk_usage_card.dart';

void main() {
  Widget buildSubject(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('shows the human-readable usage without a warning button', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        DiskUsageCard(
          usageBytes: 40 * 1024 * 1024 * 1024,
          isWarning: false,
          onArchiveTap: () {},
        ),
      ),
    );

    expect(find.text('Disk Kullanımı'), findsOneWidget);
    expect(find.text('40.0 GB'), findsOneWidget);
    expect(find.text('Arşivlemeyi Aç'), findsNothing);
  });

  testWidgets('shows the warning message and archive button, and calls onArchiveTap', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      buildSubject(
        DiskUsageCard(
          usageBytes: 120 * 1024 * 1024 * 1024,
          isWarning: true,
          onArchiveTap: () => tapped = true,
        ),
      ),
    );

    expect(find.text('120.0 GB'), findsOneWidget);
    expect(
      find.text('Medya depolama alanı yüksek kullanım seviyesine ulaştı.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Arşivlemeyi Aç'));
    expect(tapped, isTrue);
  });
}
