import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/catalog/data/dto/consumable_group_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/consumable_product_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/create_consumable_group_request_dto.dart';
import 'package:leather_care_admin/features/catalog/presentation/cubit/consumable_cubit.dart';
import 'package:leather_care_admin/features/catalog/presentation/cubit/consumable_state.dart';

import '../../fakes/fake_catalog_repository.dart';

void main() {
  late FakeCatalogRepository repository;
  late ConsumableCubit cubit;

  setUp(() {
    repository = FakeCatalogRepository();
    cubit = ConsumableCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  const groups = [
    ConsumableGroupDto(id: 1, name: 'Bakım Ürünleri', isActive: true),
  ];
  const products = [
    ConsumableProductDto(
      id: 1,
      groupId: 1,
      groupName: 'Bakım Ürünleri',
      brand: 'Saphir',
      name: 'Deri Bakım Kremi',
      displayName: 'Saphir Deri Bakım Kremi',
      salePrice: 400,
      isActive: true,
    ),
  ];

  test('load populates groups and products', () async {
    repository.consumableGroupsToReturn = groups;
    repository.consumableProductsToReturn = products;

    await cubit.load();

    expect(cubit.state.status, ConsumableStatus.loaded);
    expect(cubit.state.groups, groups);
    expect(cubit.state.products, products);
  });

  test('load emits error state on failure', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'Sarf malzemeler yüklenemedi.',
      statusCode: 500,
    );

    await cubit.load();

    expect(cubit.state.status, ConsumableStatus.error);
    expect(cubit.state.errorMessage, 'Sarf malzemeler yüklenemedi.');
  });

  test('filterByGroup requests products scoped to the group', () async {
    repository.consumableGroupsToReturn = groups;
    repository.consumableProductsToReturn = products;
    await cubit.load();

    await cubit.filterByGroup(1);

    expect(repository.lastProductsGroupId, 1);
    expect(cubit.state.selectedGroupId, 1);
  });

  test('createGroup creates then reloads groups and products', () async {
    repository.consumableGroupsToReturn = groups;
    repository.consumableProductsToReturn = products;
    repository.consumableGroupResultToReturn = const ConsumableGroupDto(
      id: 2,
      name: 'Boya Ürünleri',
      isActive: true,
    );

    final result = await cubit.createGroup(
      const CreateConsumableGroupRequestDto(name: 'Boya Ürünleri'),
    );

    expect(result.name, 'Boya Ürünleri');
    expect(cubit.state.status, ConsumableStatus.loaded);
  });
}
