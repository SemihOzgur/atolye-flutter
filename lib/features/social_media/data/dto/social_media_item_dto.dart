import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../work_order/data/dto/media_file_dto.dart';

part 'social_media_item_dto.freezed.dart';
part 'social_media_item_dto.g.dart';

@freezed
class SocialMediaItemDto with _$SocialMediaItemDto {
  const factory SocialMediaItemDto({
    required int workOrderId,
    required String orderNumber,
    required String status,
    required String categoryPath,
    String? brand,
    required DateTime socialMediaConsentAt,
    required List<MediaFileDto> beforeMedia,
    required List<MediaFileDto> afterMedia,
  }) = _SocialMediaItemDto;

  factory SocialMediaItemDto.fromJson(Map<String, dynamic> json) =>
      _$SocialMediaItemDtoFromJson(json);
}
