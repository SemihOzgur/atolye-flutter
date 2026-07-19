import 'package:leather_care_admin/core/network/api_exception.dart';
import 'package:leather_care_admin/features/catalog/data/catalog_repository.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_services_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/category_tree_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/consumable_group_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/consumable_product_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/create_category_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/create_consumable_group_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/create_consumable_product_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/create_service_type_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/service_price_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/service_type_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/update_category_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/update_consumable_group_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/update_consumable_product_request_dto.dart';
import 'package:leather_care_admin/features/catalog/data/dto/update_service_type_request_dto.dart';

class FakeCatalogRepository implements ICatalogRepository {
  List<CategoryTreeDto> treeToReturn = const [];
  CategoryDto? categoryResultToReturn;
  CategoryServicesDto? categoryServicesToReturn;
  List<ServiceTypeDto> serviceTypesToReturn = const [];
  ServiceTypeDto? serviceTypeResultToReturn;
  List<ServicePriceDto> servicePricesToReturn = const [];
  List<ServicePriceDto> bulkUpsertResultToReturn = const [];
  List<ConsumableGroupDto> consumableGroupsToReturn = const [];
  ConsumableGroupDto? consumableGroupResultToReturn;
  List<ConsumableProductDto> consumableProductsToReturn = const [];
  ConsumableProductDto? consumableProductResultToReturn;
  ApiException? exceptionToThrow;

  int? lastServicePricesCategoryId;
  List<dynamic>? lastBulkUpsertItems;
  int? lastProductsGroupId;
  String? lastProductsBrand;

  @override
  Future<List<CategoryTreeDto>> fetchCategoryTree({
    bool includeInactive = false,
  }) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return treeToReturn;
  }

  @override
  Future<CategoryDto> createCategory(CreateCategoryRequestDto request) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return categoryResultToReturn!;
  }

  @override
  Future<CategoryDto> updateCategory(
    int id,
    UpdateCategoryRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return categoryResultToReturn!;
  }

  @override
  Future<CategoryServicesDto> fetchCategoryServices(int categoryId) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return categoryServicesToReturn!;
  }

  @override
  Future<List<ServiceTypeDto>> fetchServiceTypes() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return serviceTypesToReturn;
  }

  @override
  Future<ServiceTypeDto> createServiceType(
    CreateServiceTypeRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return serviceTypeResultToReturn!;
  }

  @override
  Future<ServiceTypeDto> updateServiceType(
    int id,
    UpdateServiceTypeRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return serviceTypeResultToReturn!;
  }

  @override
  Future<List<ServicePriceDto>> fetchServicePrices({int? categoryId}) async {
    lastServicePricesCategoryId = categoryId;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return servicePricesToReturn;
  }

  @override
  Future<List<ServicePriceDto>> bulkUpsertServicePrices(
    List<dynamic> items,
  ) async {
    lastBulkUpsertItems = items;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return bulkUpsertResultToReturn;
  }

  @override
  Future<List<ConsumableGroupDto>> fetchConsumableGroups() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return consumableGroupsToReturn;
  }

  @override
  Future<ConsumableGroupDto> createConsumableGroup(
    CreateConsumableGroupRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return consumableGroupResultToReturn!;
  }

  @override
  Future<ConsumableGroupDto> updateConsumableGroup(
    int id,
    UpdateConsumableGroupRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return consumableGroupResultToReturn!;
  }

  @override
  Future<List<ConsumableProductDto>> fetchConsumableProducts({
    int? groupId,
    String? brand,
  }) async {
    lastProductsGroupId = groupId;
    lastProductsBrand = brand;
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return consumableProductsToReturn;
  }

  @override
  Future<ConsumableProductDto> createConsumableProduct(
    CreateConsumableProductRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return consumableProductResultToReturn!;
  }

  @override
  Future<ConsumableProductDto> updateConsumableProduct(
    int id,
    UpdateConsumableProductRequestDto request,
  ) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return consumableProductResultToReturn!;
  }
}
