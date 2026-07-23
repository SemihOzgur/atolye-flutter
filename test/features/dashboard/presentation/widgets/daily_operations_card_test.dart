import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/dashboard/presentation/widgets/daily_operations_card.dart';

void main() {
  Widget buildSubject(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders the received/delivered comparison', (tester) async {
    await tester.pumpWidget(
      buildSubject(
        const DailyOperationsCard(receivedToday: 18, deliveredToday: 12),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bugünkü Operasyon'), findsOneWidget);
    expect(find.text('Alınan'), findsOneWidget);
    expect(find.text('Teslim'), findsOneWidget);
    expect(find.text('18'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
  });

  testWidgets('handles both values being zero without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        const DailyOperationsCard(receivedToday: 0, deliveredToday: 0),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
