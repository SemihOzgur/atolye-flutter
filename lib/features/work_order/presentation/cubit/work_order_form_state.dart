import '../../../catalog/data/dto/category_tree_dto.dart';
import '../../../catalog/data/dto/consumable_group_dto.dart';
import '../../../catalog/data/dto/consumable_product_dto.dart';
import '../../../catalog/data/dto/service_price_option_dto.dart';
import '../../data/dto/work_order_dto.dart';

enum WorkOrderFormSubmitStatus { idle, submitting, failure }

class WorkOrderFormState {
  const WorkOrderFormState({
    this.categoryTree = const <CategoryTreeDto>[],
    this.selectedCategoryId,
    this.selectedCategoryPath,
    this.availableServices = const <ServicePriceOptionDto>[],
    this.consumableGroups = const <ConsumableGroupDto>[],
    this.consumableProducts = const <ConsumableProductDto>[],
    this.submitStatus = WorkOrderFormSubmitStatus.idle,
    this.errorMessage,
    this.fieldErrors = const <String, List<String>>{},
    this.createdWorkOrder,
  });

  final List<CategoryTreeDto> categoryTree;
  final int? selectedCategoryId;
  final String? selectedCategoryPath;
  final List<ServicePriceOptionDto> availableServices;
  final List<ConsumableGroupDto> consumableGroups;
  final List<ConsumableProductDto> consumableProducts;
  final WorkOrderFormSubmitStatus submitStatus;
  final String? errorMessage;
  final Map<String, List<String>> fieldErrors;
  final WorkOrderDto? createdWorkOrder;

  WorkOrderFormState copyWith({
    List<CategoryTreeDto>? categoryTree,
    int? selectedCategoryId,
    String? selectedCategoryPath,
    List<ServicePriceOptionDto>? availableServices,
    List<ConsumableGroupDto>? consumableGroups,
    List<ConsumableProductDto>? consumableProducts,
    WorkOrderFormSubmitStatus? submitStatus,
    String? errorMessage,
    Map<String, List<String>>? fieldErrors,
    WorkOrderDto? createdWorkOrder,
  }) {
    return WorkOrderFormState(
      categoryTree: categoryTree ?? this.categoryTree,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryPath: selectedCategoryPath ?? this.selectedCategoryPath,
      availableServices: availableServices ?? this.availableServices,
      consumableGroups: consumableGroups ?? this.consumableGroups,
      consumableProducts: consumableProducts ?? this.consumableProducts,
      submitStatus: submitStatus ?? this.submitStatus,
      errorMessage: errorMessage,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      createdWorkOrder: createdWorkOrder ?? this.createdWorkOrder,
    );
  }
}
