import 'package:freezed_annotation/freezed_annotation.dart';

import 'service_price_option_dto.dart';

part 'category_services_dto.freezed.dart';
part 'category_services_dto.g.dart';

@freezed
class CategoryServicesDto with _$CategoryServicesDto {
  const factory CategoryServicesDto({
    required int categoryId,
    required String categoryPath,
    @Default(<ServicePriceOptionDto>[]) List<ServicePriceOptionDto> services,
  }) = _CategoryServicesDto;

  factory CategoryServicesDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryServicesDtoFromJson(json);
}
