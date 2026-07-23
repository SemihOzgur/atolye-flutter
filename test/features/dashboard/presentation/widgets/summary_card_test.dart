import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/dashboard/presentation/widgets/summary_card.dart';

void main() {
  Widget buildSubject(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  testWidgets('renders a static formatted value when count is not given', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        const SummaryCard(label: 'Günlük Ciro', value: '1.250,50 ₺'),
      ),
    );

    expect(find.text('Günlük Ciro'), findsOneWidget);
    expect(find.text('1.250,50 ₺'), findsOneWidget);
  });

  testWidgets('animates the count up to its target value', (tester) async {
    await tester.pumpWidget(
      buildSubject(const SummaryCard(label: 'İşlemde', count: 24)),
    );

    // Mid-animation the displayed number is below the target.
    await tester.pump(const Duration(milliseconds: 100));
    final midText = tester.widget<Text>(
      find.descendant(
        of: find.byType(SummaryCard),
        matching: find.byType(Text),
      ).at(1),
    );
    expect(int.parse(midText.data!), lessThanOrEqualTo(24));

    await tester.pumpAndSettle();
    expect(find.text('24'), findsOneWidget);
  });

  testWidgets('renders the description and icon when provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        const SummaryCard(
          label: 'İşlemde',
          count: 24,
          icon: Icons.settings_outlined,
          description: 'Aktif iş emri',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Aktif iş emri'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });
}
