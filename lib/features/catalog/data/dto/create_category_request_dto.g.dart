// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_category_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateCategoryRequestDtoImpl _$$CreateCategoryRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateCategoryRequestDtoImpl(
      parentId: (json['parentId'] as num?)?.toInt(),
      name: json['name'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$$CreateCategoryRequestDtoImplToJson(
        _$CreateCategoryRequestDtoImpl instance) =>
    <String, dynamic>{
      'parentId': instance.parentId,
      'name': instance.name,
      'sortOrder': instance.sortOrder,
    };
