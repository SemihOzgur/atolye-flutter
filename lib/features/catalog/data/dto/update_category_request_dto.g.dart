// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_category_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateCategoryRequestDtoImpl _$$UpdateCategoryRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateCategoryRequestDtoImpl(
      name: json['name'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$UpdateCategoryRequestDtoImplToJson(
        _$UpdateCategoryRequestDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
    };
