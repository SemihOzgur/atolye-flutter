// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_type_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceTypeDto _$ServiceTypeDtoFromJson(Map<String, dynamic> json) {
  return _ServiceTypeDto.fromJson(json);
}

/// @nodoc
mixin _$ServiceTypeDto {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ServiceTypeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceTypeDtoCopyWith<ServiceTypeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceTypeDtoCopyWith<$Res> {
  factory $ServiceTypeDtoCopyWith(
          ServiceTypeDto value, $Res Function(ServiceTypeDto) then) =
      _$ServiceTypeDtoCopyWithImpl<$Res, ServiceTypeDto>;
  @useResult
  $Res call({int id, String name, int sortOrder, bool isActive});
}

/// @nodoc
class _$ServiceTypeDtoCopyWithImpl<$Res, $Val extends ServiceTypeDto>
    implements $ServiceTypeDtoCopyWith<$Res> {
  _$ServiceTypeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$ServiceTypeDtoImplCopyWith<$Res>
    implements $ServiceTypeDtoCopyWith<$Res> {
  factory _$$ServiceTypeDtoImplCopyWith(_$ServiceTypeDtoImpl value,
          $Res Function(_$ServiceTypeDtoImpl) then) =
      __$$ServiceTypeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, int sortOrder, bool isActive});
}

/// @nodoc
class __$$ServiceTypeDtoImplCopyWithImpl<$Res>
    extends _$ServiceTypeDtoCopyWithImpl<$Res, _$ServiceTypeDtoImpl>
    implements _$$ServiceTypeDtoImplCopyWith<$Res> {
  __$$ServiceTypeDtoImplCopyWithImpl(
      _$ServiceTypeDtoImpl _value, $Res Function(_$ServiceTypeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? sortOrder = null,
    Object? isActive = null,
  }) {
    return _then(_$ServiceTypeDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
class _$ServiceTypeDtoImpl implements _ServiceTypeDto {
  const _$ServiceTypeDtoImpl(
      {required this.id,
      required this.name,
      required this.sortOrder,
      required this.isActive});

  factory _$ServiceTypeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceTypeDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final int sortOrder;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'ServiceTypeDto(id: $id, name: $name, sortOrder: $sortOrder, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceTypeDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, sortOrder, isActive);

  /// Create a copy of ServiceTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceTypeDtoImplCopyWith<_$ServiceTypeDtoImpl> get copyWith =>
      __$$ServiceTypeDtoImplCopyWithImpl<_$ServiceTypeDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceTypeDtoImplToJson(
      this,
    );
  }
}

abstract class _ServiceTypeDto implements ServiceTypeDto {
  const factory _ServiceTypeDto(
      {required final int id,
      required final String name,
      required final int sortOrder,
      required final bool isActive}) = _$ServiceTypeDtoImpl;

  factory _ServiceTypeDto.fromJson(Map<String, dynamic> json) =
      _$ServiceTypeDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  int get sortOrder;
  @override
  bool get isActive;

  /// Create a copy of ServiceTypeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceTypeDtoImplCopyWith<_$ServiceTypeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
