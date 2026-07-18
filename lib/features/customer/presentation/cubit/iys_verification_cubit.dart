import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_error_codes.dart';
import '../../../../core/network/api_exception.dart';
import '../../data/customer_repository.dart';
import 'iys_verification_state.dart';

const Duration _resendCooldown = Duration(seconds: 60);

class IysVerificationCubit extends Cubit<IysVerificationState> {
  IysVerificationCubit(this._repository, int customerId, {DateTime? expiresAt})
      : super(
          IysVerificationState(customerId: customerId, expiresAt: expiresAt),
        );

  final ICustomerRepository _repository;

  Future<void> confirm(String code) async {
    emit(
      IysVerificationState(
        status: IysPanelStatus.confirming,
        customerId: state.customerId,
        expiresAt: state.expiresAt,
        wrongAttemptCount: state.wrongAttemptCount,
        resendCooldownUntil: state.resendCooldownUntil,
      ),
    );

    try {
      final result = await _repository.confirmIysCode(state.customerId, code);

      emit(
        IysVerificationState(
          status: IysPanelStatus.confirmed,
          customerId: state.customerId,
          expiresAt: state.expiresAt,
          iysConsentStatus: result.iysConsentStatus,
          iysReferenceId: result.iysReferenceId,
        ),
      );
    } on ApiException catch (e) {
      final isWrongCode = e.errorCode != ApiErrorCodes.codeExpired &&
          e.errorCode != ApiErrorCodes.codeLocked &&
          e.errorCode != ApiErrorCodes.noActiveCode;

      emit(
        IysVerificationState(
          status: IysPanelStatus.active,
          customerId: state.customerId,
          expiresAt: state.expiresAt,
          errorMessage: _messageFor(e),
          wrongAttemptCount:
              isWrongCode ? state.wrongAttemptCount + 1 : state.wrongAttemptCount,
          resendCooldownUntil: state.resendCooldownUntil,
        ),
      );
    }
  }

  Future<void> resend() async {
    emit(
      IysVerificationState(
        status: IysPanelStatus.resending,
        customerId: state.customerId,
        expiresAt: state.expiresAt,
        wrongAttemptCount: state.wrongAttemptCount,
        resendCooldownUntil: state.resendCooldownUntil,
      ),
    );

    try {
      final result = await _repository.resendIysCode(state.customerId);

      emit(
        IysVerificationState(
          status: IysPanelStatus.active,
          customerId: state.customerId,
          expiresAt: result.expiresAt,
          resendCooldownUntil: DateTime.now().add(_resendCooldown),
        ),
      );
    } on ApiException catch (e) {
      emit(
        IysVerificationState(
          status: IysPanelStatus.active,
          customerId: state.customerId,
          expiresAt: state.expiresAt,
          errorMessage: _messageFor(e),
          wrongAttemptCount: state.wrongAttemptCount,
          resendCooldownUntil: state.resendCooldownUntil,
        ),
      );
    }
  }

  void skip() {
    emit(
      IysVerificationState(
        status: IysPanelStatus.skipped,
        customerId: state.customerId,
      ),
    );
  }

  String _messageFor(ApiException e) {
    switch (e.errorCode) {
      case ApiErrorCodes.codeExpired:
        return 'Kodun süresi doldu, yeniden gönderin.';
      case ApiErrorCodes.codeLocked:
        return '3 kez yanlış girildi, yeniden kod isteyin.';
      case ApiErrorCodes.noActiveCode:
        return 'Aktif kod yok, yeniden gönderin.';
      case ApiErrorCodes.iysPendingConfirmation:
        return 'İYS teyidi bekleniyor.';
      case ApiErrorCodes.alreadyConsented:
        return 'Onay zaten alınmış.';
      default:
        if (e.statusCode == 429) {
          return 'Çok fazla deneme yaptınız, biraz sonra tekrar deneyin.';
        }
        return e.detail ?? e.message;
    }
  }
}
