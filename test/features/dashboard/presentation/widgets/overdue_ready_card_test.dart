import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/dashboard/presentation/widgets/overdue_ready_card.dart';

void main() {
  testWidgets('shows the overdue count and calls onTap when tapped', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: OverdueReadyCard(
            overdueCount: 12,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('7+ gündür teslim bekleyen işler'), findsOneWidget);
    expect(
      find.text('12 iş emri uzun süredir READY durumunda bekliyor.'),
      findsOneWidget,
    );

    await tester.tap(find.text('READY işlerini görüntüle'));
    expect(tapped, isTrue);
  });
}
