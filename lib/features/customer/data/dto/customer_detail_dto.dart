import 'package:freezed_annotation/freezed_annotation.dart';

import 'customer_dto.dart';
import 'work_order_list_item_dto.dart';

part 'customer_detail_dto.freezed.dart';
part 'customer_detail_dto.g.dart';

@freezed
class CustomerDetailDto with _$CustomerDetailDto {
  const factory CustomerDetailDto({
    required CustomerDto customer,
    @Default(<WorkOrderListItemDto>[])
    List<WorkOrderListItemDto> workOrders,
  }) = _CustomerDetailDto;

  factory CustomerDetailDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDetailDtoFromJson(json);
}
