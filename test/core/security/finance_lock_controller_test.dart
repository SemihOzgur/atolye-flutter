import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/security/finance_lock_controller.dart';
import 'package:leather_care_admin/core/security/pin_store.dart';
import 'package:leather_care_admin/core/services/storage_service.dart';

class _FakeSecureStorageService implements ISecureStorageService {
  final Map<String, String> _values = {};

  @override
  Future<void> clearAll() async => _values.clear();

  @override
  Future<void> delete(String key) async => _values.remove(key);

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;
}

void main() {
  late FinanceLockController controller;

  setUp(() {
    final pinStore = PinStore(_FakeSecureStorageService());
    controller = FinanceLockController(
      pinStore,
      autoLock: const Duration(minutes: 5),
      lockoutDuration: const Duration(seconds: 60),
      maxAttempts: 5,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  test('starts locked with no failed attempts', () {
    expect(controller.isUnlocked, isFalse);
    expect(controller.failedAttempts, 0);
    expect(controller.isLockedOut, isFalse);
  });

  test('setPinAndUnlock stores the PIN and unlocks', () async {
    await controller.setPinAndUnlock('1234');

    expect(controller.isUnlocked, isTrue);
    expect(await controller.hasPin(), isTrue);
  });

  test('unlock with the correct PIN succeeds and resets failed attempts', () async {
    await controller.setPinAndUnlock('1234');
    controller.lock();

    final result = await controller.unlock('1234');

    expect(result, PinVerifyResult.ok);
    expect(controller.isUnlocked, isTrue);
    expect(controller.failedAttempts, 0);
  });

  test('unlock with a wrong PIN fails and increments failed attempts', () async {
    await controller.setPinAndUnlock('1234');
    controller.lock();

    final result = await controller.unlock('0000');

    expect(result, PinVerifyResult.wrong);
    expect(controller.isUnlocked, isFalse);
    expect(controller.failedAttempts, 1);
  });

  test('lock() flips isUnlocked back to false', () async {
    await controller.setPinAndUnlock('1234');
    expect(controller.isUnlocked, isTrue);

    controller.lock();

    expect(controller.isUnlocked, isFalse);
  });

  testWidgets('auto-locks after the configured duration', (tester) async {
    await controller.setPinAndUnlock('1234');
    expect(controller.isUnlocked, isTrue);

    await tester.pump(const Duration(minutes: 5));

    expect(controller.isUnlocked, isFalse);
  });

  testWidgets(
    '5th wrong attempt locks out further attempts until the timer elapses',
    (tester) async {
      await controller.setPinAndUnlock('1234');
      controller.lock();

      for (var i = 0; i < 4; i++) {
        final result = await controller.unlock('0000');
        expect(result, PinVerifyResult.wrong);
      }
      expect(controller.isLockedOut, isFalse);

      final fifth = await controller.unlock('0000');
      expect(fifth, PinVerifyResult.wrong);
      expect(controller.isLockedOut, isTrue);
      expect(controller.failedAttempts, 5);

      // A 6th attempt is rejected outright while locked out — the correct
      // PIN doesn't help, no verification even happens.
      final sixth = await controller.unlock('1234');
      expect(sixth, PinVerifyResult.lockedOut);
      expect(controller.isUnlocked, isFalse);

      await tester.pump(const Duration(seconds: 60));

      expect(controller.isLockedOut, isFalse);
      expect(controller.failedAttempts, 0);

      final afterLockout = await controller.unlock('1234');
      expect(afterLockout, PinVerifyResult.ok);

      // Cancel the auto-lock timer scheduled by the unlock above so no
      // timer is left pending when this fake-async test completes.
      controller.lock();
    },
  );

  test('resetPin clears the PIN and locks', () async {
    await controller.setPinAndUnlock('1234');

    await controller.resetPin();

    expect(controller.isUnlocked, isFalse);
    expect(await controller.hasPin(), isFalse);
  });

  test('resetPin also clears an active lockout', () async {
    await controller.setPinAndUnlock('1234');
    controller.lock();
    for (var i = 0; i < 5; i++) {
      await controller.unlock('0000');
    }
    expect(controller.isLockedOut, isTrue);

    await controller.resetPin();

    expect(controller.isLockedOut, isFalse);
    expect(controller.failedAttempts, 0);
  });
}
