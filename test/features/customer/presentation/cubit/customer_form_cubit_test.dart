import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/customer/data/customer_repository.dart';
import 'package:leather_care_admin/features/customer/data/dto/create_customer_request_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/create_customer_response_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/update_customer_request_dto.dart';
import 'package:leather_care_admin/features/customer/presentation/cubit/customer_form_cubit.dart';
import 'package:leather_care_admin/features/customer/presentation/cubit/customer_form_state.dart';

import '../../fakes/fake_customer_repository.dart';

void main() {
  late FakeCustomerRepository repository;
  late CustomerFormCubit cubit;

  setUp(() {
    repository = FakeCustomerRepository();
    cubit = CustomerFormCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  final newCustomer = CustomerDto(
    id: 10,
    firstName: 'Mehmet',
    lastName: 'Demir',
    phone: '+905321112233',
    iysConsentStatus: 'PENDING',
    createdAt: DateTime(2026, 1, 1),
  );

  group('createCustomer', () {
    test('requires IYS verification on success', () async {
      repository.createResultToReturn = CustomerCreateResult.created(
        CreateCustomerResponseDto(
          customer: newCustomer,
          iysCodeExpiresAt: DateTime(2026, 1, 1, 10, 5),
        ),
      );

      await cubit.createCustomer(
        const CreateCustomerRequestDto(
          firstName: 'Mehmet',
          lastName: 'Demir',
          phone: '05321112233',
        ),
      );

      expect(cubit.state.success, isNotNull);
      expect(cubit.state.success!.isDuplicate, isFalse);
      expect(cubit.state.success!.requiresIysVerification, isTrue);
      expect(cubit.state.success!.iysCodeExpiresAt, DateTime(2026, 1, 1, 10, 5));
    });

    test('surfaces duplicate customer without requiring IYS panel', () async {
      final existing = newCustomer.copyWith(iysConsentStatus: 'APPROVED');
      repository.createResultToReturn = CustomerCreateResult.duplicate(existing);

      await cubit.createCustomer(
        const CreateCustomerRequestDto(
          firstName: 'Mehmet',
          lastName: 'Demir',
          phone: '05321112233',
        ),
      );

      expect(cubit.state.success!.isDuplicate, isTrue);
      expect(cubit.state.success!.requiresIysVerification, isFalse);
      expect(cubit.state.success!.customer, existing);
    });

    test('emits failure with field errors on validation error', () async {
      repository.exceptionToThrow = ApiException(
        message: 'Validation failed',
        detail: 'Geçerli bir cep telefonu giriniz.',
        statusCode: 400,
        fieldErrors: {
          'phone': ['Geçerli bir cep telefonu giriniz.'],
        },
      );

      await cubit.createCustomer(
        const CreateCustomerRequestDto(
          firstName: 'Mehmet',
          lastName: 'Demir',
          phone: '123',
        ),
      );

      expect(cubit.state.status, CustomerFormStatus.failure);
      expect(cubit.state.fieldErrors['phone'], isNotNull);
    });
  });

  group('updateCustomer', () {
    test('requires IYS verification with default 5-minute expiry when phone changed', () async {
      repository.updateResultToReturn = newCustomer;

      await cubit.updateCustomer(
        10,
        const UpdateCustomerRequestDto(
          firstName: 'Mehmet',
          lastName: 'Demir',
          phone: '+905321112233',
        ),
        phoneChanged: true,
      );

      final success = cubit.state.success!;
      expect(success.requiresIysVerification, isTrue);
      expect(success.iysCodeExpiresAt, isNotNull);
      expect(
        success.iysCodeExpiresAt!.difference(DateTime.now()).inMinutes,
        lessThanOrEqualTo(5),
      );
    });

    test('does not require IYS verification when phone unchanged', () async {
      repository.updateResultToReturn = newCustomer;

      await cubit.updateCustomer(
        10,
        const UpdateCustomerRequestDto(
          firstName: 'Mehmet',
          lastName: 'Demir',
          phone: '+905321112233',
        ),
        phoneChanged: false,
      );

      final success = cubit.state.success!;
      expect(success.requiresIysVerification, isFalse);
      expect(success.iysCodeExpiresAt, isNull);
    });
  });
}
