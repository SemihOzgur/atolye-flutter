import 'package:freezed_annotation/freezed_annotation.dart';

part 'iys_resend_code_response_dto.freezed.dart';
part 'iys_resend_code_response_dto.g.dart';

@freezed
class IysResendCodeResponseDto with _$IysResendCodeResponseDto {
  const factory IysResendCodeResponseDto({
    required int customerId,
    required DateTime expiresAt,
  }) = _IysResendCodeResponseDto;

  factory IysResendCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$IysResendCodeResponseDtoFromJson(json);
}
