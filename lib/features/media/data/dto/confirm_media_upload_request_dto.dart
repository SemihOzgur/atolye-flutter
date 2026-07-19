import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_media_upload_request_dto.freezed.dart';
part 'confirm_media_upload_request_dto.g.dart';

@freezed
class ConfirmMediaUploadRequestDto with _$ConfirmMediaUploadRequestDto {
  const factory ConfirmMediaUploadRequestDto({
    required int mediaFileId,
  }) = _ConfirmMediaUploadRequestDto;

  factory ConfirmMediaUploadRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ConfirmMediaUploadRequestDtoFromJson(json);
}
