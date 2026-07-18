// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_detail_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerDetailDtoImpl _$$CustomerDetailDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomerDetailDtoImpl(
      customer: CustomerDto.fromJson(json['customer'] as Map<String, dynamic>),
      workOrders: (json['workOrders'] as List<dynamic>?)
              ?.map((e) =>
                  WorkOrderListItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkOrderListItemDto>[],
    );

Map<String, dynamic> _$$CustomerDetailDtoImplToJson(
        _$CustomerDetailDtoImpl instance) =>
    <String, dynamic>{
      'customer': instance.customer,
      'workOrders': instance.workOrders,
    };
