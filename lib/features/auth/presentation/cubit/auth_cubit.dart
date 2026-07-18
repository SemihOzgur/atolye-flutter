import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/app_startup_controller.dart';
import '../../../../core/network/api_exception.dart';
import '../../data/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository, this._appStartupController)
      : super(const AuthState());

  final IAuthRepository _authRepository;
  final AppStartupController _appStartupController;

  Future<void> login(String email, String password) async {
    emit(const AuthState(status: AuthFormStatus.submitting));

    try {
      await _authRepository.login(email: email, password: password);
      _appStartupController.markAuthenticated();
      emit(const AuthState());
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        emit(const AuthState(
          status: AuthFormStatus.failure,
          errorMessage: 'E-posta veya şifre hatalı.',
        ));
      } else if (e.statusCode == 429) {
        emit(const AuthState(
          status: AuthFormStatus.rateLimited,
          errorMessage: 'Çok fazla deneme yaptınız, 1 dakika bekleyin.',
          retryAfterSeconds: 60,
        ));
      } else {
        emit(AuthState(
          status: AuthFormStatus.failure,
          errorMessage: e.detail ?? e.message,
        ));
      }
    }
  }
}
