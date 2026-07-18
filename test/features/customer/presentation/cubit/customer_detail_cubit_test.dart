import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_detail_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/customer/presentation/cubit/customer_detail_cubit.dart';
import 'package:leather_care_admin/features/customer/presentation/cubit/customer_detail_state.dart';

import '../../fakes/fake_customer_repository.dart';

void main() {
  late FakeCustomerRepository repository;
  late CustomerDetailCubit cubit;

  setUp(() {
    repository = FakeCustomerRepository();
    cubit = CustomerDetailCubit(repository, 1);
  });

  tearDown(() {
    cubit.close();
  });

  test('loads customer detail successfully', () async {
    repository.detailToReturn = CustomerDetailDto(
      customer: CustomerDto(
        id: 1,
        firstName: 'Ayşe',
        lastName: 'Yılmaz',
        phone: '+905321234567',
        iysConsentStatus: 'APPROVED',
        createdAt: DateTime(2026, 1, 1),
      ),
      workOrders: const [],
    );

    await cubit.load();

    expect(cubit.state.status, CustomerDetailStatus.loaded);
    expect(cubit.state.detail!.customer.firstName, 'Ayşe');
  });

  test('emits error state on failure', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Not found',
      detail: 'Müşteri bulunamadı.',
      statusCode: 404,
    );

    await cubit.load();

    expect(cubit.state.status, CustomerDetailStatus.error);
    expect(cubit.state.errorMessage, 'Müşteri bulunamadı.');
  });
}
