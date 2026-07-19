// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_price_option_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServicePriceOptionDto _$ServicePriceOptionDtoFromJson(
    Map<String, dynamic> json) {
  return _ServicePriceOptionDto.fromJson(json);
}

/// @nodoc
mixin _$ServicePriceOptionDto {
  int get servicePriceId => throw _privateConstructorUsedError;
  String get serviceName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Serializes this ServicePriceOptionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServicePriceOptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServicePriceOptionDtoCopyWith<ServicePriceOptionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServicePriceOptionDtoCopyWith<$Res> {
  factory $ServicePriceOptionDtoCopyWith(ServicePriceOptionDto value,
          $Res Function(ServicePriceOptionDto) then) =
      _$ServicePriceOptionDtoCopyWithImpl<$Res, ServicePriceOptionDto>;
  @useResult
  $Res call({int servicePriceId, String serviceName, double price});
}

/// @nodoc
class _$ServicePriceOptionDtoCopyWithImpl<$Res,
        $Val extends ServicePriceOptionDto>
    implements $ServicePriceOptionDtoCopyWith<$Res> {
  _$ServicePriceOptionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServicePriceOptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servicePriceId = null,
    Object? serviceName = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      servicePriceId: null == servicePriceId
          ? _value.servicePriceId
          : servicePriceId // ignore: cast_nullable_to_non_nullable
              as int,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServicePriceOptionDtoImplCopyWith<$Res>
    implements $ServicePriceOptionDtoCopyWith<$Res> {
  factory _$$ServicePriceOptionDtoImplCopyWith(
          _$ServicePriceOptionDtoImpl value,
          $Res Function(_$ServicePriceOptionDtoImpl) then) =
      __$$ServicePriceOptionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int servicePriceId, String serviceName, double price});
}

/// @nodoc
class __$$ServicePriceOptionDtoImplCopyWithImpl<$Res>
    extends _$ServicePriceOptionDtoCopyWithImpl<$Res,
        _$ServicePriceOptionDtoImpl>
    implements _$$ServicePriceOptionDtoImplCopyWith<$Res> {
  __$$ServicePriceOptionDtoImplCopyWithImpl(_$ServicePriceOptionDtoImpl _value,
      $Res Function(_$ServicePriceOptionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServicePriceOptionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servicePriceId = null,
    Object? serviceName = null,
    Object? price = null,
  }) {
    return _then(_$ServicePriceOptionDtoImpl(
      servicePriceId: null == servicePriceId
          ? _value.servicePriceId
          : servicePriceId // ignore: cast_nullable_to_non_nullable
              as int,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServicePriceOptionDtoImpl implements _ServicePriceOptionDto {
  const _$ServicePriceOptionDtoImpl(
      {required this.servicePriceId,
      required this.serviceName,
      required this.price});

  factory _$ServicePriceOptionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServicePriceOptionDtoImplFromJson(json);

  @override
  final int servicePriceId;
  @override
  final String serviceName;
  @override
  final double price;

  @override
  String toString() {
    return 'ServicePriceOptionDto(servicePriceId: $servicePriceId, serviceName: $serviceName, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServicePriceOptionDtoImpl &&
            (identical(other.servicePriceId, servicePriceId) ||
                other.servicePriceId == servicePriceId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, servicePriceId, serviceName, price);

  /// Create a copy of ServicePriceOptionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServicePriceOptionDtoImplCopyWith<_$ServicePriceOptionDtoImpl>
      get copyWith => __$$ServicePriceOptionDtoImplCopyWithImpl<
          _$ServicePriceOptionDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServicePriceOptionDtoImplToJson(
      this,
    );
  }
}

abstract class _ServicePriceOptionDto implements ServicePriceOptionDto {
  const factory _ServicePriceOptionDto(
      {required final int servicePriceId,
      required final String serviceName,
      required final double price}) = _$ServicePriceOptionDtoImpl;

  factory _ServicePriceOptionDto.fromJson(Map<String, dynamic> json) =
      _$ServicePriceOptionDtoImpl.fromJson;

  @override
  int get servicePriceId;
  @override
  String get serviceName;
  @override
  double get price;

  /// Create a copy of ServicePriceOptionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServicePriceOptionDtoImplCopyWith<_$ServicePriceOptionDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
