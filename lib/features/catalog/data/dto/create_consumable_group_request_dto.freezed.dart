// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_consumable_group_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateConsumableGroupRequestDto _$CreateConsumableGroupRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateConsumableGroupRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CreateConsumableGroupRequestDto {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this CreateConsumableGroupRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateConsumableGroupRequestDtoCopyWith<CreateConsumableGroupRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateConsumableGroupRequestDtoCopyWith<$Res> {
  factory $CreateConsumableGroupRequestDtoCopyWith(
          CreateConsumableGroupRequestDto value,
          $Res Function(CreateConsumableGroupRequestDto) then) =
      _$CreateConsumableGroupRequestDtoCopyWithImpl<$Res,
          CreateConsumableGroupRequestDto>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$CreateConsumableGroupRequestDtoCopyWithImpl<$Res,
        $Val extends CreateConsumableGroupRequestDto>
    implements $CreateConsumableGroupRequestDtoCopyWith<$Res> {
  _$CreateConsumableGroupRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateConsumableGroupRequestDtoImplCopyWith<$Res>
    implements $CreateConsumableGroupRequestDtoCopyWith<$Res> {
  factory _$$CreateConsumableGroupRequestDtoImplCopyWith(
          _$CreateConsumableGroupRequestDtoImpl value,
          $Res Function(_$CreateConsumableGroupRequestDtoImpl) then) =
      __$$CreateConsumableGroupRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$CreateConsumableGroupRequestDtoImplCopyWithImpl<$Res>
    extends _$CreateConsumableGroupRequestDtoCopyWithImpl<$Res,
        _$CreateConsumableGroupRequestDtoImpl>
    implements _$$CreateConsumableGroupRequestDtoImplCopyWith<$Res> {
  __$$CreateConsumableGroupRequestDtoImplCopyWithImpl(
      _$CreateConsumableGroupRequestDtoImpl _value,
      $Res Function(_$CreateConsumableGroupRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$CreateConsumableGroupRequestDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateConsumableGroupRequestDtoImpl
    implements _CreateConsumableGroupRequestDto {
  const _$CreateConsumableGroupRequestDtoImpl({required this.name});

  factory _$CreateConsumableGroupRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateConsumableGroupRequestDtoImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'CreateConsumableGroupRequestDto(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateConsumableGroupRequestDtoImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of CreateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateConsumableGroupRequestDtoImplCopyWith<
          _$CreateConsumableGroupRequestDtoImpl>
      get copyWith => __$$CreateConsumableGroupRequestDtoImplCopyWithImpl<
          _$CreateConsumableGroupRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateConsumableGroupRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateConsumableGroupRequestDto
    implements CreateConsumableGroupRequestDto {
  const factory _CreateConsumableGroupRequestDto({required final String name}) =
      _$CreateConsumableGroupRequestDtoImpl;

  factory _CreateConsumableGroupRequestDto.fromJson(Map<String, dynamic> json) =
      _$CreateConsumableGroupRequestDtoImpl.fromJson;

  @override
  String get name;

  /// Create a copy of CreateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateConsumableGroupRequestDtoImplCopyWith<
          _$CreateConsumableGroupRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
