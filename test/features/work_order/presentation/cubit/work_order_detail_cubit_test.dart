import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_dto.dart';
import 'package:leather_care_admin/features/work_order/presentation/cubit/work_order_detail_cubit.dart';
import 'package:leather_care_admin/features/work_order/presentation/cubit/work_order_detail_state.dart';

import '../../fakes/fake_work_order_repository.dart';

void main() {
  late FakeWorkOrderRepository repository;
  late WorkOrderDetailCubit cubit;

  setUp(() {
    repository = FakeWorkOrderRepository();
    cubit = WorkOrderDetailCubit(repository, 1);
  });

  tearDown(() {
    cubit.close();
  });

  WorkOrderDto buildWorkOrder({required String status}) {
    return WorkOrderDto(
      id: 1,
      orderNumber: 'WO-2026-000001',
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
      suggestedPrice: 1550,
      price: 1550,
      hasPrepayment: false,
      remainingAmount: 1550,
      status: status,
      socialMediaConsent: false,
      trackingUrl: 'https://dotikadbm.com/t/abc',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );
  }

  test('load populates work order on success', () async {
    repository.workOrderToReturn = buildWorkOrder(status: 'RECEIVED');

    await cubit.load();

    expect(cubit.state.status, WorkOrderDetailStatus.loaded);
    expect(cubit.state.workOrder!.status, 'RECEIVED');
  });

  test('load emits error state on failure', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Not found',
      detail: 'İş emri bulunamadı.',
      statusCode: 404,
    );

    await cubit.load();

    expect(cubit.state.status, WorkOrderDetailStatus.error);
    expect(cubit.state.errorMessage, 'İş emri bulunamadı.');
  });

  test('updateStatus success replaces work order with server response',
      () async {
    repository.workOrderToReturn = buildWorkOrder(status: 'IN_PROGRESS');

    final error = await cubit.updateStatus('IN_PROGRESS');

    expect(error, isNull);
    expect(cubit.state.workOrder!.status, 'IN_PROGRESS');
    expect(repository.lastStatusRequest!.newStatus, 'IN_PROGRESS');
  });

  test('updateStatus 409 INVALID_STATUS_TRANSITION reloads detail', () async {
    repository.workOrderToReturn = buildWorkOrder(status: 'RECEIVED');
    await cubit.load();

    repository.exceptionToThrow = ApiException(
      message: 'Conflict',
      detail: 'Geçersiz durum geçişi.',
      errorCode: 'INVALID_STATUS_TRANSITION',
      statusCode: 409,
    );

    final error = await cubit.updateStatus('DELIVERED');

    expect(error, 'Geçersiz durum geçişi.');
    // reload() clears the exception path internally via repository state,
    // but since exceptionToThrow is still set, the follow-up load() call
    // (triggered by the 409 handling) also fails and surfaces the error state.
    expect(cubit.state.status, WorkOrderDetailStatus.error);
  });

  test('deliver success updates status to DELIVERED', () async {
    repository.workOrderToReturn = buildWorkOrder(status: 'DELIVERED');

    final error = await cubit.deliver(1550);

    expect(error, isNull);
    expect(cubit.state.workOrder!.status, 'DELIVERED');
    expect(repository.lastDeliverRequest!.finalPaymentAmount, 1550);
  });

  test('resendSms reloads detail on success', () async {
    repository.workOrderToReturn = buildWorkOrder(status: 'RECEIVED');

    final error = await cubit.resendSms();

    expect(error, isNull);
    expect(repository.lastResendId, 1);
    expect(cubit.state.status, WorkOrderDetailStatus.loaded);
  });

  test('resendSms surfaces NETGSM duplicate block message', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Bad Request',
      detail: 'Aynı mesaj 1 saat içinde tekrar gönderilemez, NETGSM engelledi.',
      statusCode: 400,
    );

    final error = await cubit.resendSms();

    expect(
      error,
      'Aynı mesaj 1 saat içinde tekrar gönderilemez, NETGSM engelledi.',
    );
  });
}
