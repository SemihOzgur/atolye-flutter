import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/network/paged_response.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/customer/presentation/cubit/customer_search_cubit.dart';
import 'package:leather_care_admin/features/customer/presentation/cubit/customer_search_state.dart';

import '../../fakes/fake_customer_repository.dart';

void main() {
  late FakeCustomerRepository repository;
  late CustomerSearchCubit cubit;

  setUp(() {
    repository = FakeCustomerRepository();
    cubit = CustomerSearchCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  final customer = CustomerDto(
    id: 1,
    firstName: 'Ayşe',
    lastName: 'Yılmaz',
    phone: '+905321234567',
    iysConsentStatus: 'PENDING',
    createdAt: DateTime(2026, 1, 1),
  );

  test('loads results for a query', () async {
    repository.pageToReturn = PagedResponse(
      items: [customer],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await cubit.search('0532');

    expect(cubit.state.status, CustomerSearchStatus.loaded);
    expect(cubit.state.items, [customer]);
  });

  test('empty query loads all customers (search param omitted)', () async {
    repository.pageToReturn = PagedResponse(
      items: [customer],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await cubit.search('');

    expect(cubit.state.status, CustomerSearchStatus.loaded);
    expect(cubit.state.items, [customer]);
    expect(repository.lastSearchRequested, isNull);
  });

  test('emits error state on failure', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'Müşteriler yüklenemedi.',
      statusCode: 500,
    );

    await cubit.search('0532');

    expect(cubit.state.status, CustomerSearchStatus.error);
    expect(cubit.state.errorMessage, 'Müşteriler yüklenemedi.');
  });

  test('goToPage requests the new page with the same query', () async {
    repository.pageToReturn = PagedResponse(
      items: [customer],
      page: 2,
      pageSize: 20,
      totalCount: 50,
    );

    await cubit.search('0532');
    await cubit.goToPage(2);

    expect(repository.lastPageRequested, 2);
    expect(repository.lastSearchRequested, '0532');
    expect(cubit.state.page, 2);
    expect(cubit.state.hasNextPage, isTrue);
    expect(cubit.state.hasPreviousPage, isTrue);
  });
}
