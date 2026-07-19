import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_price_dto.freezed.dart';
part 'service_price_dto.g.dart';

@freezed
class ServicePriceDto with _$ServicePriceDto {
  const factory ServicePriceDto({
    required int id,
    required int categoryId,
    required String categoryPath,
    required int serviceTypeId,
    required String serviceName,
    required double price,
    required bool isActive,
  }) = _ServicePriceDto;

  factory ServicePriceDto.fromJson(Map<String, dynamic> json) =>
      _$ServicePriceDtoFromJson(json);
}
