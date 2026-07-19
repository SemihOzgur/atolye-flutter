// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_service_type_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateServiceTypeRequestDtoImpl _$$UpdateServiceTypeRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateServiceTypeRequestDtoImpl(
      name: json['name'] as String,
      sortOrder: (json['sortOrder'] as num).toInt(),
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$UpdateServiceTypeRequestDtoImplToJson(
        _$UpdateServiceTypeRequestDtoImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sortOrder': instance.sortOrder,
      'isActive': instance.isActive,
    };
