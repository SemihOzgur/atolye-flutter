import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_services_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_tree_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/service_price_option_dto.dart';
import 'package:leather_care_admin/features/customer/data/dto/customer_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/create_work_order_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/update_work_order_request_dto.dart';
import 'package:leather_care_admin/features/work_order/data/dto/work_order_dto.dart';
import 'package:leather_care_admin/features/work_order/presentation/cubit/work_order_form_cubit.dart';
import 'package:leather_care_admin/features/work_order/presentation/cubit/work_order_form_state.dart';

import '../../../catalog/fakes/fake_catalog_repository.dart';
import '../../fakes/fake_work_order_repository.dart';

void main() {
  late FakeCatalogRepository catalogRepository;
  late FakeWorkOrderRepository workOrderRepository;
  late WorkOrderFormCubit cubit;

  setUp(() {
    catalogRepository = FakeCatalogRepository();
    workOrderRepository = FakeWorkOrderRepository();
    cubit = WorkOrderFormCubit(catalogRepository, workOrderRepository);
  });

  tearDown(() {
    cubit.close();
  });

  const tree = [
    CategoryTreeDto(id: 1, name: 'Kadın', level: 1, isActive: true),
  ];

  test('loadCategoryTree populates tree', () async {
    catalogRepository.treeToReturn = tree;

    await cubit.loadCategoryTree();

    expect(cubit.state.categoryTree, tree);
  });

  test('selectCategory fetches available services for the category', () async {
    catalogRepository.categoryServicesToReturn = const CategoryServicesDto(
      categoryId: 3,
      categoryPath: 'Kadın > Ayakkabı > Sneakers',
      services: [
        ServicePriceOptionDto(
          servicePriceId: 1,
          serviceName: 'Bakım ve Boya',
          price: 1250,
        ),
      ],
    );

    await cubit.selectCategory(3, 'Kadın > Ayakkabı > Sneakers');

    expect(cubit.state.selectedCategoryId, 3);
    expect(cubit.state.availableServices.single.serviceName, 'Bakım ve Boya');
  });

  test('submit creates work order on success', () async {
    workOrderRepository.workOrderToReturn = WorkOrderDto(
      id: 5,
      orderNumber: 'WO-2026-000005',
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
      status: 'RECEIVED',
      socialMediaConsent: false,
      trackingUrl: 'https://domain.com/t/abc',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

    final result = await cubit.submit(
      const CreateWorkOrderRequestDto(
        customerId: 1,
        categoryId: 3,
        servicePriceIds: [1],
        price: 1550,
        hasPrepayment: false,
      ),
    );

    expect(result!.id, 5);
    expect(cubit.state.submitStatus, WorkOrderFormSubmitStatus.idle);
  });

  test('submit emits failure with field errors on validation error', () async {
    workOrderRepository.exceptionToThrow = ApiException(
      message: 'Validation failed',
      detail: 'Ön ödeme tutarı nihai fiyatı aşamaz.',
      statusCode: 400,
      fieldErrors: {
        'prepaymentAmount': ['Ön ödeme tutarı nihai fiyatı aşamaz.'],
      },
    );

    final result = await cubit.submit(
      const CreateWorkOrderRequestDto(
        customerId: 1,
        categoryId: 3,
        price: 100,
        hasPrepayment: true,
        prepaymentAmount: 200,
      ),
    );

    expect(result, isNull);
    expect(cubit.state.submitStatus, WorkOrderFormSubmitStatus.failure);
    expect(cubit.state.fieldErrors['prepaymentAmount'], isNotNull);
  });

  test('submitUpdate sends update with concurrency token', () async {
    workOrderRepository.workOrderToReturn = WorkOrderDto(
      id: 5,
      orderNumber: 'WO-2026-000005',
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
      price: 1600,
      hasPrepayment: false,
      remainingAmount: 1600,
      status: 'RECEIVED',
      socialMediaConsent: false,
      trackingUrl: 'https://domain.com/t/abc',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 2),
    );

    final result = await cubit.submitUpdate(
      5,
      UpdateWorkOrderRequestDto(
        price: 1600,
        hasPrepayment: false,
        updatedAt: DateTime(2026, 1, 1),
      ),
    );

    expect(result!.price, 1600);
  });

  test('submitUpdate surfaces 409 as failure for stale concurrency token', () async {
    workOrderRepository.exceptionToThrow = ApiException(
      message: 'Conflict',
      detail: 'Kayıt başka yerden güncellendi.',
      statusCode: 409,
    );

    final result = await cubit.submitUpdate(
      5,
      UpdateWorkOrderRequestDto(
        price: 1600,
        hasPrepayment: false,
        updatedAt: DateTime(2026, 1, 1),
      ),
    );

    expect(result, isNull);
    expect(cubit.state.submitStatus, WorkOrderFormSubmitStatus.failure);
    expect(cubit.state.errorMessage, 'Kayıt başka yerden güncellendi.');
  });
}
