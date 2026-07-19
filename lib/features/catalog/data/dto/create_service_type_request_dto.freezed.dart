// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_service_type_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateServiceTypeRequestDto _$CreateServiceTypeRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateServiceTypeRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CreateServiceTypeRequestDto {
  String get name => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CreateServiceTypeRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateServiceTypeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateServiceTypeRequestDtoCopyWith<CreateServiceTypeRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateServiceTypeRequestDtoCopyWith<$Res> {
  factory $CreateServiceTypeRequestDtoCopyWith(
          CreateServiceTypeRequestDto value,
          $Res Function(CreateServiceTypeRequestDto) then) =
      _$CreateServiceTypeRequestDtoCopyWithImpl<$Res,
          CreateServiceTypeRequestDto>;
  @useResult
  $Res call({String name, int sortOrder});
}

/// @nodoc
class _$CreateServiceTypeRequestDtoCopyWithImpl<$Res,
        $Val extends CreateServiceTypeRequestDto>
    implements $CreateServiceTypeRequestDtoCopyWith<$Res> {
  _$CreateServiceTypeRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateServiceTypeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? sortOrder = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateServiceTypeRequestDtoImplCopyWith<$Res>
    implements $CreateServiceTypeRequestDtoCopyWith<$Res> {
  factory _$$CreateServiceTypeRequestDtoImplCopyWith(
          _$CreateServiceTypeRequestDtoImpl value,
          $Res Function(_$CreateServiceTypeRequestDtoImpl) then) =
      __$$CreateServiceTypeRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int sortOrder});
}

/// @nodoc
class __$$CreateServiceTypeRequestDtoImplCopyWithImpl<$Res>
    extends _$CreateServiceTypeRequestDtoCopyWithImpl<$Res,
        _$CreateServiceTypeRequestDtoImpl>
    implements _$$CreateServiceTypeRequestDtoImplCopyWith<$Res> {
  __$$CreateServiceTypeRequestDtoImplCopyWithImpl(
      _$CreateServiceTypeRequestDtoImpl _value,
      $Res Function(_$CreateServiceTypeRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateServiceTypeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? sortOrder = null,
  }) {
    return _then(_$CreateServiceTypeRequestDtoImpl(
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
class _$CreateServiceTypeRequestDtoImpl
    implements _CreateServiceTypeRequestDto {
  const _$CreateServiceTypeRequestDtoImpl(
      {required this.name, required this.sortOrder});

  factory _$CreateServiceTypeRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateServiceTypeRequestDtoImplFromJson(json);

  @override
  final String name;
  @override
  final int sortOrder;

  @override
  String toString() {
    return 'CreateServiceTypeRequestDto(name: $name, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateServiceTypeRequestDtoImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, sortOrder);

  /// Create a copy of CreateServiceTypeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateServiceTypeRequestDtoImplCopyWith<_$CreateServiceTypeRequestDtoImpl>
      get copyWith => __$$CreateServiceTypeRequestDtoImplCopyWithImpl<
          _$CreateServiceTypeRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateServiceTypeRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateServiceTypeRequestDto
    implements CreateServiceTypeRequestDto {
  const factory _CreateServiceTypeRequestDto(
      {required final String name,
      required final int sortOrder}) = _$CreateServiceTypeRequestDtoImpl;

  factory _CreateServiceTypeRequestDto.fromJson(Map<String, dynamic> json) =
      _$CreateServiceTypeRequestDtoImpl.fromJson;

  @override
  String get name;
  @override
  int get sortOrder;

  /// Create a copy of CreateServiceTypeRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateServiceTypeRequestDtoImplCopyWith<_$CreateServiceTypeRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
