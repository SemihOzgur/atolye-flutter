// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_service_type_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateServiceTypeRequestDtoImpl _$$CreateServiceTypeRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateServiceTypeRequestDtoImpl(
      name: json['name'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
    );

Map<String, dynamic> _$$CreateServiceTypeRequestDtoImplToJson(
        _$CreateServiceTypeRequestDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sortOrder': instance.sortOrder,
    };
