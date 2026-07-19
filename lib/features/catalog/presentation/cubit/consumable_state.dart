import '../../data/dto/consumable_group_dto.dart';
import '../../data/dto/consumable_product_dto.dart';

enum ConsumableStatus { loading, loaded, error }

class ConsumableState {
  const ConsumableState({
    this.status = ConsumableStatus.loading,
    this.groups = const <ConsumableGroupDto>[],
    this.products = const <ConsumableProductDto>[],
    this.selectedGroupId,
    this.brandFilter,
    this.errorMessage,
  });

  final ConsumableStatus status;
  final List<ConsumableGroupDto> groups;
  final List<ConsumableProductDto> products;
  final int? selectedGroupId;
  final String? brandFilter;
  final String? errorMessage;
}
