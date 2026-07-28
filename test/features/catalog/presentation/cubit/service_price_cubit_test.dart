import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/catalog/data/dto/service_price_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/service_type_dto.dart';
import 'package:leather_care_admin/features/catalog/presentation/cubit/service_price_cubit.dart';
import 'package:leather_care_admin/features/catalog/presentation/cubit/service_price_state.dart';
import 'package:leather_care_admin/features/catalog/presentation/cubit/service_type_cubit.dart';

import '../../fakes/fake_catalog_repository.dart';

void main() {
  late FakeCatalogRepository repository;
  late ServiceTypeCubit serviceTypeCubit;
  late ServicePriceCubit cubit;

  const serviceTypes = [
    ServiceTypeDto(id: 1, name: 'Bakım', sortOrder: 0, isActive: true),
    ServiceTypeDto(id: 2, name: 'Boya', sortOrder: 1, isActive: true),
  ];

  setUp(() async {
    repository = FakeCatalogRepository();
    repository.serviceTypesToReturn = serviceTypes;
    serviceTypeCubit = ServiceTypeCubit(repository);
    await serviceTypeCubit.load();
    cubit = ServicePriceCubit(repository, serviceTypeCubit);
  });

  tearDown(() {
    cubit.close();
    serviceTypeCubit.close();
  });

  test('selectCategory builds a row per active service type', () async {
    repository.servicePricesToReturn = const [
      ServicePriceDto(
        id: 10,
        categoryId: 3,
        categoryPath: 'Kadın > Ayakkabı > Sneakers',
        serviceTypeId: 1,
        serviceName: 'Bakım',
        price: 250,
        isActive: true,
      ),
    ];

    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');

    expect(cubit.state.status, ServicePriceStatus.loaded);
    expect(cubit.state.rows, hasLength(2));

    final bakimRow = cubit.state.rows.firstWhere((r) => r.serviceTypeId == 1);
    expect(bakimRow.price, 250);
    expect(bakimRow.isActive, isTrue);
    expect(bakimRow.hasExistingPrice, isTrue);

    final boyaRow = cubit.state.rows.firstWhere((r) => r.serviceTypeId == 2);
    expect(boyaRow.price, 0);
    expect(boyaRow.isActive, isFalse);
    expect(boyaRow.hasExistingPrice, isFalse);
  });

  test('updateRowPrice and updateRowActive mutate only the target row', () async {
    repository.servicePricesToReturn = const [];
    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');

    cubit.updateRowPrice(2, 500);
    cubit.updateRowActive(2, true);

    final boyaRow = cubit.state.rows.firstWhere((r) => r.serviceTypeId == 2);
    expect(boyaRow.price, 500);
    expect(boyaRow.isActive, isTrue);

    final bakimRow = cubit.state.rows.firstWhere((r) => r.serviceTypeId == 1);
    expect(bakimRow.price, 0);
    expect(bakimRow.isActive, isFalse);
  });

  test('saveAll only submits rows with existing price or newly activated', () async {
    repository.servicePricesToReturn = const [
      ServicePriceDto(
        id: 10,
        categoryId: 3,
        categoryPath: 'Kadın > Ayakkabı > Sneakers',
        serviceTypeId: 1,
        serviceName: 'Bakım',
        price: 250,
        isActive: true,
      ),
    ];
    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');

    repository.bulkUpsertResultToReturn = repository.servicePricesToReturn;
    await cubit.saveAll();

    final submitted = repository.lastBulkUpsertItems!;
    expect(submitted, hasLength(1));
  });

  test('saveAll surfaces error and keeps rows on failure', () async {
    repository.servicePricesToReturn = const [];
    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');
    cubit.updateRowActive(2, true);
    cubit.updateRowPrice(2, 300);

    repository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'Fiyatlar kaydedilemedi.',
      statusCode: 400,
    );

    await cubit.saveAll();

    expect(cubit.state.status, ServicePriceStatus.error);
    expect(cubit.state.errorMessage, 'Fiyatlar kaydedilemedi.');
    expect(cubit.state.rows, hasLength(2));
  });

  test('selectCategory increments reloadStamp only on successful load',
      () async {
    repository.servicePricesToReturn = const [];
    expect(cubit.state.reloadStamp, 0);

    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');
    expect(cubit.state.reloadStamp, 1);

    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');
    expect(cubit.state.reloadStamp, 2);

    repository.exceptionToThrow = ApiException(message: 'err');
    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');
    expect(cubit.state.reloadStamp, 2);
  });

  test('setRowValidity tracks invalid rows and blocks canSave', () async {
    repository.servicePricesToReturn = const [];
    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');
    expect(cubit.state.canSave, isTrue);

    cubit.setRowValidity(1, false);
    expect(cubit.state.invalidRowIds, {1});
    expect(cubit.state.canSave, isFalse);

    cubit.setRowValidity(2, false);
    expect(cubit.state.invalidRowIds, {1, 2});

    cubit.setRowValidity(1, true);
    expect(cubit.state.invalidRowIds, {2});
    expect(cubit.state.canSave, isFalse);

    cubit.setRowValidity(2, true);
    expect(cubit.state.invalidRowIds, isEmpty);
    expect(cubit.state.canSave, isTrue);
  });

  test('saveAll is a no-op while any row is invalid', () async {
    repository.servicePricesToReturn = const [];
    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');
    cubit.setRowValidity(1, false);

    await cubit.saveAll();

    expect(repository.lastBulkUpsertItems, isNull);
    expect(cubit.state.status, ServicePriceStatus.loaded);
  });

  test('a category switch clears invalidRowIds from the previous category',
      () async {
    repository.servicePricesToReturn = const [];
    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');
    cubit.setRowValidity(1, false);
    expect(cubit.state.canSave, isFalse);

    await cubit.selectCategory(4, 'Erkek > Çanta > Sırt Çantası');

    expect(cubit.state.invalidRowIds, isEmpty);
    expect(cubit.state.canSave, isTrue);
  });
}
