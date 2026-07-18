import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_customer_request_dto.freezed.dart';
part 'update_customer_request_dto.g.dart';

@freezed
class UpdateCustomerRequestDto with _$UpdateCustomerRequestDto {
  const factory UpdateCustomerRequestDto({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    String? address,
  }) = _UpdateCustomerRequestDto;

  factory UpdateCustomerRequestDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateCustomerRequestDtoFromJson(json);
}
