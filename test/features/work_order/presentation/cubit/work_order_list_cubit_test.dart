import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/core/network/paged_response.dart';
import 'package:leather_care_admin/features/customer/data/dto/work_order_list_item_dto.dart';
import 'package:leather_care_admin/features/work_order/presentation/cubit/work_order_list_cubit.dart';
import 'package:leather_care_admin/features/work_order/presentation/cubit/work_order_list_state.dart';

import '../../fakes/fake_work_order_repository.dart';

void main() {
  late FakeWorkOrderRepository repository;
  late WorkOrderListCubit cubit;

  setUp(() {
    repository = FakeWorkOrderRepository();
    cubit = WorkOrderListCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  final item = WorkOrderListItemDto(
    id: 1,
    orderNumber: 'WO-2026-000001',
    customerFullName: 'Ayşe Yılmaz',
    customerPhone: '+905321234567',
    categoryPath: 'Kadın > Ayakkabı > Sneakers',
    status: 'RECEIVED',
    price: 1550,
    remainingAmount: 1550,
    createdAt: DateTime(2026, 1, 1),
  );

  test('search loads items with status and query filters', () async {
    repository.pageToReturn = PagedResponse(
      items: [item],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await cubit.search(status: 'RECEIVED', query: '0532');

    expect(cubit.state.status, WorkOrderListStatus.loaded);
    expect(cubit.state.items, [item]);
    expect(cubit.state.statusFilter, 'RECEIVED');
  });

  test('emits error state on failure', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'İş emirleri yüklenemedi.',
      statusCode: 500,
    );

    await cubit.search();

    expect(cubit.state.status, WorkOrderListStatus.error);
    expect(cubit.state.errorMessage, 'İş emirleri yüklenemedi.');
  });

  test('search(status: null) clears an already-selected status filter', () async {
    repository.pageToReturn = PagedResponse(
      items: [item],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await cubit.search(status: 'RECEIVED');
    expect(cubit.state.statusFilter, 'RECEIVED');

    await cubit.search(status: null);
    expect(cubit.state.statusFilter, isNull);
  });

  test('search(query: ...) without status keeps the current status filter',
      () async {
    repository.pageToReturn = PagedResponse(
      items: [item],
      page: 1,
      pageSize: 20,
      totalCount: 1,
    );

    await cubit.search(status: 'READY');
    await cubit.search(query: 'nike');

    expect(cubit.state.statusFilter, 'READY');
    expect(cubit.state.query, 'nike');
  });

  test('goToPage keeps existing filters', () async {
    repository.pageToReturn = PagedResponse(
      items: [item],
      page: 2,
      pageSize: 20,
      totalCount: 50,
    );

    await cubit.search(status: 'READY', query: 'nike');
    await cubit.goToPage(2);

    expect(cubit.state.page, 2);
    expect(cubit.state.statusFilter, 'READY');
    expect(cubit.state.query, 'nike');
  });
}
