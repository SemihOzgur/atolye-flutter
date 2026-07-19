import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_file_dto.freezed.dart';
part 'media_file_dto.g.dart';

@freezed
class MediaFileDto with _$MediaFileDto {
  const factory MediaFileDto({
    required int id,
    required String mediaType,
    required String stage,
    required String viewUrl,
    required DateTime createdAt,
  }) = _MediaFileDto;

  factory MediaFileDto.fromJson(Map<String, dynamic> json) =>
      _$MediaFileDtoFromJson(json);
}
