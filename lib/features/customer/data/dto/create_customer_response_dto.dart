import 'package:freezed_annotation/freezed_annotation.dart';

import 'customer_dto.dart';

part 'create_customer_response_dto.freezed.dart';
part 'create_customer_response_dto.g.dart';

@freezed
class CreateCustomerResponseDto with _$CreateCustomerResponseDto {
  const factory CreateCustomerResponseDto({
    required CustomerDto customer,
    required DateTime iysCodeExpiresAt,
  }) = _CreateCustomerResponseDto;

  factory CreateCustomerResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerResponseDtoFromJson(json);
}
