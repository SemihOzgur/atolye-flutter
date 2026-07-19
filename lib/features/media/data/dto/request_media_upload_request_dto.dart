import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_media_upload_request_dto.freezed.dart';
part 'request_media_upload_request_dto.g.dart';

@freezed
class RequestMediaUploadRequestDto with _$RequestMediaUploadRequestDto {
  const factory RequestMediaUploadRequestDto({
    required String mediaType,
    required String stage,
    required String fileName,
    required String mimeType,
    required int sizeBytes,
  }) = _RequestMediaUploadRequestDto;

  factory RequestMediaUploadRequestDto.fromJson(Map<String, dynamic> json) =>
      _$RequestMediaUploadRequestDtoFromJson(json);
}
