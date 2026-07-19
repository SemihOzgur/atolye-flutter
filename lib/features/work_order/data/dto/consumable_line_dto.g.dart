// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumable_line_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConsumableLineDtoImpl _$$ConsumableLineDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ConsumableLineDtoImpl(
      consumableProductId: (json['consumableProductId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$ConsumableLineDtoImplToJson(
        _$ConsumableLineDtoImpl instance) =>
    <String, dynamic>{
      'consumableProductId': instance.consumableProductId,
      'quantity': instance.quantity,
    };
