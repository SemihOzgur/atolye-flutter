import 'package:flutter_test/flutter_test.dart';
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
  late _FakeSecureStorageService storage;
  late PinStore pinStore;

  setUp(() {
    storage = _FakeSecureStorageService();
    pinStore = PinStore(storage);
  });

  test('hasPin is false when nothing was ever set', () async {
    expect(await pinStore.hasPin(), isFalse);
  });

  test('hasPin is true after setPin', () async {
    await pinStore.setPin('1234');
    expect(await pinStore.hasPin(), isTrue);
  });

  test('verify returns true for the correct PIN', () async {
    await pinStore.setPin('1234');
    expect(await pinStore.verify('1234'), isTrue);
  });

  test('verify returns false for an incorrect PIN', () async {
    await pinStore.setPin('1234');
    expect(await pinStore.verify('9999'), isFalse);
  });

  test('verify returns false when no PIN was ever set', () async {
    expect(await pinStore.verify('1234'), isFalse);
  });

  test('the raw PIN is never stored in plain text', () async {
    await pinStore.setPin('1234');
    expect(storage._values.values, isNot(contains('1234')));
  });

  test('two PinStore instances produce different salts for the same PIN', () async {
    final storageA = _FakeSecureStorageService();
    final storageB = _FakeSecureStorageService();
    await PinStore(storageA).setPin('1234');
    await PinStore(storageB).setPin('1234');

    expect(
      storageA._values['finance_pin_hash'],
      isNot(storageB._values['finance_pin_hash']),
    );
  });

  test('clear removes both hash and salt', () async {
    await pinStore.setPin('1234');
    await pinStore.clear();

    expect(await pinStore.hasPin(), isFalse);
    expect(await pinStore.verify('1234'), isFalse);
  });

  test('setPin overwrites a previous PIN', () async {
    await pinStore.setPin('1234');
    await pinStore.setPin('5678');

    expect(await pinStore.verify('1234'), isFalse);
    expect(await pinStore.verify('5678'), isTrue);
  });
}
