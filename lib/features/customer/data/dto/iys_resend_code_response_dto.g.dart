// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iys_resend_code_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IysResendCodeResponseDtoImpl _$$IysResendCodeResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$IysResendCodeResponseDtoImpl(
      customerId: (json['customerId'] as num).toInt(),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$IysResendCodeResponseDtoImplToJson(
        _$IysResendCodeResponseDtoImpl instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };
