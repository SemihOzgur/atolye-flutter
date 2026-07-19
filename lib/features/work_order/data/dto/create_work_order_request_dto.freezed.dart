// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_work_order_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateWorkOrderRequestDto _$CreateWorkOrderRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateWorkOrderRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CreateWorkOrderRequestDto {
  int get customerId => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
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

  /// Serializes this CreateWorkOrderRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateWorkOrderRequestDtoCopyWith<CreateWorkOrderRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateWorkOrderRequestDtoCopyWith<$Res> {
  factory $CreateWorkOrderRequestDtoCopyWith(CreateWorkOrderRequestDto value,
          $Res Function(CreateWorkOrderRequestDto) then) =
      _$CreateWorkOrderRequestDtoCopyWithImpl<$Res, CreateWorkOrderRequestDto>;
  @useResult
  $Res call(
      {int customerId,
      int categoryId,
      String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      DateTime? estimatedDeliveryDate,
      List<int> servicePriceIds,
      List<ConsumableLineDto> consumables,
      double price,
      bool hasPrepayment,
      double? prepaymentAmount});
}

/// @nodoc
class _$CreateWorkOrderRequestDtoCopyWithImpl<$Res,
        $Val extends CreateWorkOrderRequestDto>
    implements $CreateWorkOrderRequestDtoCopyWith<$Res> {
  _$CreateWorkOrderRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? categoryId = null,
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
  }) {
    return _then(_value.copyWith(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateWorkOrderRequestDtoImplCopyWith<$Res>
    implements $CreateWorkOrderRequestDtoCopyWith<$Res> {
  factory _$$CreateWorkOrderRequestDtoImplCopyWith(
          _$CreateWorkOrderRequestDtoImpl value,
          $Res Function(_$CreateWorkOrderRequestDtoImpl) then) =
      __$$CreateWorkOrderRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int customerId,
      int categoryId,
      String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      DateTime? estimatedDeliveryDate,
      List<int> servicePriceIds,
      List<ConsumableLineDto> consumables,
      double price,
      bool hasPrepayment,
      double? prepaymentAmount});
}

/// @nodoc
class __$$CreateWorkOrderRequestDtoImplCopyWithImpl<$Res>
    extends _$CreateWorkOrderRequestDtoCopyWithImpl<$Res,
        _$CreateWorkOrderRequestDtoImpl>
    implements _$$CreateWorkOrderRequestDtoImplCopyWith<$Res> {
  __$$CreateWorkOrderRequestDtoImplCopyWithImpl(
      _$CreateWorkOrderRequestDtoImpl _value,
      $Res Function(_$CreateWorkOrderRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? categoryId = null,
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
  }) {
    return _then(_$CreateWorkOrderRequestDtoImpl(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateWorkOrderRequestDtoImpl implements _CreateWorkOrderRequestDto {
  const _$CreateWorkOrderRequestDtoImpl(
      {required this.customerId,
      required this.categoryId,
      this.brand,
      this.color,
      this.material,
      this.description,
      this.existingDamages,
      this.estimatedDeliveryDate,
      final List<int> servicePriceIds = const <int>[],
      final List<ConsumableLineDto> consumables = const <ConsumableLineDto>[],
      required this.price,
      required this.hasPrepayment,
      this.prepaymentAmount})
      : _servicePriceIds = servicePriceIds,
        _consumables = consumables;

  factory _$CreateWorkOrderRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateWorkOrderRequestDtoImplFromJson(json);

  @override
  final int customerId;
  @override
  final int categoryId;
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
  String toString() {
    return 'CreateWorkOrderRequestDto(customerId: $customerId, categoryId: $categoryId, brand: $brand, color: $color, material: $material, description: $description, existingDamages: $existingDamages, estimatedDeliveryDate: $estimatedDeliveryDate, servicePriceIds: $servicePriceIds, consumables: $consumables, price: $price, hasPrepayment: $hasPrepayment, prepaymentAmount: $prepaymentAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateWorkOrderRequestDtoImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
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
                other.prepaymentAmount == prepaymentAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      customerId,
      categoryId,
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
      prepaymentAmount);

  /// Create a copy of CreateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateWorkOrderRequestDtoImplCopyWith<_$CreateWorkOrderRequestDtoImpl>
      get copyWith => __$$CreateWorkOrderRequestDtoImplCopyWithImpl<
          _$CreateWorkOrderRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateWorkOrderRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateWorkOrderRequestDto implements CreateWorkOrderRequestDto {
  const factory _CreateWorkOrderRequestDto(
      {required final int customerId,
      required final int categoryId,
      final String? brand,
      final String? color,
      final String? material,
      final String? description,
      final String? existingDamages,
      final DateTime? estimatedDeliveryDate,
      final List<int> servicePriceIds,
      final List<ConsumableLineDto> consumables,
      required final double price,
      required final bool hasPrepayment,
      final double? prepaymentAmount}) = _$CreateWorkOrderRequestDtoImpl;

  factory _CreateWorkOrderRequestDto.fromJson(Map<String, dynamic> json) =
      _$CreateWorkOrderRequestDtoImpl.fromJson;

  @override
  int get customerId;
  @override
  int get categoryId;
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

  /// Create a copy of CreateWorkOrderRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateWorkOrderRequestDtoImplCopyWith<_$CreateWorkOrderRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
