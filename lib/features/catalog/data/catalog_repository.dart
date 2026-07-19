import 'package:dio/dio.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/network/api_exception.dart';
import 'dto/bulk_upsert_service_prices_request_dto.dart';
import 'dto/category_dto.dart';
import 'dto/category_services_dto.dart';
import 'dto/category_tree_dto.dart';
import 'dto/consumable_group_dto.dart';
import 'dto/consumable_product_dto.dart';
import 'dto/create_category_request_dto.dart';
import 'dto/create_consumable_group_request_dto.dart';
import 'dto/create_consumable_product_request_dto.dart';
import 'dto/create_service_type_request_dto.dart';
import 'dto/service_price_dto.dart';
import 'dto/service_type_dto.dart';
import 'dto/update_category_request_dto.dart';
import 'dto/update_consumable_group_request_dto.dart';
import 'dto/update_consumable_product_request_dto.dart';
import 'dto/update_service_type_request_dto.dart';
import 'dto/upsert_service_price_request_dto.dart';

abstract class ICatalogRepository {
  Future<List<CategoryTreeDto>> fetchCategoryTree({bool includeInactive = false});

  Future<CategoryDto> createCategory(CreateCategoryRequestDto request);

  Future<CategoryDto> updateCategory(int id, UpdateCategoryRequestDto request);

  Future<CategoryServicesDto> fetchCategoryServices(int categoryId);

  Future<List<ServiceTypeDto>> fetchServiceTypes();

  Future<ServiceTypeDto> createServiceType(CreateServiceTypeRequestDto request);

  Future<ServiceTypeDto> updateServiceType(
    int id,
    UpdateServiceTypeRequestDto request,
  );

  Future<List<ServicePriceDto>> fetchServicePrices({int? categoryId});

  Future<List<ServicePriceDto>> bulkUpsertServicePrices(
    List<UpsertServicePriceRequestDto> items,
  );

  Future<List<ConsumableGroupDto>> fetchConsumableGroups();

  Future<ConsumableGroupDto> createConsumableGroup(
    CreateConsumableGroupRequestDto request,
  );

  Future<ConsumableGroupDto> updateConsumableGroup(
    int id,
    UpdateConsumableGroupRequestDto request,
  );

  Future<List<ConsumableProductDto>> fetchConsumableProducts({
    int? groupId,
    String? brand,
  });

  Future<ConsumableProductDto> createConsumableProduct(
    CreateConsumableProductRequestDto request,
  );

  Future<ConsumableProductDto> updateConsumableProduct(
    int id,
    UpdateConsumableProductRequestDto request,
  );
}

class CatalogRepository implements ICatalogRepository {
  CatalogRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<CategoryTreeDto>> fetchCategoryTree({
    bool includeInactive = false,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.categoriesTree.path,
        queryParameters: <String, dynamic>{'includeInactive': includeInactive},
      );

      return response.data!
          .map((item) => CategoryTreeDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<CategoryDto> createCategory(CreateCategoryRequestDto request) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.createCategory.path,
        data: request.toJson(),
      );

      return CategoryDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<CategoryDto> updateCategory(
    int id,
    UpdateCategoryRequestDto request,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.updateCategory(id).path,
        data: request.toJson(),
      );

      return CategoryDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<CategoryServicesDto> fetchCategoryServices(int categoryId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.categoryServices(categoryId).path,
      );

      return CategoryServicesDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<List<ServiceTypeDto>> fetchServiceTypes() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.serviceTypes.path,
      );

      return response.data!
          .map((item) => ServiceTypeDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<ServiceTypeDto> createServiceType(
    CreateServiceTypeRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.createServiceType.path,
        data: request.toJson(),
      );

      return ServiceTypeDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<ServiceTypeDto> updateServiceType(
    int id,
    UpdateServiceTypeRequestDto request,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.updateServiceType(id).path,
        data: request.toJson(),
      );

      return ServiceTypeDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<List<ServicePriceDto>> fetchServicePrices({int? categoryId}) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.servicePrices.path,
        queryParameters: <String, dynamic>{
          if (categoryId != null) 'categoryId': categoryId,
        },
      );

      return response.data!
          .map((item) => ServicePriceDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<List<ServicePriceDto>> bulkUpsertServicePrices(
    List<UpsertServicePriceRequestDto> items,
  ) async {
    try {
      final response = await _dio.put<List<dynamic>>(
        ApiEndpoints.servicePricesBulk.path,
        data: BulkUpsertServicePricesRequestDto(items: items).toJson(),
      );

      return response.data!
          .map((item) => ServicePriceDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<List<ConsumableGroupDto>> fetchConsumableGroups() async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.consumableGroups.path,
      );

      return response.data!
          .map(
            (item) => ConsumableGroupDto.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<ConsumableGroupDto> createConsumableGroup(
    CreateConsumableGroupRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.createConsumableGroup.path,
        data: request.toJson(),
      );

      return ConsumableGroupDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<ConsumableGroupDto> updateConsumableGroup(
    int id,
    UpdateConsumableGroupRequestDto request,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.updateConsumableGroup(id).path,
        data: request.toJson(),
      );

      return ConsumableGroupDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<List<ConsumableProductDto>> fetchConsumableProducts({
    int? groupId,
    String? brand,
  }) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        ApiEndpoints.consumableProducts.path,
        queryParameters: <String, dynamic>{
          if (groupId != null) 'groupId': groupId,
          if (brand != null && brand.isNotEmpty) 'brand': brand,
        },
      );

      return response.data!
          .map(
            (item) => ConsumableProductDto.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<ConsumableProductDto> createConsumableProduct(
    CreateConsumableProductRequestDto request,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.createConsumableProduct.path,
        data: request.toJson(),
      );

      return ConsumableProductDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  @override
  Future<ConsumableProductDto> updateConsumableProduct(
    int id,
    UpdateConsumableProductRequestDto request,
  ) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        ApiEndpoints.updateConsumableProduct(id).path,
        data: request.toJson(),
      );

      return ConsumableProductDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}
