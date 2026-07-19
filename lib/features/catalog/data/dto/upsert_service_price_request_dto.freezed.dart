// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upsert_service_price_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpsertServicePriceRequestDto _$UpsertServicePriceRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _UpsertServicePriceRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpsertServicePriceRequestDto {
  int get categoryId => throw _privateConstructorUsedError;
  int get serviceTypeId => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this UpsertServicePriceRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpsertServicePriceRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpsertServicePriceRequestDtoCopyWith<UpsertServicePriceRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpsertServicePriceRequestDtoCopyWith<$Res> {
  factory $UpsertServicePriceRequestDtoCopyWith(
          UpsertServicePriceRequestDto value,
          $Res Function(UpsertServicePriceRequestDto) then) =
      _$UpsertServicePriceRequestDtoCopyWithImpl<$Res,
          UpsertServicePriceRequestDto>;
  @useResult
  $Res call({int categoryId, int serviceTypeId, double price, bool isActive});
}

/// @nodoc
class _$UpsertServicePriceRequestDtoCopyWithImpl<$Res,
        $Val extends UpsertServicePriceRequestDto>
    implements $UpsertServicePriceRequestDtoCopyWith<$Res> {
  _$UpsertServicePriceRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpsertServicePriceRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? serviceTypeId = null,
    Object? price = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      serviceTypeId: null == serviceTypeId
          ? _value.serviceTypeId
          : serviceTypeId // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpsertServicePriceRequestDtoImplCopyWith<$Res>
    implements $UpsertServicePriceRequestDtoCopyWith<$Res> {
  factory _$$UpsertServicePriceRequestDtoImplCopyWith(
          _$UpsertServicePriceRequestDtoImpl value,
          $Res Function(_$UpsertServicePriceRequestDtoImpl) then) =
      __$$UpsertServicePriceRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int categoryId, int serviceTypeId, double price, bool isActive});
}

/// @nodoc
class __$$UpsertServicePriceRequestDtoImplCopyWithImpl<$Res>
    extends _$UpsertServicePriceRequestDtoCopyWithImpl<$Res,
        _$UpsertServicePriceRequestDtoImpl>
    implements _$$UpsertServicePriceRequestDtoImplCopyWith<$Res> {
  __$$UpsertServicePriceRequestDtoImplCopyWithImpl(
      _$UpsertServicePriceRequestDtoImpl _value,
      $Res Function(_$UpsertServicePriceRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpsertServicePriceRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? serviceTypeId = null,
    Object? price = null,
    Object? isActive = null,
  }) {
    return _then(_$UpsertServicePriceRequestDtoImpl(
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      serviceTypeId: null == serviceTypeId
          ? _value.serviceTypeId
          : serviceTypeId // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
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
class _$UpsertServicePriceRequestDtoImpl
    implements _UpsertServicePriceRequestDto {
  const _$UpsertServicePriceRequestDtoImpl(
      {required this.categoryId,
      required this.serviceTypeId,
      required this.price,
      required this.isActive});

  factory _$UpsertServicePriceRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UpsertServicePriceRequestDtoImplFromJson(json);

  @override
  final int categoryId;
  @override
  final int serviceTypeId;
  @override
  final double price;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'UpsertServicePriceRequestDto(categoryId: $categoryId, serviceTypeId: $serviceTypeId, price: $price, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpsertServicePriceRequestDtoImpl &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.serviceTypeId, serviceTypeId) ||
                other.serviceTypeId == serviceTypeId) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryId, serviceTypeId, price, isActive);

  /// Create a copy of UpsertServicePriceRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpsertServicePriceRequestDtoImplCopyWith<
          _$UpsertServicePriceRequestDtoImpl>
      get copyWith => __$$UpsertServicePriceRequestDtoImplCopyWithImpl<
          _$UpsertServicePriceRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpsertServicePriceRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _UpsertServicePriceRequestDto
    implements UpsertServicePriceRequestDto {
  const factory _UpsertServicePriceRequestDto(
      {required final int categoryId,
      required final int serviceTypeId,
      required final double price,
      required final bool isActive}) = _$UpsertServicePriceRequestDtoImpl;

  factory _UpsertServicePriceRequestDto.fromJson(Map<String, dynamic> json) =
      _$UpsertServicePriceRequestDtoImpl.fromJson;

  @override
  int get categoryId;
  @override
  int get serviceTypeId;
  @override
  double get price;
  @override
  bool get isActive;

  /// Create a copy of UpsertServicePriceRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpsertServicePriceRequestDtoImplCopyWith<
          _$UpsertServicePriceRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
