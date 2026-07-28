import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/theme/app_theme.dart';
import 'package:leather_care_admin/features/work_order/presentation/widgets/status_bottom_sheet.dart';

void main() {
  Future<void> pumpSheet(
    WidgetTester tester, {
    required String currentStatus,
    required void Function(String target, {String? note}) onConfirm,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => StatusBottomSheet.show(
                  context,
                  currentStatus: currentStatus,
                  onConfirm: onConfirm,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('RECEIVED shows only İşleme Al and İptal Et', (tester) async {
    await pumpSheet(tester, currentStatus: 'RECEIVED', onConfirm: (_, {note}) {});

    expect(find.text('İşleme Al'), findsOneWidget);
    expect(find.text('İptal Et'), findsOneWidget);
    expect(find.text('Hazır'), findsNothing);
    expect(find.text('İşleme Geri Al'), findsNothing);
  });

  testWidgets('IN_PROGRESS shows only Hazır and İptal Et', (tester) async {
    await pumpSheet(tester, currentStatus: 'IN_PROGRESS', onConfirm: (_, {note}) {});

    expect(find.text('Hazır'), findsOneWidget);
    expect(find.text('İptal Et'), findsOneWidget);
    expect(find.text('İşleme Al'), findsNothing);
  });

  testWidgets('READY shows only İşleme Geri Al and İptal Et', (tester) async {
    await pumpSheet(tester, currentStatus: 'READY', onConfirm: (_, {note}) {});

    expect(find.text('İşleme Geri Al'), findsOneWidget);
    expect(find.text('İptal Et'), findsOneWidget);
  });

  testWidgets('DELIVERED shows no transition cards at all', (tester) async {
    await pumpSheet(tester, currentStatus: 'DELIVERED', onConfirm: (_, {note}) {});

    expect(find.text('İşleme Al'), findsNothing);
    expect(find.text('Hazır'), findsNothing);
    expect(find.text('İşleme Geri Al'), findsNothing);
    expect(find.text('İptal Et'), findsNothing);
  });

  testWidgets('selecting Hazır asks for SMS confirmation before calling onConfirm', (
    tester,
  ) async {
    String? confirmedTarget;
    await pumpSheet(
      tester,
      currentStatus: 'IN_PROGRESS',
      onConfirm: (target, {note}) => confirmedTarget = target,
    );

    await tester.tap(find.text('Hazır'));
    await tester.pumpAndSettle();

    expect(find.textContaining('SMS'), findsOneWidget);
    expect(confirmedTarget, isNull);

    await tester.tap(find.text('Devam Et'));
    await tester.pumpAndSettle();

    expect(confirmedTarget, 'READY');
  });

  testWidgets('declining the SMS confirmation does not call onConfirm', (
    tester,
  ) async {
    var called = false;
    await pumpSheet(
      tester,
      currentStatus: 'IN_PROGRESS',
      onConfirm: (target, {note}) => called = true,
    );

    await tester.tap(find.text('Hazır'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();

    expect(called, isFalse);
  });

  testWidgets('selecting İptal Et lets the user type an optional note', (
    tester,
  ) async {
    String? confirmedTarget;
    String? confirmedNote;
    await pumpSheet(
      tester,
      currentStatus: 'RECEIVED',
      onConfirm: (target, {note}) {
        confirmedTarget = target;
        confirmedNote = note;
      },
    );

    await tester.tap(find.text('İptal Et').first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Müşteri vazgeçti');
    await tester.tap(find.text('İptal Et').last);
    await tester.pumpAndSettle();

    expect(confirmedTarget, 'CANCELLED');
    expect(confirmedNote, 'Müşteri vazgeçti');
  });
}
