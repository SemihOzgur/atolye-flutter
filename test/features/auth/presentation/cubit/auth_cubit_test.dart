import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/app/app_startup_controller.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/services/storage_service.dart';
import 'package:leather_care_admin/features/auth/data/auth_repository.dart';
import 'package:leather_care_admin/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:leather_care_admin/features/auth/presentation/cubit/auth_state.dart';

void main() {
  late _FakeAuthRepository authRepository;
  late AppStartupController startupController;
  late AuthCubit cubit;

  setUp(() {
    authRepository = _FakeAuthRepository();
    startupController = AppStartupController(_FakeSecureStorageService());
    cubit = AuthCubit(authRepository, startupController);
  });

  tearDown(() {
    cubit.close();
    startupController.dispose();
  });

  test('resolves to idle and marks app authenticated on success', () async {
    await cubit.login('admin@firma.com', 'secret');

    expect(cubit.state.status, AuthFormStatus.idle);
    expect(startupController.state, AppLaunchState.authenticated);
  });

  test('emits failure with turkish message on 401', () async {
    authRepository.exceptionToThrow = ApiException(
      message: 'Unauthorized',
      statusCode: 401,
    );

    await cubit.login('admin@firma.com', 'wrong');

    expect(cubit.state.status, AuthFormStatus.failure);
    expect(cubit.state.errorMessage, 'E-posta veya şifre hatalı.');
    expect(startupController.state, isNot(AppLaunchState.authenticated));
  });

  test('emits rateLimited with 60s countdown on 429', () async {
    authRepository.exceptionToThrow = ApiException(
      message: 'Too Many Requests',
      statusCode: 429,
    );

    await cubit.login('admin@firma.com', 'secret');

    expect(cubit.state.status, AuthFormStatus.rateLimited);
    expect(cubit.state.retryAfterSeconds, 60);
    expect(
      cubit.state.errorMessage,
      'Çok fazla deneme yaptınız, 1 dakika bekleyin.',
    );
  });

  test('surfaces backend detail message for other errors', () async {
    authRepository.exceptionToThrow = ApiException(
      message: 'fallback',
      detail: 'Sunucu hatası oluştu.',
      statusCode: 500,
    );

    await cubit.login('admin@firma.com', 'secret');

    expect(cubit.state.status, AuthFormStatus.failure);
    expect(cubit.state.errorMessage, 'Sunucu hatası oluştu.');
  });
}

class _FakeAuthRepository implements IAuthRepository {
  ApiException? exceptionToThrow;

  @override
  Future<void> login({required String email, required String password}) async {
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
