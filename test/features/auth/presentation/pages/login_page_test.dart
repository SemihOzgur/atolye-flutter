import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/app/app_startup_controller.dart';
import 'package:leather_care_admin/core/di/injection.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/services/storage_service.dart';
import 'package:leather_care_admin/features/auth/data/auth_repository.dart';
import 'package:leather_care_admin/features/auth/presentation/pages/login_page.dart';

void main() {
  late AppStartupController startupController;
  late _FakeAuthRepository fakeRepository;

  setUp(() {
    startupController = AppStartupController(_FakeSecureStorageService());
    fakeRepository = _FakeAuthRepository();

    if (getIt.isRegistered<IAuthRepository>()) {
      getIt.unregister<IAuthRepository>();
    }
    getIt.registerLazySingleton<IAuthRepository>(() => fakeRepository);
  });

  tearDown(() async {
    startupController.dispose();
    await getIt.reset();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: LoginPage(startupController: startupController),
    );
  }

  testWidgets('shows validation errors when submitting empty form', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    await tester.tap(find.text('Giriş Yap'));
    await tester.pump();

    expect(find.text('E-posta zorunludur'), findsOneWidget);
    expect(find.text('Şifre zorunludur'), findsOneWidget);
    expect(fakeRepository.callCount, 0);
  });

  testWidgets('toggles password visibility', (tester) async {
    await tester.pumpWidget(buildSubject());

    final passwordField = find.descendant(
      of: find.widgetWithText(TextFormField, 'Şifre'),
      matching: find.byType(TextField),
    );
    expect(tester.widget<TextField>(passwordField).obscureText, isTrue);

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    expect(tester.widget<TextField>(passwordField).obscureText, isFalse);
  });

  testWidgets('marks app authenticated on successful login', (tester) async {
    await tester.pumpWidget(buildSubject());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-posta'),
      'admin@firma.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Şifre'),
      'secret',
    );
    await tester.tap(find.text('Giriş Yap'));
    await tester.pumpAndSettle();

    expect(fakeRepository.callCount, 1);
    expect(startupController.state, AppLaunchState.authenticated);
  });

  testWidgets('shows turkish error message on 401', (tester) async {
    fakeRepository.exceptionToThrow = ApiException(
      message: 'Unauthorized',
      statusCode: 401,
    );

    await tester.pumpWidget(buildSubject());

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-posta'),
      'admin@firma.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Şifre'),
      'wrong',
    );
    await tester.tap(find.text('Giriş Yap'));
    await tester.pumpAndSettle();

    expect(find.text('E-posta veya şifre hatalı.'), findsOneWidget);
    expect(startupController.state, isNot(AppLaunchState.authenticated));
  });
}

class _FakeAuthRepository implements IAuthRepository {
  int callCount = 0;
  ApiException? exceptionToThrow;

  @override
  Future<void> login({required String email, required String password}) async {
    callCount++;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
  }
}

class _FakeSecureStorageService implements ISecureStorageService {
  final Map<String, String> _values = {};

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
