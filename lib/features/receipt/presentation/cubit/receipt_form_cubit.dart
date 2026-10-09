import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../../catalog/data/catalog_repository.dart';
import '../../../catalog/data/dto/category_tree_dto.dart';
import '../../../catalog/data/dto/consumable_group_dto.dart';
import '../../../catalog/data/dto/consumable_product_dto.dart';
import '../../../catalog/data/dto/service_price_option_dto.dart';
import '../../../customer/data/customer_repository.dart';
import '../../../customer/data/dto/customer_detail_dto.dart';
import '../../../customer/data/dto/customer_dto.dart';
import '../../data/dto/create_receipt_request_dto.dart';
import '../../data/dto/receipt_dto.dart';
import '../../data/receipt_repository.dart';

enum ReceiptFormSubmitStatus { idle, submitting, failure }

class ReceiptFormState {
  const ReceiptFormState({
    this.customer,
    this.categoryTree = const <CategoryTreeDto>[],
    this.consumableGroups = const <ConsumableGroupDto>[],
    this.submitStatus = ReceiptFormSubmitStatus.idle,
    this.errorMessage,
  });

  final CustomerDto? customer;
  final List<CategoryTreeDto> categoryTree;
  final List<ConsumableGroupDto> consumableGroups;
  final ReceiptFormSubmitStatus submitStatus;
  final String? errorMessage;

  ReceiptFormState copyWith({
    CustomerDto? customer,
    List<CategoryTreeDto>? categoryTree,
    List<ConsumableGroupDto>? consumableGroups,
    ReceiptFormSubmitStatus? submitStatus,
    String? errorMessage,
  }) {
    return ReceiptFormState(
      customer: customer ?? this.customer,
      categoryTree: categoryTree ?? this.categoryTree,
      consumableGroups: consumableGroups ?? this.consumableGroups,
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: errorMessage,
    );
  }
}

/// Yeni Fiş formu: katalog verisini yükler ve fişi tek istekte gönderir.
/// Kalem taslakları (controller'lar) sayfanın state'inde yaşar.
class ReceiptFormCubit extends Cubit<ReceiptFormState> {
  ReceiptFormCubit(
    this._catalogRepository,
    this._receiptRepository,
    this._customerRepository,
  ) : super(const ReceiptFormState());

  final ICatalogRepository _catalogRepository;
  final IReceiptRepository _receiptRepository;
  final ICustomerRepository _customerRepository;

  Future<void> load(int customerId) async {
    try {
      final results = await Future.wait([
        _catalogRepository.fetchCategoryTree(),
        _catalogRepository.fetchConsumableGroups(),
        _customerRepository.fetchDetail(customerId),
      ]);
      if (isClosed) return;
      emit(
        state.copyWith(
          categoryTree: results[0] as List<CategoryTreeDto>,
          consumableGroups: results[1] as List<ConsumableGroupDto>,
          customer: (results[2] as CustomerDetailDto).customer,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(errorMessage: e.detail ?? e.message));
    }
  }

  Future<List<ServicePriceOptionDto>> servicesFor(int categoryId) async {
    final result = await _catalogRepository.fetchCategoryServices(categoryId);
    return result.services;
  }

  Future<List<ConsumableProductDto>> consumableProducts({int? groupId}) =>
      _catalogRepository.fetchConsumableProducts(groupId: groupId);

  Future<ReceiptDto?> submit(CreateReceiptRequestDto request) async {
    emit(
      state.copyWith(
        submitStatus: ReceiptFormSubmitStatus.submitting,
        errorMessage: null,
      ),
    );
    try {
      final receipt = await _receiptRepository.create(request);
      if (!isClosed) {
        emit(state.copyWith(submitStatus: ReceiptFormSubmitStatus.idle));
      }
      return receipt;
    } on ApiException catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            submitStatus: ReceiptFormSubmitStatus.failure,
            errorMessage: e.detail ?? e.message,
          ),
        );
      }
      return null;
    }
  }
}
