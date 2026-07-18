// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_customer_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateCustomerRequestDtoImpl _$$UpdateCustomerRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateCustomerRequestDtoImpl(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$UpdateCustomerRequestDtoImplToJson(
        _$UpdateCustomerRequestDtoImpl instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
    };
