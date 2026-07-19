import 'package:freezed_annotation/freezed_annotation.dart';

part 'archive_media_item_dto.freezed.dart';
part 'archive_media_item_dto.g.dart';

@freezed
class ArchiveMediaItemDto with _$ArchiveMediaItemDto {
  const factory ArchiveMediaItemDto({
    required int mediaId,
    required String stage,
    required String mediaType,
    required String fileName,
    required int sizeBytes,
    required String downloadUrl,
  }) = _ArchiveMediaItemDto;

  factory ArchiveMediaItemDto.fromJson(Map<String, dynamic> json) =>
      _$ArchiveMediaItemDtoFromJson(json);
}
