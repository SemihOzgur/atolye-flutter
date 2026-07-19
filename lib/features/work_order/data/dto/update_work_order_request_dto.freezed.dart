// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_work_order_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UpdateWorkOrderRequestDto _$UpdateWorkOrderRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _UpdateWorkOrderRequestDto.fromJson(json);
}

/// @nodoc
mixin _$UpdateWorkOrderRequestDto {
  String? get brand => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get material => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get existingDamages => throw _privateConstructorUsedError;
  DateTime? get estimatedDeliveryDate => throw _privateConstructorUsedError;
  List<int> get servicePriceIds => throw _privateConstructorUsedError;
  List<ConsumableLineDto> get consumables => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  bool get hasPrepayment => throw _privateConstructorUsedError;
  double? get prepaymentAmount => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UpdateWorkOrderRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateWorkOrderRequestDtoCopyWith<UpdateWorkOrderRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateWorkOrderRequestDtoCopyWith<$Res> {
  factory $UpdateWorkOrderRequestDtoCopyWith(UpdateWorkOrderRequestDto value,
          $Res Function(UpdateWorkOrderRequestDto) then) =
      _$UpdateWorkOrderRequestDtoCopyWithImpl<$Res, UpdateWorkOrderRequestDto>;
  @useResult
  $Res call(
      {String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      DateTime? estimatedDeliveryDate,
      List<int> servicePriceIds,
      List<ConsumableLineDto> consumables,
      double price,
      bool hasPrepayment,
      double? prepaymentAmount,
      DateTime updatedAt});
}

/// @nodoc
class _$UpdateWorkOrderRequestDtoCopyWithImpl<$Res,
        $Val extends UpdateWorkOrderRequestDto>
    implements $UpdateWorkOrderRequestDtoCopyWith<$Res> {
  _$UpdateWorkOrderRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = freezed,
    Object? color = freezed,
    Object? material = freezed,
    Object? description = freezed,
    Object? existingDamages = freezed,
    Object? estimatedDeliveryDate = freezed,
    Object? servicePriceIds = null,
    Object? consumables = null,
    Object? price = null,
    Object? hasPrepayment = null,
    Object? prepaymentAmount = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      material: freezed == material
          ? _value.material
          : material // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      existingDamages: freezed == existingDamages
          ? _value.existingDamages
          : existingDamages // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDeliveryDate: freezed == estimatedDeliveryDate
          ? _value.estimatedDeliveryDate
          : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      servicePriceIds: null == servicePriceIds
          ? _value.servicePriceIds
          : servicePriceIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      consumables: null == consumables
          ? _value.consumables
          : consumables // ignore: cast_nullable_to_non_nullable
              as List<ConsumableLineDto>,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      hasPrepayment: null == hasPrepayment
          ? _value.hasPrepayment
          : hasPrepayment // ignore: cast_nullable_to_non_nullable
              as bool,
      prepaymentAmount: freezed == prepaymentAmount
          ? _value.prepaymentAmount
          : prepaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateWorkOrderRequestDtoImplCopyWith<$Res>
    implements $UpdateWorkOrderRequestDtoCopyWith<$Res> {
  factory _$$UpdateWorkOrderRequestDtoImplCopyWith(
          _$UpdateWorkOrderRequestDtoImpl value,
          $Res Function(_$UpdateWorkOrderRequestDtoImpl) then) =
      __$$UpdateWorkOrderRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      DateTime? estimatedDeliveryDate,
      List<int> servicePriceIds,
      List<ConsumableLineDto> consumables,
      double price,
      bool hasPrepayment,
      double? prepaymentAmount,
      DateTime updatedAt});
}

/// @nodoc
class __$$UpdateWorkOrderRequestDtoImplCopyWithImpl<$Res>
    extends _$UpdateWorkOrderRequestDtoCopyWithImpl<$Res,
        _$UpdateWorkOrderRequestDtoImpl>
    implements _$$UpdateWorkOrderRequestDtoImplCopyWith<$Res> {
  __$$UpdateWorkOrderRequestDtoImplCopyWithImpl(
      _$UpdateWorkOrderRequestDtoImpl _value,
      $Res Function(_$UpdateWorkOrderRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = freezed,
    Object? color = freezed,
    Object? material = freezed,
    Object? description = freezed,
    Object? existingDamages = freezed,
    Object? estimatedDeliveryDate = freezed,
    Object? servicePriceIds = null,
    Object? consumables = null,
    Object? price = null,
    Object? hasPrepayment = null,
    Object? prepaymentAmount = freezed,
    Object? updatedAt = null,
  }) {
    return _then(_$UpdateWorkOrderRequestDtoImpl(
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      material: freezed == material
          ? _value.material
          : material // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      existingDamages: freezed == existingDamages
          ? _value.existingDamages
          : existingDamages // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDeliveryDate: freezed == estimatedDeliveryDate
          ? _value.estimatedDeliveryDate
          : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      servicePriceIds: null == servicePriceIds
          ? _value._servicePriceIds
          : servicePriceIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      consumables: null == consumables
          ? _value._consumables
          : consumables // ignore: cast_nullable_to_non_nullable
              as List<ConsumableLineDto>,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      hasPrepayment: null == hasPrepayment
          ? _value.hasPrepayment
          : hasPrepayment // ignore: cast_nullable_to_non_nullable
              as bool,
      prepaymentAmount: freezed == prepaymentAmount
          ? _value.prepaymentAmount
          : prepaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateWorkOrderRequestDtoImpl implements _UpdateWorkOrderRequestDto {
  const _$UpdateWorkOrderRequestDtoImpl(
      {this.brand,
      this.color,
      this.material,
      this.description,
      this.existingDamages,
      this.estimatedDeliveryDate,
      final List<int> servicePriceIds = const <int>[],
      final List<ConsumableLineDto> consumables = const <ConsumableLineDto>[],
      required this.price,
      required this.hasPrepayment,
      this.prepaymentAmount,
      required this.updatedAt})
      : _servicePriceIds = servicePriceIds,
        _consumables = consumables;

  factory _$UpdateWorkOrderRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateWorkOrderRequestDtoImplFromJson(json);

  @override
  final String? brand;
  @override
  final String? color;
  @override
  final String? material;
  @override
  final String? description;
  @override
  final String? existingDamages;
  @override
  final DateTime? estimatedDeliveryDate;
  final List<int> _servicePriceIds;
  @override
  @JsonKey()
  List<int> get servicePriceIds {
    if (_servicePriceIds is EqualUnmodifiableListView) return _servicePriceIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_servicePriceIds);
  }

  final List<ConsumableLineDto> _consumables;
  @override
  @JsonKey()
  List<ConsumableLineDto> get consumables {
    if (_consumables is EqualUnmodifiableListView) return _consumables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_consumables);
  }

  @override
  final double price;
  @override
  final bool hasPrepayment;
  @override
  final double? prepaymentAmount;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UpdateWorkOrderRequestDto(brand: $brand, color: $color, material: $material, description: $description, existingDamages: $existingDamages, estimatedDeliveryDate: $estimatedDeliveryDate, servicePriceIds: $servicePriceIds, consumables: $consumables, price: $price, hasPrepayment: $hasPrepayment, prepaymentAmount: $prepaymentAmount, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateWorkOrderRequestDtoImpl &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.material, material) ||
                other.material == material) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.existingDamages, existingDamages) ||
                other.existingDamages == existingDamages) &&
            (identical(other.estimatedDeliveryDate, estimatedDeliveryDate) ||
                other.estimatedDeliveryDate == estimatedDeliveryDate) &&
            const DeepCollectionEquality()
                .equals(other._servicePriceIds, _servicePriceIds) &&
            const DeepCollectionEquality()
                .equals(other._consumables, _consumables) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.hasPrepayment, hasPrepayment) ||
                other.hasPrepayment == hasPrepayment) &&
            (identical(other.prepaymentAmount, prepaymentAmount) ||
                other.prepaymentAmount == prepaymentAmount) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      brand,
      color,
      material,
      description,
      existingDamages,
      estimatedDeliveryDate,
      const DeepCollectionEquality().hash(_servicePriceIds),
      const DeepCollectionEquality().hash(_consumables),
      price,
      hasPrepayment,
      prepaymentAmount,
      updatedAt);

  /// Create a copy of UpdateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateWorkOrderRequestDtoImplCopyWith<_$UpdateWorkOrderRequestDtoImpl>
      get copyWith => __$$UpdateWorkOrderRequestDtoImplCopyWithImpl<
          _$UpdateWorkOrderRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateWorkOrderRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _UpdateWorkOrderRequestDto implements UpdateWorkOrderRequestDto {
  const factory _UpdateWorkOrderRequestDto(
      {final String? brand,
      final String? color,
      final String? material,
      final String? description,
      final String? existingDamages,
      final DateTime? estimatedDeliveryDate,
      final List<int> servicePriceIds,
      final List<ConsumableLineDto> consumables,
      required final double price,
      required final bool hasPrepayment,
      final double? prepaymentAmount,
      required final DateTime updatedAt}) = _$UpdateWorkOrderRequestDtoImpl;

  factory _UpdateWorkOrderRequestDto.fromJson(Map<String, dynamic> json) =
      _$UpdateWorkOrderRequestDtoImpl.fromJson;

  @override
  String? get brand;
  @override
  String? get color;
  @override
  String? get material;
  @override
  String? get description;
  @override
  String? get existingDamages;
  @override
  DateTime? get estimatedDeliveryDate;
  @override
  List<int> get servicePriceIds;
  @override
  List<ConsumableLineDto> get consumables;
  @override
  double get price;
  @override
  bool get hasPrepayment;
  @override
  double? get prepaymentAmount;
  @override
  DateTime get updatedAt;

  /// Create a copy of UpdateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateWorkOrderRequestDtoImplCopyWith<_$UpdateWorkOrderRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
