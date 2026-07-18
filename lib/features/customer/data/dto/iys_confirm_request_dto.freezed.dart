// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'iys_confirm_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IysConfirmRequestDto _$IysConfirmRequestDtoFromJson(Map<String, dynamic> json) {
  return _IysConfirmRequestDto.fromJson(json);
}

/// @nodoc
mixin _$IysConfirmRequestDto {
  String get code => throw _privateConstructorUsedError;

  /// Serializes this IysConfirmRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IysConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IysConfirmRequestDtoCopyWith<IysConfirmRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IysConfirmRequestDtoCopyWith<$Res> {
  factory $IysConfirmRequestDtoCopyWith(IysConfirmRequestDto value,
          $Res Function(IysConfirmRequestDto) then) =
      _$IysConfirmRequestDtoCopyWithImpl<$Res, IysConfirmRequestDto>;
  @useResult
  $Res call({String code});
}

/// @nodoc
class _$IysConfirmRequestDtoCopyWithImpl<$Res,
        $Val extends IysConfirmRequestDto>
    implements $IysConfirmRequestDtoCopyWith<$Res> {
  _$IysConfirmRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IysConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IysConfirmRequestDtoImplCopyWith<$Res>
    implements $IysConfirmRequestDtoCopyWith<$Res> {
  factory _$$IysConfirmRequestDtoImplCopyWith(_$IysConfirmRequestDtoImpl value,
          $Res Function(_$IysConfirmRequestDtoImpl) then) =
      __$$IysConfirmRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code});
}

/// @nodoc
class __$$IysConfirmRequestDtoImplCopyWithImpl<$Res>
    extends _$IysConfirmRequestDtoCopyWithImpl<$Res, _$IysConfirmRequestDtoImpl>
    implements _$$IysConfirmRequestDtoImplCopyWith<$Res> {
  __$$IysConfirmRequestDtoImplCopyWithImpl(_$IysConfirmRequestDtoImpl _value,
      $Res Function(_$IysConfirmRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of IysConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
  }) {
    return _then(_$IysConfirmRequestDtoImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IysConfirmRequestDtoImpl implements _IysConfirmRequestDto {
  const _$IysConfirmRequestDtoImpl({required this.code});

  factory _$IysConfirmRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$IysConfirmRequestDtoImplFromJson(json);

  @override
  final String code;

  @override
  String toString() {
    return 'IysConfirmRequestDto(code: $code)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IysConfirmRequestDtoImpl &&
            (identical(other.code, code) || other.code == code));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code);

  /// Create a copy of IysConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IysConfirmRequestDtoImplCopyWith<_$IysConfirmRequestDtoImpl>
      get copyWith =>
          __$$IysConfirmRequestDtoImplCopyWithImpl<_$IysConfirmRequestDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IysConfirmRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _IysConfirmRequestDto implements IysConfirmRequestDto {
  const factory _IysConfirmRequestDto({required final String code}) =
      _$IysConfirmRequestDtoImpl;

  factory _IysConfirmRequestDto.fromJson(Map<String, dynamic> json) =
      _$IysConfirmRequestDtoImpl.fromJson;

  @override
  String get code;

  /// Create a copy of IysConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IysConfirmRequestDtoImplCopyWith<_$IysConfirmRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
