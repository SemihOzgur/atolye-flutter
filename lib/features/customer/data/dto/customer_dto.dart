import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_dto.freezed.dart';
part 'customer_dto.g.dart';

@freezed
class CustomerDto with _$CustomerDto {
  const factory CustomerDto({
    required int id,
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    String? address,
    required String iysConsentStatus,
    DateTime? iysConsentAt,
    required DateTime createdAt,
  }) = _CustomerDto;

  factory CustomerDto.fromJson(Map<String, dynamic> json) =>
      _$CustomerDtoFromJson(json);
}
