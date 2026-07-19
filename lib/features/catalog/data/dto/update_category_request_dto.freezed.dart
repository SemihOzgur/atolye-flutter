// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_category_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateCategoryRequestDto _$UpdateCategoryRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _UpdateCategoryRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateCategoryRequestDto {
  String get name => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this UpdateCategoryRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateCategoryRequestDtoCopyWith<UpdateCategoryRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateCategoryRequestDtoCopyWith<$Res> {
  factory $UpdateCategoryRequestDtoCopyWith(UpdateCategoryRequestDto value,
          $Res Function(UpdateCategoryRequestDto) then) =
      _$UpdateCategoryRequestDtoCopyWithImpl<$Res, UpdateCategoryRequestDto>;
  @useResult
  $Res call({String name, int sortOrder, bool isActive});
}

/// @nodoc
class _$UpdateCategoryRequestDtoCopyWithImpl<$Res,
        $Val extends UpdateCategoryRequestDto>
    implements $UpdateCategoryRequestDtoCopyWith<$Res> {
  _$UpdateCategoryRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateCategoryRequestDtoImplCopyWith<$Res>
    implements $UpdateCategoryRequestDtoCopyWith<$Res> {
  factory _$$UpdateCategoryRequestDtoImplCopyWith(
          _$UpdateCategoryRequestDtoImpl value,
          $Res Function(_$UpdateCategoryRequestDtoImpl) then) =
      __$$UpdateCategoryRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int sortOrder, bool isActive});
}

/// @nodoc
class __$$UpdateCategoryRequestDtoImplCopyWithImpl<$Res>
    extends _$UpdateCategoryRequestDtoCopyWithImpl<$Res,
        _$UpdateCategoryRequestDtoImpl>
    implements _$$UpdateCategoryRequestDtoImplCopyWith<$Res> {
  __$$UpdateCategoryRequestDtoImplCopyWithImpl(
      _$UpdateCategoryRequestDtoImpl _value,
      $Res Function(_$UpdateCategoryRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$UpdateCategoryRequestDtoImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateCategoryRequestDtoImpl implements _UpdateCategoryRequestDto {
  const _$UpdateCategoryRequestDtoImpl(
      {required this.name, required this.sortOrder, required this.isActive});

  factory _$UpdateCategoryRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateCategoryRequestDtoImplFromJson(json);

  @override
  final String name;
  @override
  final int sortOrder;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'UpdateCategoryRequestDto(name: $name, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateCategoryRequestDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, sortOrder, isActive);

  /// Create a copy of UpdateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateCategoryRequestDtoImplCopyWith<_$UpdateCategoryRequestDtoImpl>
      get copyWith => __$$UpdateCategoryRequestDtoImplCopyWithImpl<
          _$UpdateCategoryRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateCategoryRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateCategoryRequestDto implements UpdateCategoryRequestDto {
  const factory _UpdateCategoryRequestDto(
      {required final String name,
      required final int sortOrder,
      required final bool isActive}) = _$UpdateCategoryRequestDtoImpl;

  factory _UpdateCategoryRequestDto.fromJson(Map<String, dynamic> json) =
      _$UpdateCategoryRequestDtoImpl.fromJson;

  @override
  String get name;
  @override
  int get sortOrder;
  @override
  bool get isActive;

  /// Create a copy of UpdateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateCategoryRequestDtoImplCopyWith<_$UpdateCategoryRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
