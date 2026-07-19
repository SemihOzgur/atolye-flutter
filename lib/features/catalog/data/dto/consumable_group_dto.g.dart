// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumable_group_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConsumableGroupDtoImpl _$$ConsumableGroupDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConsumableGroupDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$ConsumableGroupDtoImplToJson(
        _$ConsumableGroupDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
    };
