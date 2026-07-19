// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_consumable_product_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateConsumableProductRequestDto _$UpdateConsumableProductRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _UpdateConsumableProductRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateConsumableProductRequestDto {
  String? get brand => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get salePrice => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this UpdateConsumableProductRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateConsumableProductRequestDtoCopyWith<UpdateConsumableProductRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateConsumableProductRequestDtoCopyWith<$Res> {
  factory $UpdateConsumableProductRequestDtoCopyWith(
          UpdateConsumableProductRequestDto value,
          $Res Function(UpdateConsumableProductRequestDto) then) =
      _$UpdateConsumableProductRequestDtoCopyWithImpl<$Res,
          UpdateConsumableProductRequestDto>;
  @useResult
  $Res call({String? brand, String name, double salePrice, bool isActive});
}

/// @nodoc
class _$UpdateConsumableProductRequestDtoCopyWithImpl<$Res,
        $Val extends UpdateConsumableProductRequestDto>
    implements $UpdateConsumableProductRequestDtoCopyWith<$Res> {
  _$UpdateConsumableProductRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = freezed,
    Object? name = null,
    Object? salePrice = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
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
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateConsumableProductRequestDtoImplCopyWith<$Res>
    implements $UpdateConsumableProductRequestDtoCopyWith<$Res> {
  factory _$$UpdateConsumableProductRequestDtoImplCopyWith(
          _$UpdateConsumableProductRequestDtoImpl value,
          $Res Function(_$UpdateConsumableProductRequestDtoImpl) then) =
      __$$UpdateConsumableProductRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? brand, String name, double salePrice, bool isActive});
}

/// @nodoc
class __$$UpdateConsumableProductRequestDtoImplCopyWithImpl<$Res>
    extends _$UpdateConsumableProductRequestDtoCopyWithImpl<$Res,
        _$UpdateConsumableProductRequestDtoImpl>
    implements _$$UpdateConsumableProductRequestDtoImplCopyWith<$Res> {
  __$$UpdateConsumableProductRequestDtoImplCopyWithImpl(
      _$UpdateConsumableProductRequestDtoImpl _value,
      $Res Function(_$UpdateConsumableProductRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = freezed,
    Object? name = null,
    Object? salePrice = null,
    Object? isActive = null,
  }) {
    return _then(_$UpdateConsumableProductRequestDtoImpl(
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
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateConsumableProductRequestDtoImpl
    implements _UpdateConsumableProductRequestDto {
  const _$UpdateConsumableProductRequestDtoImpl(
      {this.brand,
      required this.name,
      required this.salePrice,
      required this.isActive});

  factory _$UpdateConsumableProductRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpdateConsumableProductRequestDtoImplFromJson(json);

  @override
  final String? brand;
  @override
  final String name;
  @override
  final double salePrice;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'UpdateConsumableProductRequestDto(brand: $brand, name: $name, salePrice: $salePrice, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateConsumableProductRequestDtoImpl &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.salePrice, salePrice) ||
                other.salePrice == salePrice) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, brand, name, salePrice, isActive);

  /// Create a copy of UpdateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateConsumableProductRequestDtoImplCopyWith<
          _$UpdateConsumableProductRequestDtoImpl>
      get copyWith => __$$UpdateConsumableProductRequestDtoImplCopyWithImpl<
          _$UpdateConsumableProductRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateConsumableProductRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateConsumableProductRequestDto
    implements UpdateConsumableProductRequestDto {
  const factory _UpdateConsumableProductRequestDto(
      {final String? brand,
      required final String name,
      required final double salePrice,
      required final bool isActive}) = _$UpdateConsumableProductRequestDtoImpl;

  factory _UpdateConsumableProductRequestDto.fromJson(
          Map<String, dynamic> json) =
      _$UpdateConsumableProductRequestDtoImpl.fromJson;

  @override
  String? get brand;
  @override
  String get name;
  @override
  double get salePrice;
  @override
  bool get isActive;

  /// Create a copy of UpdateConsumableProductRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateConsumableProductRequestDtoImplCopyWith<
          _$UpdateConsumableProductRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
