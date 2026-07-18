import 'package:freezed_annotation/freezed_annotation.dart';

part 'iys_confirm_response_dto.freezed.dart';
part 'iys_confirm_response_dto.g.dart';

@freezed
class IysConfirmResponseDto with _$IysConfirmResponseDto {
  const factory IysConfirmResponseDto({
    required String iysConsentStatus,
    String? iysReferenceId,
  }) = _IysConfirmResponseDto;

  factory IysConfirmResponseDto.fromJson(Map<String, dynamic> json) =>
      _$IysConfirmResponseDtoFromJson(json);
}
