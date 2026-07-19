// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_category_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateCategoryRequestDto _$CreateCategoryRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateCategoryRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CreateCategoryRequestDto {
  int? get parentId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CreateCategoryRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateCategoryRequestDtoCopyWith<CreateCategoryRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCategoryRequestDtoCopyWith<$Res> {
  factory $CreateCategoryRequestDtoCopyWith(CreateCategoryRequestDto value,
          $Res Function(CreateCategoryRequestDto) then) =
      _$CreateCategoryRequestDtoCopyWithImpl<$Res, CreateCategoryRequestDto>;
  @useResult
  $Res call({int? parentId, String name, int sortOrder});
}

/// @nodoc
class _$CreateCategoryRequestDtoCopyWithImpl<$Res,
        $Val extends CreateCategoryRequestDto>
    implements $CreateCategoryRequestDtoCopyWith<$Res> {
  _$CreateCategoryRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parentId = freezed,
    Object? name = null,
    Object? sortOrder = null,
  }) {
    return _then(_value.copyWith(
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateCategoryRequestDtoImplCopyWith<$Res>
    implements $CreateCategoryRequestDtoCopyWith<$Res> {
  factory _$$CreateCategoryRequestDtoImplCopyWith(
          _$CreateCategoryRequestDtoImpl value,
          $Res Function(_$CreateCategoryRequestDtoImpl) then) =
      __$$CreateCategoryRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? parentId, String name, int sortOrder});
}

/// @nodoc
class __$$CreateCategoryRequestDtoImplCopyWithImpl<$Res>
    extends _$CreateCategoryRequestDtoCopyWithImpl<$Res,
        _$CreateCategoryRequestDtoImpl>
    implements _$$CreateCategoryRequestDtoImplCopyWith<$Res> {
  __$$CreateCategoryRequestDtoImplCopyWithImpl(
      _$CreateCategoryRequestDtoImpl _value,
      $Res Function(_$CreateCategoryRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parentId = freezed,
    Object? name = null,
    Object? sortOrder = null,
  }) {
    return _then(_$CreateCategoryRequestDtoImpl(
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCategoryRequestDtoImpl implements _CreateCategoryRequestDto {
  const _$CreateCategoryRequestDtoImpl(
      {this.parentId, required this.name, required this.sortOrder});

  factory _$CreateCategoryRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCategoryRequestDtoImplFromJson(json);

  @override
  final int? parentId;
  @override
  final String name;
  @override
  final int sortOrder;

  @override
  String toString() {
    return 'CreateCategoryRequestDto(parentId: $parentId, name: $name, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCategoryRequestDtoImpl &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, parentId, name, sortOrder);

  /// Create a copy of CreateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCategoryRequestDtoImplCopyWith<_$CreateCategoryRequestDtoImpl>
      get copyWith => __$$CreateCategoryRequestDtoImplCopyWithImpl<
          _$CreateCategoryRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCategoryRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateCategoryRequestDto implements CreateCategoryRequestDto {
  const factory _CreateCategoryRequestDto(
      {final int? parentId,
      required final String name,
      required final int sortOrder}) = _$CreateCategoryRequestDtoImpl;

  factory _CreateCategoryRequestDto.fromJson(Map<String, dynamic> json) =
      _$CreateCategoryRequestDtoImpl.fromJson;

  @override
  int? get parentId;
  @override
  String get name;
  @override
  int get sortOrder;

  /// Create a copy of CreateCategoryRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateCategoryRequestDtoImplCopyWith<_$CreateCategoryRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
