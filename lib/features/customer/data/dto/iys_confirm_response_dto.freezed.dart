// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iys_confirm_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IysConfirmResponseDto _$IysConfirmResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _IysConfirmResponseDto.fromJson(json);
}

/// @nodoc
mixin _$IysConfirmResponseDto {
  String get iysConsentStatus => throw _privateConstructorUsedError;
  String? get iysReferenceId => throw _privateConstructorUsedError;

  /// Serializes this IysConfirmResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IysConfirmResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IysConfirmResponseDtoCopyWith<IysConfirmResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IysConfirmResponseDtoCopyWith<$Res> {
  factory $IysConfirmResponseDtoCopyWith(IysConfirmResponseDto value,
          $Res Function(IysConfirmResponseDto) then) =
      _$IysConfirmResponseDtoCopyWithImpl<$Res, IysConfirmResponseDto>;
  @useResult
  $Res call({String iysConsentStatus, String? iysReferenceId});
}

/// @nodoc
class _$IysConfirmResponseDtoCopyWithImpl<$Res,
        $Val extends IysConfirmResponseDto>
    implements $IysConfirmResponseDtoCopyWith<$Res> {
  _$IysConfirmResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IysConfirmResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iysConsentStatus = null,
    Object? iysReferenceId = freezed,
  }) {
    return _then(_value.copyWith(
      iysConsentStatus: null == iysConsentStatus
          ? _value.iysConsentStatus
          : iysConsentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      iysReferenceId: freezed == iysReferenceId
          ? _value.iysReferenceId
          : iysReferenceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IysConfirmResponseDtoImplCopyWith<$Res>
    implements $IysConfirmResponseDtoCopyWith<$Res> {
  factory _$$IysConfirmResponseDtoImplCopyWith(
          _$IysConfirmResponseDtoImpl value,
          $Res Function(_$IysConfirmResponseDtoImpl) then) =
      __$$IysConfirmResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String iysConsentStatus, String? iysReferenceId});
}

/// @nodoc
class __$$IysConfirmResponseDtoImplCopyWithImpl<$Res>
    extends _$IysConfirmResponseDtoCopyWithImpl<$Res,
        _$IysConfirmResponseDtoImpl>
    implements _$$IysConfirmResponseDtoImplCopyWith<$Res> {
  __$$IysConfirmResponseDtoImplCopyWithImpl(_$IysConfirmResponseDtoImpl _value,
      $Res Function(_$IysConfirmResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of IysConfirmResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? iysConsentStatus = null,
    Object? iysReferenceId = freezed,
  }) {
    return _then(_$IysConfirmResponseDtoImpl(
      iysConsentStatus: null == iysConsentStatus
          ? _value.iysConsentStatus
          : iysConsentStatus // ignore: cast_nullable_to_non_nullable
              as String,
      iysReferenceId: freezed == iysReferenceId
          ? _value.iysReferenceId
          : iysReferenceId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IysConfirmResponseDtoImpl implements _IysConfirmResponseDto {
  const _$IysConfirmResponseDtoImpl(
      {required this.iysConsentStatus, this.iysReferenceId});

  factory _$IysConfirmResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$IysConfirmResponseDtoImplFromJson(json);

  @override
  final String iysConsentStatus;
  @override
  final String? iysReferenceId;

  @override
  String toString() {
    return 'IysConfirmResponseDto(iysConsentStatus: $iysConsentStatus, iysReferenceId: $iysReferenceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IysConfirmResponseDtoImpl &&
            (identical(other.iysConsentStatus, iysConsentStatus) ||
                other.iysConsentStatus == iysConsentStatus) &&
            (identical(other.iysReferenceId, iysReferenceId) ||
                other.iysReferenceId == iysReferenceId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, iysConsentStatus, iysReferenceId);

  /// Create a copy of IysConfirmResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IysConfirmResponseDtoImplCopyWith<_$IysConfirmResponseDtoImpl>
      get copyWith => __$$IysConfirmResponseDtoImplCopyWithImpl<
          _$IysConfirmResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IysConfirmResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _IysConfirmResponseDto implements IysConfirmResponseDto {
  const factory _IysConfirmResponseDto(
      {required final String iysConsentStatus,
      final String? iysReferenceId}) = _$IysConfirmResponseDtoImpl;

  factory _IysConfirmResponseDto.fromJson(Map<String, dynamic> json) =
      _$IysConfirmResponseDtoImpl.fromJson;

  @override
  String get iysConsentStatus;
  @override
  String? get iysReferenceId;

  /// Create a copy of IysConfirmResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IysConfirmResponseDtoImplCopyWith<_$IysConfirmResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
