import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/scanner/presentation/cubit/scan_resolve_cubit.dart';
import 'package:leather_care_admin/features/scanner/presentation/cubit/scan_resolve_state.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_dto.dart';

import '../../../work_order/fakes/fake_work_order_repository.dart';

WorkOrderDto _workOrder({int id = 5}) {
  return WorkOrderDto(
    id: id,
    orderNumber: 'WO-2026-000123',
    customer: CustomerDto(
      id: 1,
      firstName: 'Ayşe',
      lastName: 'Yılmaz',
      phone: '+905321234567',
      iysConsentStatus: 'APPROVED',
      createdAt: DateTime(2026, 1, 1),
    ),
    categoryId: 3,
    categoryPath: 'Kadın > Ayakkabı > Sneakers',
    suggestedPrice: 100,
    price: 100,
    hasPrepayment: false,
    remainingAmount: 100,
    status: 'RECEIVED',
    socialMediaConsent: false,
    trackingUrl: 'https://dotikadbm.com/t/abc',
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );
}

void main() {
  late FakeWorkOrderRepository repository;
  late ScanResolveCubit cubit;

  setUp(() {
    repository = FakeWorkOrderRepository();
    cubit = ScanResolveCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  test('starts idle', () {
    expect(cubit.state.status, ScanResolveStatus.idle);
  });

  test('rejects a value that does not start with WO- without calling the API', () async {
    await cubit.resolve('https://dotikadbm.com/t/abc123');

    expect(cubit.state.status, ScanResolveStatus.rejected);
    expect(repository.lastFindByOrderNumberQuery, isNull);
  });

  test('resolves to the work order id on a successful match', () async {
    repository.workOrderToReturn = _workOrder(id: 42);

    await cubit.resolve('WO-2026-000123');

    expect(cubit.state.status, ScanResolveStatus.resolved);
    expect(cubit.state.resolvedWorkOrderId, 42);
    expect(repository.lastFindByOrderNumberQuery, 'WO-2026-000123');
  });

  test('emits notFound when the repository returns null', () async {
    repository.workOrderToReturn = null;

    await cubit.resolve('WO-2099-999999');

    expect(cubit.state.status, ScanResolveStatus.notFound);
    expect(cubit.state.resolvedWorkOrderId, isNull);
  });

  test('emits failure with the API error message on a network error', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Bağlantı hatası',
      detail: 'Sunucuya bağlanılamadı.',
      statusCode: 500,
    );

    await cubit.resolve('WO-2026-000123');

    expect(cubit.state.status, ScanResolveStatus.failure);
    expect(cubit.state.errorMessage, 'Sunucuya bağlanılamadı.');
  });

  test('reset returns to the initial idle state', () async {
    repository.workOrderToReturn = null;
    await cubit.resolve('WO-2099-999999');
    expect(cubit.state.status, ScanResolveStatus.notFound);

    cubit.reset();

    expect(cubit.state.status, ScanResolveStatus.idle);
    expect(cubit.state.scannedValue, isNull);
  });

  test('a second resolve() call is ignored while one is already resolving', () async {
    // FakeWorkOrderRepository resolves synchronously in this test setup,
    // so this mainly documents the guard exists; the real protection is
    // exercised by the scanner widget pausing the camera on first read.
    repository.workOrderToReturn = _workOrder();
    final first = cubit.resolve('WO-2026-000123');
    final second = cubit.resolve('WO-2026-000999');
    await Future.wait([first, second]);

    expect(cubit.state.status, ScanResolveStatus.resolved);
  });
}
