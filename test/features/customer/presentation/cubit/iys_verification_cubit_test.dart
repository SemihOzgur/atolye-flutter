import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/customer/data/dto/iys_confirm_response_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/iys_resend_code_response_dto.dart';
import 'package:leather_care_admin/features/customer/presentation/cubit/iys_verification_cubit.dart';
import 'package:leather_care_admin/features/customer/presentation/cubit/iys_verification_state.dart';

import '../../fakes/fake_customer_repository.dart';

void main() {
  late FakeCustomerRepository repository;
  late IysVerificationCubit cubit;

  setUp(() {
    repository = FakeCustomerRepository();
    cubit = IysVerificationCubit(
      repository,
      1,
      expiresAt: DateTime.now().add(const Duration(minutes: 5)),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('confirm success emits confirmed status', () async {
    repository.confirmResultToReturn = const IysConfirmResponseDto(
      iysConsentStatus: 'SUBMITTED',
      iysReferenceId: 'cust-1-123',
    );

    await cubit.confirm('1234');

    expect(cubit.state.status, IysPanelStatus.confirmed);
    expect(cubit.state.iysConsentStatus, 'SUBMITTED');
    expect(repository.lastConfirmCode, '1234');
  });

  test('wrong code increments attempt count and keeps panel active', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Bad code',
      statusCode: 400,
    );

    await cubit.confirm('0000');

    expect(cubit.state.status, IysPanelStatus.active);
    expect(cubit.state.wrongAttemptCount, 1);
    expect(cubit.state.remainingAttempts, 2);
  });

  test('CODE_LOCKED does not increment attempt count (already exhausted)', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Locked',
      errorCode: 'CODE_LOCKED',
      statusCode: 400,
    );

    await cubit.confirm('0000');

    expect(cubit.state.errorMessage, '3 kez yanlış girildi, yeniden kod isteyin.');
    expect(cubit.state.wrongAttemptCount, 0);
  });

  test('resend success resets expiry and starts cooldown', () async {
    final newExpiry = DateTime.now().add(const Duration(minutes: 5));
    repository.resendResultToReturn = IysResendCodeResponseDto(
      customerId: 1,
      expiresAt: newExpiry,
    );

    await cubit.resend();

    expect(cubit.state.expiresAt, newExpiry);
    expect(cubit.state.isInResendCooldown, isTrue);
    expect(repository.lastResendCustomerId, 1);
  });

  test('resend failure with ALREADY_CONSENTED surfaces specific message', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Conflict',
      errorCode: 'ALREADY_CONSENTED',
      statusCode: 409,
    );

    await cubit.resend();

    expect(cubit.state.errorMessage, 'Onay zaten alınmış.');
  });

  test('skip marks panel as skipped', () {
    cubit.skip();

    expect(cubit.state.status, IysPanelStatus.skipped);
  });
}
