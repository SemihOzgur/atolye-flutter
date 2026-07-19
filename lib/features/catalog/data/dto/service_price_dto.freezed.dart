// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_price_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServicePriceDto _$ServicePriceDtoFromJson(Map<String, dynamic> json) {
  return _ServicePriceDto.fromJson(json);
}

/// @nodoc
mixin _$ServicePriceDto {
  int get id => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  String get categoryPath => throw _privateConstructorUsedError;
  int get serviceTypeId => throw _privateConstructorUsedError;
  String get serviceName => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this ServicePriceDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServicePriceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServicePriceDtoCopyWith<ServicePriceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServicePriceDtoCopyWith<$Res> {
  factory $ServicePriceDtoCopyWith(
          ServicePriceDto value, $Res Function(ServicePriceDto) then) =
      _$ServicePriceDtoCopyWithImpl<$Res, ServicePriceDto>;
  @useResult
  $Res call(
      {int id,
      int categoryId,
      String categoryPath,
      int serviceTypeId,
      String serviceName,
      double price,
      bool isActive});
}

/// @nodoc
class _$ServicePriceDtoCopyWithImpl<$Res, $Val extends ServicePriceDto>
    implements $ServicePriceDtoCopyWith<$Res> {
  _$ServicePriceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServicePriceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryPath = null,
    Object? serviceTypeId = null,
    Object? serviceName = null,
    Object? price = null,
    Object? isActive = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
      serviceTypeId: null == serviceTypeId
          ? _value.serviceTypeId
          : serviceTypeId // ignore: cast_nullable_to_non_nullable
              as int,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$ServicePriceDtoImplCopyWith<$Res>
    implements $ServicePriceDtoCopyWith<$Res> {
  factory _$$ServicePriceDtoImplCopyWith(_$ServicePriceDtoImpl value,
          $Res Function(_$ServicePriceDtoImpl) then) =
      __$$ServicePriceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int categoryId,
      String categoryPath,
      int serviceTypeId,
      String serviceName,
      double price,
      bool isActive});
}

/// @nodoc
class __$$ServicePriceDtoImplCopyWithImpl<$Res>
    extends _$ServicePriceDtoCopyWithImpl<$Res, _$ServicePriceDtoImpl>
    implements _$$ServicePriceDtoImplCopyWith<$Res> {
  __$$ServicePriceDtoImplCopyWithImpl(
      _$ServicePriceDtoImpl _value, $Res Function(_$ServicePriceDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServicePriceDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryPath = null,
    Object? serviceTypeId = null,
    Object? serviceName = null,
    Object? price = null,
    Object? isActive = null,
  }) {
    return _then(_$ServicePriceDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
      serviceTypeId: null == serviceTypeId
          ? _value.serviceTypeId
          : serviceTypeId // ignore: cast_nullable_to_non_nullable
              as int,
      serviceName: null == serviceName
          ? _value.serviceName
          : serviceName // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$ServicePriceDtoImpl implements _ServicePriceDto {
  const _$ServicePriceDtoImpl(
      {required this.id,
      required this.categoryId,
      required this.categoryPath,
      required this.serviceTypeId,
      required this.serviceName,
      required this.price,
      required this.isActive});

  factory _$ServicePriceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServicePriceDtoImplFromJson(json);

  @override
  final int id;
  @override
  final int categoryId;
  @override
  final String categoryPath;
  @override
  final int serviceTypeId;
  @override
  final String serviceName;
  @override
  final double price;
  @override
  final bool isActive;

  @override
  String toString() {
    return 'ServicePriceDto(id: $id, categoryId: $categoryId, categoryPath: $categoryPath, serviceTypeId: $serviceTypeId, serviceName: $serviceName, price: $price, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServicePriceDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryPath, categoryPath) ||
                other.categoryPath == categoryPath) &&
            (identical(other.serviceTypeId, serviceTypeId) ||
                other.serviceTypeId == serviceTypeId) &&
            (identical(other.serviceName, serviceName) ||
                other.serviceName == serviceName) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, categoryId, categoryPath,
      serviceTypeId, serviceName, price, isActive);

  /// Create a copy of ServicePriceDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServicePriceDtoImplCopyWith<_$ServicePriceDtoImpl> get copyWith =>
      __$$ServicePriceDtoImplCopyWithImpl<_$ServicePriceDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServicePriceDtoImplToJson(
      this,
    );
  }
}

abstract class _ServicePriceDto implements ServicePriceDto {
  const factory _ServicePriceDto(
      {required final int id,
      required final int categoryId,
      required final String categoryPath,
      required final int serviceTypeId,
      required final String serviceName,
      required final double price,
      required final bool isActive}) = _$ServicePriceDtoImpl;

  factory _ServicePriceDto.fromJson(Map<String, dynamic> json) =
      _$ServicePriceDtoImpl.fromJson;

  @override
  int get id;
  @override
  int get categoryId;
  @override
  String get categoryPath;
  @override
  int get serviceTypeId;
  @override
  String get serviceName;
  @override
  double get price;
  @override
  bool get isActive;

  /// Create a copy of ServicePriceDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServicePriceDtoImplCopyWith<_$ServicePriceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
