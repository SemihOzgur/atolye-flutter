// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_consumable_product_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateConsumableProductRequestDto _$CreateConsumableProductRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateConsumableProductRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CreateConsumableProductRequestDto {
  int get groupId => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get salePrice => throw _privateConstructorUsedError;

  /// Serializes this CreateConsumableProductRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateConsumableProductRequestDtoCopyWith<CreateConsumableProductRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateConsumableProductRequestDtoCopyWith<$Res> {
  factory $CreateConsumableProductRequestDtoCopyWith(
          CreateConsumableProductRequestDto value,
          $Res Function(CreateConsumableProductRequestDto) then) =
      _$CreateConsumableProductRequestDtoCopyWithImpl<$Res,
          CreateConsumableProductRequestDto>;
  @useResult
  $Res call({int groupId, String? brand, String name, double salePrice});
}

/// @nodoc
class _$CreateConsumableProductRequestDtoCopyWithImpl<$Res,
        $Val extends CreateConsumableProductRequestDto>
    implements $CreateConsumableProductRequestDtoCopyWith<$Res> {
  _$CreateConsumableProductRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? brand = freezed,
    Object? name = null,
    Object? salePrice = null,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      salePrice: null == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateConsumableProductRequestDtoImplCopyWith<$Res>
    implements $CreateConsumableProductRequestDtoCopyWith<$Res> {
  factory _$$CreateConsumableProductRequestDtoImplCopyWith(
          _$CreateConsumableProductRequestDtoImpl value,
          $Res Function(_$CreateConsumableProductRequestDtoImpl) then) =
      __$$CreateConsumableProductRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int groupId, String? brand, String name, double salePrice});
}

/// @nodoc
class __$$CreateConsumableProductRequestDtoImplCopyWithImpl<$Res>
    extends _$CreateConsumableProductRequestDtoCopyWithImpl<$Res,
        _$CreateConsumableProductRequestDtoImpl>
    implements _$$CreateConsumableProductRequestDtoImplCopyWith<$Res> {
  __$$CreateConsumableProductRequestDtoImplCopyWithImpl(
      _$CreateConsumableProductRequestDtoImpl _value,
      $Res Function(_$CreateConsumableProductRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? brand = freezed,
    Object? name = null,
    Object? salePrice = null,
  }) {
    return _then(_$CreateConsumableProductRequestDtoImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as int,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      salePrice: null == salePrice
          ? _value.salePrice
          : salePrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateConsumableProductRequestDtoImpl
    implements _CreateConsumableProductRequestDto {
  const _$CreateConsumableProductRequestDtoImpl(
      {required this.groupId,
      this.brand,
      required this.name,
      required this.salePrice});

  factory _$CreateConsumableProductRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateConsumableProductRequestDtoImplFromJson(json);

  @override
  final int groupId;
  @override
  final String? brand;
  @override
  final String name;
  @override
  final double salePrice;

  @override
  String toString() {
    return 'CreateConsumableProductRequestDto(groupId: $groupId, brand: $brand, name: $name, salePrice: $salePrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateConsumableProductRequestDtoImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, groupId, brand, name, salePrice);

  /// Create a copy of CreateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateConsumableProductRequestDtoImplCopyWith<
          _$CreateConsumableProductRequestDtoImpl>
      get copyWith => __$$CreateConsumableProductRequestDtoImplCopyWithImpl<
          _$CreateConsumableProductRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateConsumableProductRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateConsumableProductRequestDto
    implements CreateConsumableProductRequestDto {
  const factory _CreateConsumableProductRequestDto(
          {required final int groupId,
          final String? brand,
          required final String name,
          required final double salePrice}) =
      _$CreateConsumableProductRequestDtoImpl;

  factory _CreateConsumableProductRequestDto.fromJson(
          Map<String, dynamic> json) =
      _$CreateConsumableProductRequestDtoImpl.fromJson;

  @override
  int get groupId;
  @override
  String? get brand;
  @override
  String get name;
  @override
  double get salePrice;

  /// Create a copy of CreateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateConsumableProductRequestDtoImplCopyWith<
          _$CreateConsumableProductRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
