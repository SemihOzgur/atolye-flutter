// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_media_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialMediaItemDtoImpl _$$SocialMediaItemDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialMediaItemDtoImpl(
      workOrderId: (json['workOrderId'] as num).toInt(),
      orderNumber: json['orderNumber'] as String,
      status: json['status'] as String,
      categoryPath: json['categoryPath'] as String,
      brand: json['brand'] as String?,
      socialMediaConsentAt:
          DateTime.parse(json['socialMediaConsentAt'] as String),
      beforeMedia: (json['beforeMedia'] as List<dynamic>)
          .map((e) => MediaFileDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      afterMedia: (json['afterMedia'] as List<dynamic>)
          .map((e) => MediaFileDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SocialMediaItemDtoImplToJson(
        _$SocialMediaItemDtoImpl instance) =>
    <String, dynamic>{
      'workOrderId': instance.workOrderId,
      'orderNumber': instance.orderNumber,
      'status': instance.status,
      'categoryPath': instance.categoryPath,
      'brand': instance.brand,
      'socialMediaConsentAt': instance.socialMediaConsentAt.toIso8601String(),
      'beforeMedia': instance.beforeMedia,
      'afterMedia': instance.afterMedia,
    };
