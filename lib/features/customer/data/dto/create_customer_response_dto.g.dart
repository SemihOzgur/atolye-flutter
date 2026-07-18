// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_customer_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateCustomerResponseDtoImpl _$$CreateCustomerResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateCustomerResponseDtoImpl(
      customer: CustomerDto.fromJson(json['customer'] as Map<String, dynamic>),
      iysCodeExpiresAt: DateTime.parse(json['iysCodeExpiresAt'] as String),
    );

Map<String, dynamic> _$$CreateCustomerResponseDtoImplToJson(
        _$CreateCustomerResponseDtoImpl instance) =>
    <String, dynamic>{
      'customer': instance.customer,
      'iysCodeExpiresAt': instance.iysCodeExpiresAt.toIso8601String(),
    };
