import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/dashboard/presentation/widgets/revenue_summary_card.dart';

void main() {
  testWidgets('formats and labels daily and monthly revenue', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: RevenueSummaryCard(
            dailyRevenue: 1250.5,
            monthlyRevenue: 34500,
          ),
        ),
      ),
    );

    expect(find.text('Finansal Özet'), findsOneWidget);
    expect(find.text('Bugün'), findsOneWidget);
    expect(find.text('Bu Ay'), findsOneWidget);
    expect(find.text('1.250,50 ₺'), findsOneWidget);
    expect(find.text('34.500,00 ₺'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('handles both revenues being zero without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: RevenueSummaryCard(dailyRevenue: 0, monthlyRevenue: 0),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
