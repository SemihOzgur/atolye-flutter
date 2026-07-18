// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iys_resend_code_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IysResendCodeResponseDto _$IysResendCodeResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _IysResendCodeResponseDto.fromJson(json);
}

/// @nodoc
mixin _$IysResendCodeResponseDto {
  int get customerId => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this IysResendCodeResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IysResendCodeResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IysResendCodeResponseDtoCopyWith<IysResendCodeResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IysResendCodeResponseDtoCopyWith<$Res> {
  factory $IysResendCodeResponseDtoCopyWith(IysResendCodeResponseDto value,
          $Res Function(IysResendCodeResponseDto) then) =
      _$IysResendCodeResponseDtoCopyWithImpl<$Res, IysResendCodeResponseDto>;
  @useResult
  $Res call({int customerId, DateTime expiresAt});
}

/// @nodoc
class _$IysResendCodeResponseDtoCopyWithImpl<$Res,
        $Val extends IysResendCodeResponseDto>
    implements $IysResendCodeResponseDtoCopyWith<$Res> {
  _$IysResendCodeResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IysResendCodeResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? expiresAt = null,
  }) {
    return _then(_value.copyWith(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IysResendCodeResponseDtoImplCopyWith<$Res>
    implements $IysResendCodeResponseDtoCopyWith<$Res> {
  factory _$$IysResendCodeResponseDtoImplCopyWith(
          _$IysResendCodeResponseDtoImpl value,
          $Res Function(_$IysResendCodeResponseDtoImpl) then) =
      __$$IysResendCodeResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int customerId, DateTime expiresAt});
}

/// @nodoc
class __$$IysResendCodeResponseDtoImplCopyWithImpl<$Res>
    extends _$IysResendCodeResponseDtoCopyWithImpl<$Res,
        _$IysResendCodeResponseDtoImpl>
    implements _$$IysResendCodeResponseDtoImplCopyWith<$Res> {
  __$$IysResendCodeResponseDtoImplCopyWithImpl(
      _$IysResendCodeResponseDtoImpl _value,
      $Res Function(_$IysResendCodeResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of IysResendCodeResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? expiresAt = null,
  }) {
    return _then(_$IysResendCodeResponseDtoImpl(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IysResendCodeResponseDtoImpl implements _IysResendCodeResponseDto {
  const _$IysResendCodeResponseDtoImpl(
      {required this.customerId, required this.expiresAt});

  factory _$IysResendCodeResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$IysResendCodeResponseDtoImplFromJson(json);

  @override
  final int customerId;
  @override
  final DateTime expiresAt;

  @override
  String toString() {
    return 'IysResendCodeResponseDto(customerId: $customerId, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IysResendCodeResponseDtoImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, customerId, expiresAt);

  /// Create a copy of IysResendCodeResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IysResendCodeResponseDtoImplCopyWith<_$IysResendCodeResponseDtoImpl>
      get copyWith => __$$IysResendCodeResponseDtoImplCopyWithImpl<
          _$IysResendCodeResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IysResendCodeResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _IysResendCodeResponseDto implements IysResendCodeResponseDto {
  const factory _IysResendCodeResponseDto(
      {required final int customerId,
      required final DateTime expiresAt}) = _$IysResendCodeResponseDtoImpl;

  factory _IysResendCodeResponseDto.fromJson(Map<String, dynamic> json) =
      _$IysResendCodeResponseDtoImpl.fromJson;

  @override
  int get customerId;
  @override
  DateTime get expiresAt;

  /// Create a copy of IysResendCodeResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IysResendCodeResponseDtoImplCopyWith<_$IysResendCodeResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
