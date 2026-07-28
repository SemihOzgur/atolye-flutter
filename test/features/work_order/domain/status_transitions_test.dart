import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/features/work_order/domain/status_transitions.dart';

void main() {
  List<String> targetsFor(String status) =>
      allowedTransitions(status).map((t) => t.target).toList();

  test('RECEIVED allows IN_PROGRESS and CANCELLED only', () {
    expect(targetsFor('RECEIVED'), ['IN_PROGRESS', 'CANCELLED']);
  });

  test('IN_PROGRESS allows READY and CANCELLED only', () {
    expect(targetsFor('IN_PROGRESS'), ['READY', 'CANCELLED']);
  });

  test('READY allows IN_PROGRESS (geri) and CANCELLED only', () {
    expect(targetsFor('READY'), ['IN_PROGRESS', 'CANCELLED']);
  });

  test('DELIVERED allows nothing — mobilde teslim sonrası buton yok', () {
    expect(allowedTransitions('DELIVERED'), isEmpty);
  });

  test('CANCELLED allows nothing — kapalı durum', () {
    expect(allowedTransitions('CANCELLED'), isEmpty);
  });

  test('DELIVERED is never a listed target for any status', () {
    for (final status in [
      'RECEIVED',
      'IN_PROGRESS',
      'READY',
      'DELIVERED',
      'CANCELLED',
    ]) {
      expect(targetsFor(status), isNot(contains('DELIVERED')));
    }
  });

  test('only the READY transition requires SMS confirmation', () {
    final readyTransition =
        allowedTransitions('IN_PROGRESS').firstWhere((t) => t.target == 'READY');
    expect(readyTransition.requiresSmsConfirm, isTrue);

    final inProgressTransition = allowedTransitions('RECEIVED')
        .firstWhere((t) => t.target == 'IN_PROGRESS');
    expect(inProgressTransition.requiresSmsConfirm, isFalse);
  });

  test('only the CANCELLED transition allows a note', () {
    final cancelled =
        allowedTransitions('RECEIVED').firstWhere((t) => t.target == 'CANCELLED');
    expect(cancelled.allowsNote, isTrue);

    final inProgress = allowedTransitions('RECEIVED')
        .firstWhere((t) => t.target == 'IN_PROGRESS');
    expect(inProgress.allowsNote, isFalse);
  });

  test('READY→IN_PROGRESS ("geri al") is labeled distinctly from RECEIVED→IN_PROGRESS', () {
    final fromReceived = allowedTransitions('RECEIVED')
        .firstWhere((t) => t.target == 'IN_PROGRESS');
    final fromReady = allowedTransitions('READY')
        .firstWhere((t) => t.target == 'IN_PROGRESS');

    expect(fromReceived.label, isNot(fromReady.label));
  });
}
