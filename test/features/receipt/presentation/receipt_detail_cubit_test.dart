import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/receipt/data/dto/receipt_dto.dart';
import 'package:leather_care_admin/features/receipt/presentation/cubit/receipt_detail_cubit.dart';

import '../fakes/fake_receipt_repository.dart';
import '../fakes/receipt_fixtures.dart';

void main() {
  late FakeReceiptRepository repository;
  late ReceiptDetailCubit cubit;

  ReceiptDto receipt(List<Map<String, dynamic>> items) =>
      ReceiptDto.fromJson(receiptJson(items: items));

  setUp(() async {
    repository = FakeReceiptRepository()
      ..receiptToReturn = receipt([
        itemJson(id: 1, status: 'IN_PROGRESS'),
        itemJson(id: 2, status: 'IN_PROGRESS'),
        itemJson(id: 3, status: 'READY'),
        itemJson(id: 4, status: 'DELIVERED'),
      ]);
    cubit = ReceiptDetailCubit(repository, 7);
    await cubit.load();
  });

  tearDown(() => cubit.close());

  test('common targets are the intersection of selected items', () {
    cubit.toggle(1);
    cubit.toggle(2);
    expect(cubit.state.commonTargets, {'READY', 'CANCELLED'});
    expect(cubit.state.canDeliver, isFalse);

    cubit.toggle(3); // READY: IN_PROGRESS / CANCELLED
    expect(cubit.state.commonTargets, {'CANCELLED'});

    cubit.toggle(1);
    cubit.toggle(2);
    expect(cubit.state.canDeliver, isTrue);
  });

  test('toggleAll selects only open items, then clears', () {
    cubit.toggleAll();
    expect(cubit.state.selectedIds, {1, 2, 3});
    cubit.toggleAll();
    expect(cubit.state.selectedIds, isEmpty);
  });

  test('changeStatus sends selected ids and clears selection on success', () async {
    cubit.toggle(1);
    cubit.toggle(2);
    final ok = await cubit.changeStatus('READY');

    expect(ok, isTrue);
    expect(repository.lastWorkOrderIds, unorderedEquals([1, 2]));
    expect(repository.lastNewStatus, 'READY');
    expect(cubit.state.selectedIds, isEmpty);
  });

  test('deliver passes the single collected amount', () async {
    cubit.toggle(3);
    await cubit.deliver(850);
    expect(repository.lastWorkOrderIds, [3]);
    expect(repository.lastCollectedAmount, 850);
  });

  test('a failed bulk action keeps the selection and exposes the error', () async {
    cubit.toggle(1);
    repository.exceptionToThrow = ApiException(
      message: 'Conflict',
      statusCode: 409,
      detail: 'WO-2026-00001: geçilemez',
    );

    final ok = await cubit.changeStatus('READY');

    expect(ok, isFalse);
    expect(cubit.state.selectedIds, {1});
    expect(cubit.state.actionError, 'WO-2026-00001: geçilemez');
    expect(cubit.state.isBusy, isFalse);
  });
}
