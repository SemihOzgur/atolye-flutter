// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iys_confirm_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IysConfirmResponseDtoImpl _$$IysConfirmResponseDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$IysConfirmResponseDtoImpl(
      iysConsentStatus: json['iysConsentStatus'] as String,
      iysReferenceId: json['iysReferenceId'] as String?,
    );

Map<String, dynamic> _$$IysConfirmResponseDtoImplToJson(
        _$IysConfirmResponseDtoImpl instance) =>
    <String, dynamic>{
      'iysConsentStatus': instance.iysConsentStatus,
      'iysReferenceId': instance.iysReferenceId,
    };
