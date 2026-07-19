// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_services_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryServicesDtoImpl _$$CategoryServicesDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryServicesDtoImpl(
      categoryId: (json['categoryId'] as num).toInt(),
      categoryPath: json['categoryPath'] as String,
      services: (json['services'] as List<dynamic>?)
              ?.map((e) =>
                  ServicePriceOptionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ServicePriceOptionDto>[],
    );

Map<String, dynamic> _$$CategoryServicesDtoImplToJson(
        _$CategoryServicesDtoImpl instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'categoryPath': instance.categoryPath,
      'services': instance.services,
    };
