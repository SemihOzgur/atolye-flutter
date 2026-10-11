// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_receipt_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateReceiptRequestDto _$CreateReceiptRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _CreateReceiptRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CreateReceiptRequestDto {
  int get customerId => throw _privateConstructorUsedError;
  @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
  DateTime? get estimatedDeliveryDate => throw _privateConstructorUsedError;
  List<ReceiptItemRequestDto> get items => throw _privateConstructorUsedError;
  double? get prepaymentAmount => throw _privateConstructorUsedError;

  /// Serializes this CreateReceiptRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateReceiptRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateReceiptRequestDtoCopyWith<CreateReceiptRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateReceiptRequestDtoCopyWith<$Res> {
  factory $CreateReceiptRequestDtoCopyWith(CreateReceiptRequestDto value,
          $Res Function(CreateReceiptRequestDto) then) =
      _$CreateReceiptRequestDtoCopyWithImpl<$Res, CreateReceiptRequestDto>;
  @useResult
  $Res call(
      {int customerId,
      @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
      DateTime? estimatedDeliveryDate,
      List<ReceiptItemRequestDto> items,
      double? prepaymentAmount});
}

/// @nodoc
class _$CreateReceiptRequestDtoCopyWithImpl<$Res,
        $Val extends CreateReceiptRequestDto>
    implements $CreateReceiptRequestDtoCopyWith<$Res> {
  _$CreateReceiptRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateReceiptRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? estimatedDeliveryDate = freezed,
    Object? items = null,
    Object? prepaymentAmount = freezed,
  }) {
    return _then(_value.copyWith(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedDeliveryDate: freezed == estimatedDeliveryDate
          ? _value.estimatedDeliveryDate
          : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceiptItemRequestDto>,
      prepaymentAmount: freezed == prepaymentAmount
          ? _value.prepaymentAmount
          : prepaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateReceiptRequestDtoImplCopyWith<$Res>
    implements $CreateReceiptRequestDtoCopyWith<$Res> {
  factory _$$CreateReceiptRequestDtoImplCopyWith(
          _$CreateReceiptRequestDtoImpl value,
          $Res Function(_$CreateReceiptRequestDtoImpl) then) =
      __$$CreateReceiptRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int customerId,
      @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
      DateTime? estimatedDeliveryDate,
      List<ReceiptItemRequestDto> items,
      double? prepaymentAmount});
}

/// @nodoc
class __$$CreateReceiptRequestDtoImplCopyWithImpl<$Res>
    extends _$CreateReceiptRequestDtoCopyWithImpl<$Res,
        _$CreateReceiptRequestDtoImpl>
    implements _$$CreateReceiptRequestDtoImplCopyWith<$Res> {
  __$$CreateReceiptRequestDtoImplCopyWithImpl(
      _$CreateReceiptRequestDtoImpl _value,
      $Res Function(_$CreateReceiptRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateReceiptRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerId = null,
    Object? estimatedDeliveryDate = freezed,
    Object? items = null,
    Object? prepaymentAmount = freezed,
  }) {
    return _then(_$CreateReceiptRequestDtoImpl(
      customerId: null == customerId
          ? _value.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as int,
      estimatedDeliveryDate: freezed == estimatedDeliveryDate
          ? _value.estimatedDeliveryDate
          : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceiptItemRequestDto>,
      prepaymentAmount: freezed == prepaymentAmount
          ? _value.prepaymentAmount
          : prepaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateReceiptRequestDtoImpl implements _CreateReceiptRequestDto {
  const _$CreateReceiptRequestDtoImpl(
      {required this.customerId,
      @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
      this.estimatedDeliveryDate,
      required final List<ReceiptItemRequestDto> items,
      this.prepaymentAmount})
      : _items = items;

  factory _$CreateReceiptRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateReceiptRequestDtoImplFromJson(json);

  @override
  final int customerId;
  @override
  @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
  final DateTime? estimatedDeliveryDate;
  final List<ReceiptItemRequestDto> _items;
  @override
  List<ReceiptItemRequestDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final double? prepaymentAmount;

  @override
  String toString() {
    return 'CreateReceiptRequestDto(customerId: $customerId, estimatedDeliveryDate: $estimatedDeliveryDate, items: $items, prepaymentAmount: $prepaymentAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateReceiptRequestDtoImpl &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.estimatedDeliveryDate, estimatedDeliveryDate) ||
                other.estimatedDeliveryDate == estimatedDeliveryDate) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.prepaymentAmount, prepaymentAmount) ||
                other.prepaymentAmount == prepaymentAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      customerId,
      estimatedDeliveryDate,
      const DeepCollectionEquality().hash(_items),
      prepaymentAmount);

  /// Create a copy of CreateReceiptRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateReceiptRequestDtoImplCopyWith<_$CreateReceiptRequestDtoImpl>
      get copyWith => __$$CreateReceiptRequestDtoImplCopyWithImpl<
          _$CreateReceiptRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateReceiptRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _CreateReceiptRequestDto implements CreateReceiptRequestDto {
  const factory _CreateReceiptRequestDto(
      {required final int customerId,
      @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
      final DateTime? estimatedDeliveryDate,
      required final List<ReceiptItemRequestDto> items,
      final double? prepaymentAmount}) = _$CreateReceiptRequestDtoImpl;

  factory _CreateReceiptRequestDto.fromJson(Map<String, dynamic> json) =
      _$CreateReceiptRequestDtoImpl.fromJson;

  @override
  int get customerId;
  @override
  @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
  DateTime? get estimatedDeliveryDate;
  @override
  List<ReceiptItemRequestDto> get items;
  @override
  double? get prepaymentAmount;

  /// Create a copy of CreateReceiptRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateReceiptRequestDtoImplCopyWith<_$CreateReceiptRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReceiptItemRequestDto _$ReceiptItemRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _ReceiptItemRequestDto.fromJson(json);
}

/// @nodoc
mixin _$ReceiptItemRequestDto {
  int get categoryId => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get material => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get existingDamages => throw _privateConstructorUsedError;
  List<int> get servicePriceIds => throw _privateConstructorUsedError;
  List<ConsumableLineDto> get consumables => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  /// Serializes this ReceiptItemRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReceiptItemRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptItemRequestDtoCopyWith<ReceiptItemRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptItemRequestDtoCopyWith<$Res> {
  factory $ReceiptItemRequestDtoCopyWith(ReceiptItemRequestDto value,
          $Res Function(ReceiptItemRequestDto) then) =
      _$ReceiptItemRequestDtoCopyWithImpl<$Res, ReceiptItemRequestDto>;
  @useResult
  $Res call(
      {int categoryId,
      String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      List<int> servicePriceIds,
      List<ConsumableLineDto> consumables,
      double price});
}

/// @nodoc
class _$ReceiptItemRequestDtoCopyWithImpl<$Res,
        $Val extends ReceiptItemRequestDto>
    implements $ReceiptItemRequestDtoCopyWith<$Res> {
  _$ReceiptItemRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceiptItemRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? brand = freezed,
    Object? color = freezed,
    Object? material = freezed,
    Object? description = freezed,
    Object? existingDamages = freezed,
    Object? servicePriceIds = null,
    Object? consumables = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceiptItemRequestDtoImplCopyWith<$Res>
    implements $ReceiptItemRequestDtoCopyWith<$Res> {
  factory _$$ReceiptItemRequestDtoImplCopyWith(
          _$ReceiptItemRequestDtoImpl value,
          $Res Function(_$ReceiptItemRequestDtoImpl) then) =
      __$$ReceiptItemRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int categoryId,
      String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      List<int> servicePriceIds,
      List<ConsumableLineDto> consumables,
      double price});
}

/// @nodoc
class __$$ReceiptItemRequestDtoImplCopyWithImpl<$Res>
    extends _$ReceiptItemRequestDtoCopyWithImpl<$Res,
        _$ReceiptItemRequestDtoImpl>
    implements _$$ReceiptItemRequestDtoImplCopyWith<$Res> {
  __$$ReceiptItemRequestDtoImplCopyWithImpl(_$ReceiptItemRequestDtoImpl _value,
      $Res Function(_$ReceiptItemRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReceiptItemRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryId = null,
    Object? brand = freezed,
    Object? color = freezed,
    Object? material = freezed,
    Object? description = freezed,
    Object? existingDamages = freezed,
    Object? servicePriceIds = null,
    Object? consumables = null,
    Object? price = null,
  }) {
    return _then(_$ReceiptItemRequestDtoImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptItemRequestDtoImpl implements _ReceiptItemRequestDto {
  const _$ReceiptItemRequestDtoImpl(
      {required this.categoryId,
      this.brand,
      this.color,
      this.material,
      this.description,
      this.existingDamages,
      final List<int> servicePriceIds = const <int>[],
      final List<ConsumableLineDto> consumables = const <ConsumableLineDto>[],
      required this.price})
      : _servicePriceIds = servicePriceIds,
        _consumables = consumables;

  factory _$ReceiptItemRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptItemRequestDtoImplFromJson(json);

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
  String toString() {
    return 'ReceiptItemRequestDto(categoryId: $categoryId, brand: $brand, color: $color, material: $material, description: $description, existingDamages: $existingDamages, servicePriceIds: $servicePriceIds, consumables: $consumables, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptItemRequestDtoImpl &&
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
            const DeepCollectionEquality()
                .equals(other._servicePriceIds, _servicePriceIds) &&
            const DeepCollectionEquality()
                .equals(other._consumables, _consumables) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      categoryId,
      brand,
      color,
      material,
      description,
      existingDamages,
      const DeepCollectionEquality().hash(_servicePriceIds),
      const DeepCollectionEquality().hash(_consumables),
      price);

  /// Create a copy of ReceiptItemRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptItemRequestDtoImplCopyWith<_$ReceiptItemRequestDtoImpl>
      get copyWith => __$$ReceiptItemRequestDtoImplCopyWithImpl<
          _$ReceiptItemRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptItemRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _ReceiptItemRequestDto implements ReceiptItemRequestDto {
  const factory _ReceiptItemRequestDto(
      {required final int categoryId,
      final String? brand,
      final String? color,
      final String? material,
      final String? description,
      final String? existingDamages,
      final List<int> servicePriceIds,
      final List<ConsumableLineDto> consumables,
      required final double price}) = _$ReceiptItemRequestDtoImpl;

  factory _ReceiptItemRequestDto.fromJson(Map<String, dynamic> json) =
      _$ReceiptItemRequestDtoImpl.fromJson;

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
  List<int> get servicePriceIds;
  @override
  List<ConsumableLineDto> get consumables;
  @override
  double get price;

  /// Create a copy of ReceiptItemRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptItemRequestDtoImplCopyWith<_$ReceiptItemRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
