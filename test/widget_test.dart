import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/constants/storage_keys.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/services/storage_service.dart';
import 'package:leather_care_admin/features/auth/data/auth_repository.dart';
import 'package:leather_care_admin/main.dart';

void main() {
  setUp(() {
    if (getIt.isRegistered<IAuthRepository>()) {
      getIt.unregister<IAuthRepository>();
    }
    getIt.registerLazySingleton<IAuthRepository>(_FakeAuthRepository.new);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('shows login when no token is stored', (tester) async {
    await tester.pumpWidget(
      LeatherCareAdminApp(storageService: _FakeSecureStorageService()),
    );

    await tester.pumpAndSettle();

    expect(find.text('Giriş'), findsOneWidget);
    expect(find.text('DoTiKa admin paneline giriş yapın.'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'E-posta'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Şifre'), findsOneWidget);
  });

  testWidgets('shows shell dashboard when token exists', (tester) async {
    final storage = _FakeSecureStorageService({
      StorageKeys.authToken: 'token-123',
    });

    await tester.pumpWidget(
      LeatherCareAdminApp(storageService: storage),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Desktop Shell'), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
  });
}

class _FakeAuthRepository implements IAuthRepository {
  @override
  Future<void> login({required String email, required String password}) async {}
}

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
