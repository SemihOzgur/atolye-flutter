import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/dashboard/presentation/widgets/status_distribution_card.dart';

void main() {
  Widget buildSubject(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders the legend with status labels and counts', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        const StatusDistributionCard(
          receivedCount: 10,
          inProgressCount: 4,
          readyCount: 2,
        ),
      ),
    );

    expect(find.text('İş Durumu Dağılımı'), findsOneWidget);
    expect(find.text('Teslim Alındı'), findsOneWidget);
    expect(find.text('İşlemde'), findsOneWidget);
    expect(find.text('Hazır'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    // Donut center shows the total.
    expect(find.text('16'), findsOneWidget);
  });

  testWidgets('shows an empty message instead of a broken chart when total is zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        const StatusDistributionCard(
          receivedCount: 0,
          inProgressCount: 0,
          readyCount: 0,
        ),
      ),
    );

    expect(find.text('Henüz iş emri yok.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
