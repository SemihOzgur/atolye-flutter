import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/app/app_startup_controller.dart';
import 'package:leather_care_admin/core/constants/storage_keys.dart';
import 'package:leather_care_admin/core/services/storage_service.dart';

class _FakeSecureStorageService implements ISecureStorageService {
  _FakeSecureStorageService([Map<String, String>? values])
      : _values = values ?? <String, String>{};

  final Map<String, String> _values;

  @override
  Future<void> clearAll() async {
    _values.clear();
  }

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }
}

void main() {
  test('reports unauthenticated when token is absent', () async {
    final controller = AppStartupController(_FakeSecureStorageService());

    await controller.initialize();

    expect(controller.state, AppLaunchState.unauthenticated);
    expect(controller.isBootstrapped, isTrue);
  });

  test('reports authenticated when token is stored', () async {
    final controller = AppStartupController(
      _FakeSecureStorageService({StorageKeys.authToken: 'token-123'}),
    );

    await controller.initialize();

    expect(controller.state, AppLaunchState.authenticated);
    expect(controller.isBootstrapped, isTrue);
  });
}