import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_media_upload_response_dto.freezed.dart';
part 'request_media_upload_response_dto.g.dart';

@freezed
class RequestMediaUploadResponseDto with _$RequestMediaUploadResponseDto {
  const factory RequestMediaUploadResponseDto({
    required int mediaFileId,
    required String uploadUrl,
    required DateTime expiresAt,
  }) = _RequestMediaUploadResponseDto;

  factory RequestMediaUploadResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RequestMediaUploadResponseDtoFromJson(json);
}
