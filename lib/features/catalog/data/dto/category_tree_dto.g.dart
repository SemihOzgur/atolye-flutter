// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_tree_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryTreeDtoImpl _$$CategoryTreeDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryTreeDtoImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      level: (json['level'] as num).toInt(),
      isActive: json['isActive'] as bool,
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => CategoryTreeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CategoryTreeDto>[],
    );

Map<String, dynamic> _$$CategoryTreeDtoImplToJson(
        _$CategoryTreeDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'level': instance.level,
      'isActive': instance.isActive,
      'children': instance.children,
    };
