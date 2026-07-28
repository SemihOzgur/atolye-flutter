import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/catalog/presentation/widgets/price_row_field.dart';

void main() {
  Widget wrap({
    required double initialPrice,
    required int resetToken,
    ValueChanged<double>? onValidChanged,
    ValueChanged<bool>? onValidityChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PriceRowField(
          key: const ValueKey(1),
          initialPrice: initialPrice,
          resetToken: resetToken,
          onValidChanged: onValidChanged ?? (_) {},
          onValidityChanged: onValidityChanged ?? (_) {},
        ),
      ),
    );
  }

  testWidgets('shows the initial price formatted with two decimals', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(initialPrice: 12.5, resetToken: 0));

    expect(find.text('12.50'), findsOneWidget);
  });

  testWidgets(
    'field content is preserved across rebuilds when resetToken is unchanged',
    (tester) async {
      final values = <double>[];
      await tester.pumpWidget(
        wrap(
          initialPrice: 0,
          resetToken: 0,
          onValidChanged: values.add,
        ),
      );

      await tester.enterText(find.byType(TextFormField), '1');
      await tester.pump();
      await tester.enterText(find.byType(TextFormField), '12');
      await tester.pump();
      await tester.enterText(find.byType(TextFormField), '12,5');
      await tester.pump();

      // Rebuild the parent (simulates a cubit emit from an unrelated row)
      // without changing resetToken — the field must keep what was typed.
      await tester.pumpWidget(
        wrap(initialPrice: 0, resetToken: 0, onValidChanged: values.add),
      );

      expect(find.text('12,5'), findsOneWidget);
      expect(values.last, 12.5);
    },
  );

  testWidgets('shows an error and does not call onValidChanged for "12,"', (
    tester,
  ) async {
    final values = <double>[];
    final validities = <bool>[];
    await tester.pumpWidget(
      wrap(
        initialPrice: 0,
        resetToken: 0,
        onValidChanged: values.add,
        onValidityChanged: validities.add,
      ),
    );

    await tester.enterText(find.byType(TextFormField), '12,');
    await tester.pump();

    expect(find.text('Geçersiz tutar'), findsOneWidget);
    expect(values, isEmpty);
    expect(validities.last, isFalse);

    await tester.enterText(find.byType(TextFormField), '12,5');
    await tester.pump();

    expect(find.text('Geçersiz tutar'), findsNothing);
    expect(values.last, 12.5);
    expect(validities.last, isTrue);
  });

  testWidgets('refreshes the controller only when resetToken changes', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(initialPrice: 10, resetToken: 0));

    await tester.enterText(find.byType(TextFormField), '55');
    await tester.pump();
    expect(find.text('55'), findsOneWidget);

    // Same resetToken, different initialPrice (e.g. unrelated row change) —
    // typed value must survive.
    await tester.pumpWidget(wrap(initialPrice: 99, resetToken: 0));
    expect(find.text('55'), findsOneWidget);

    // resetToken changes (server reload) — controller is refreshed.
    await tester.pumpWidget(wrap(initialPrice: 99, resetToken: 1));
    expect(find.text('99.00'), findsOneWidget);
  });
}
