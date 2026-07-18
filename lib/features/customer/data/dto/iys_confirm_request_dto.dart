import 'package:freezed_annotation/freezed_annotation.dart';

part 'iys_confirm_request_dto.freezed.dart';
part 'iys_confirm_request_dto.g.dart';

@freezed
class IysConfirmRequestDto with _$IysConfirmRequestDto {
  const factory IysConfirmRequestDto({
    required String code,
  }) = _IysConfirmRequestDto;

  factory IysConfirmRequestDto.fromJson(Map<String, dynamic> json) =>
      _$IysConfirmRequestDtoFromJson(json);
}
