// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerDtoImpl _$$CustomerDtoImplFromJson(Map<String, dynamic> json) =>
    _$CustomerDtoImpl(
      id: (json['id'] as num).toInt(),
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      iysConsentStatus: json['iysConsentStatus'] as String,
      iysConsentAt: json['iysConsentAt'] == null
          ? null
          : DateTime.parse(json['iysConsentAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CustomerDtoImplToJson(_$CustomerDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'iysConsentStatus': instance.iysConsentStatus,
      'iysConsentAt': instance.iysConsentAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
