// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_consumable_group_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateConsumableGroupRequestDto _$UpdateConsumableGroupRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _UpdateConsumableGroupRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateConsumableGroupRequestDto {
  String get name => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this UpdateConsumableGroupRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateConsumableGroupRequestDtoCopyWith<UpdateConsumableGroupRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateConsumableGroupRequestDtoCopyWith<$Res> {
  factory $UpdateConsumableGroupRequestDtoCopyWith(
          UpdateConsumableGroupRequestDto value,
          $Res Function(UpdateConsumableGroupRequestDto) then) =
      _$UpdateConsumableGroupRequestDtoCopyWithImpl<$Res,
          UpdateConsumableGroupRequestDto>;
  @useResult
  $Res call({String name, bool isActive});
}

/// @nodoc
class _$UpdateConsumableGroupRequestDtoCopyWithImpl<$Res,
        $Val extends UpdateConsumableGroupRequestDto>
    implements $UpdateConsumableGroupRequestDtoCopyWith<$Res> {
  _$UpdateConsumableGroupRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateConsumableGroupRequestDtoImplCopyWith<$Res>
    implements $UpdateConsumableGroupRequestDtoCopyWith<$Res> {
  factory _$$UpdateConsumableGroupRequestDtoImplCopyWith(
          _$UpdateConsumableGroupRequestDtoImpl value,
          $Res Function(_$UpdateConsumableGroupRequestDtoImpl) then) =
      __$$UpdateConsumableGroupRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, bool isActive});
}

/// @nodoc
class __$$UpdateConsumableGroupRequestDtoImplCopyWithImpl<$Res>
    extends _$UpdateConsumableGroupRequestDtoCopyWithImpl<$Res,
        _$UpdateConsumableGroupRequestDtoImpl>
    implements _$$UpdateConsumableGroupRequestDtoImplCopyWith<$Res> {
  __$$UpdateConsumableGroupRequestDtoImplCopyWithImpl(
      _$UpdateConsumableGroupRequestDtoImpl _value,
      $Res Function(_$UpdateConsumableGroupRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? isActive = null,
  }) {
    return _then(_$UpdateConsumableGroupRequestDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateConsumableGroupRequestDtoImpl
    implements _UpdateConsumableGroupRequestDto {
  const _$UpdateConsumableGroupRequestDtoImpl(
      {required this.name, required this.isActive});

  factory _$UpdateConsumableGroupRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateConsumableGroupRequestDtoImplFromJson(json);

  @override
  final String name;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'UpdateConsumableGroupRequestDto(name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateConsumableGroupRequestDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, isActive);

  /// Create a copy of UpdateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateConsumableGroupRequestDtoImplCopyWith<
          _$UpdateConsumableGroupRequestDtoImpl>
      get copyWith => __$$UpdateConsumableGroupRequestDtoImplCopyWithImpl<
          _$UpdateConsumableGroupRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateConsumableGroupRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateConsumableGroupRequestDto
    implements UpdateConsumableGroupRequestDto {
  const factory _UpdateConsumableGroupRequestDto(
      {required final String name,
      required final bool isActive}) = _$UpdateConsumableGroupRequestDtoImpl;

  factory _UpdateConsumableGroupRequestDto.fromJson(Map<String, dynamic> json) =
      _$UpdateConsumableGroupRequestDtoImpl.fromJson;

  @override
  String get name;
  @override
  bool get isActive;

  /// Create a copy of UpdateConsumableGroupRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateConsumableGroupRequestDtoImplCopyWith<
          _$UpdateConsumableGroupRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
