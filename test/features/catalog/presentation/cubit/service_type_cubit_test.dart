import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/catalog/data/dto/create_service_type_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/service_type_dto.dart';
import 'package:leather_care_admin/features/catalog/presentation/cubit/service_type_cubit.dart';
import 'package:leather_care_admin/features/catalog/presentation/cubit/service_type_state.dart';

import '../../fakes/fake_catalog_repository.dart';

void main() {
  late FakeCatalogRepository repository;
  late ServiceTypeCubit cubit;

  setUp(() {
    repository = FakeCatalogRepository();
    cubit = ServiceTypeCubit(repository);
  });

  tearDown(() {
    cubit.close();
  });

  const serviceTypes = [
    ServiceTypeDto(id: 1, name: 'Bakım', sortOrder: 0, isActive: true),
    ServiceTypeDto(id: 2, name: 'Boya', sortOrder: 1, isActive: true),
  ];

  test('load populates items on success', () async {
    repository.serviceTypesToReturn = serviceTypes;

    await cubit.load();

    expect(cubit.state.status, ServiceTypeStatus.loaded);
    expect(cubit.state.items, serviceTypes);
  });

  test('load emits error state on failure', () async {
    repository.exceptionToThrow = ApiException(
      message: 'Sunucu hatası',
      detail: 'Hizmet türleri yüklenemedi.',
      statusCode: 500,
    );

    await cubit.load();

    expect(cubit.state.status, ServiceTypeStatus.error);
    expect(cubit.state.errorMessage, 'Hizmet türleri yüklenemedi.');
  });

  test('create adds new service type then reloads', () async {
    repository.serviceTypesToReturn = serviceTypes;
    repository.serviceTypeResultToReturn = const ServiceTypeDto(
      id: 3,
      name: 'Bakım ve Boya',
      sortOrder: 2,
      isActive: true,
    );

    final result = await cubit.create(
      const CreateServiceTypeRequestDto(name: 'Bakım ve Boya', sortOrder: 2),
    );

    expect(result.name, 'Bakım ve Boya');
    expect(cubit.state.items, serviceTypes);
  });
}
