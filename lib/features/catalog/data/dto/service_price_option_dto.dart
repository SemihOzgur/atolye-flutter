import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_price_option_dto.freezed.dart';
part 'service_price_option_dto.g.dart';

@freezed
class ServicePriceOptionDto with _$ServicePriceOptionDto {
  const factory ServicePriceOptionDto({
    required int servicePriceId,
    required String serviceName,
    required double price,
  }) = _ServicePriceOptionDto;

  factory ServicePriceOptionDto.fromJson(Map<String, dynamic> json) =>
      _$ServicePriceOptionDtoFromJson(json);
}
