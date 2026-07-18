import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_customer_request_dto.freezed.dart';
part 'create_customer_request_dto.g.dart';

@freezed
class CreateCustomerRequestDto with _$CreateCustomerRequestDto {
  const factory CreateCustomerRequestDto({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    String? address,
  }) = _CreateCustomerRequestDto;

  factory CreateCustomerRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomerRequestDtoFromJson(json);
}
