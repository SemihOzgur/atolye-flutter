// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_type_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceTypeDtoImpl _$$ServiceTypeDtoImplFromJson(Map<String, dynamic> json) =>
    _$ServiceTypeDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$ServiceTypeDtoImplToJson(
        _$ServiceTypeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
    };
