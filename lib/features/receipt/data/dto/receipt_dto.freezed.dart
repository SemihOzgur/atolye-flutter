// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReceiptDto _$ReceiptDtoFromJson(Map<String, dynamic> json) {
  return _ReceiptDto.fromJson(json);
}

/// @nodoc
mixin _$ReceiptDto {
  int get id => throw _privateConstructorUsedError;
  String get receiptNumber => throw _privateConstructorUsedError;
  CustomerDto get customer => throw _privateConstructorUsedError;
  String get trackingUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  double get totalPrice => throw _privateConstructorUsedError;
  double get prepaymentAmount => throw _privateConstructorUsedError;
  double get collectedAmount => throw _privateConstructorUsedError;
  double get remainingAmount => throw _privateConstructorUsedError;
  int get readyCount => throw _privateConstructorUsedError;
  int get activeCount => throw _privateConstructorUsedError;
  List<ReceiptItemDto> get items => throw _privateConstructorUsedError;
  List<WorkOrderSmsItemDto> get smsHistory =>
      throw _privateConstructorUsedError;

  /// Serializes this ReceiptDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptDtoCopyWith<ReceiptDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptDtoCopyWith<$Res> {
  factory $ReceiptDtoCopyWith(
          ReceiptDto value, $Res Function(ReceiptDto) then) =
      _$ReceiptDtoCopyWithImpl<$Res, ReceiptDto>;
  @useResult
  $Res call(
      {int id,
      String receiptNumber,
      CustomerDto customer,
      String trackingUrl,
      DateTime createdAt,
      double totalPrice,
      double prepaymentAmount,
      double collectedAmount,
      double remainingAmount,
      int readyCount,
      int activeCount,
      List<ReceiptItemDto> items,
      List<WorkOrderSmsItemDto> smsHistory});

  $CustomerDtoCopyWith<$Res> get customer;
}

/// @nodoc
class _$ReceiptDtoCopyWithImpl<$Res, $Val extends ReceiptDto>
    implements $ReceiptDtoCopyWith<$Res> {
  _$ReceiptDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? receiptNumber = null,
    Object? customer = null,
    Object? trackingUrl = null,
    Object? createdAt = null,
    Object? totalPrice = null,
    Object? prepaymentAmount = null,
    Object? collectedAmount = null,
    Object? remainingAmount = null,
    Object? readyCount = null,
    Object? activeCount = null,
    Object? items = null,
    Object? smsHistory = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      receiptNumber: null == receiptNumber
          ? _value.receiptNumber
          : receiptNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerDto,
      trackingUrl: null == trackingUrl
          ? _value.trackingUrl
          : trackingUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      prepaymentAmount: null == prepaymentAmount
          ? _value.prepaymentAmount
          : prepaymentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      collectedAmount: null == collectedAmount
          ? _value.collectedAmount
          : collectedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      readyCount: null == readyCount
          ? _value.readyCount
          : readyCount // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceiptItemDto>,
      smsHistory: null == smsHistory
          ? _value.smsHistory
          : smsHistory // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderSmsItemDto>,
    ) as $Val);
  }

  /// Create a copy of ReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerDtoCopyWith<$Res> get customer {
    return $CustomerDtoCopyWith<$Res>(_value.customer, (value) {
      return _then(_value.copyWith(customer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReceiptDtoImplCopyWith<$Res>
    implements $ReceiptDtoCopyWith<$Res> {
  factory _$$ReceiptDtoImplCopyWith(
          _$ReceiptDtoImpl value, $Res Function(_$ReceiptDtoImpl) then) =
      __$$ReceiptDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String receiptNumber,
      CustomerDto customer,
      String trackingUrl,
      DateTime createdAt,
      double totalPrice,
      double prepaymentAmount,
      double collectedAmount,
      double remainingAmount,
      int readyCount,
      int activeCount,
      List<ReceiptItemDto> items,
      List<WorkOrderSmsItemDto> smsHistory});

  @override
  $CustomerDtoCopyWith<$Res> get customer;
}

/// @nodoc
class __$$ReceiptDtoImplCopyWithImpl<$Res>
    extends _$ReceiptDtoCopyWithImpl<$Res, _$ReceiptDtoImpl>
    implements _$$ReceiptDtoImplCopyWith<$Res> {
  __$$ReceiptDtoImplCopyWithImpl(
      _$ReceiptDtoImpl _value, $Res Function(_$ReceiptDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? receiptNumber = null,
    Object? customer = null,
    Object? trackingUrl = null,
    Object? createdAt = null,
    Object? totalPrice = null,
    Object? prepaymentAmount = null,
    Object? collectedAmount = null,
    Object? remainingAmount = null,
    Object? readyCount = null,
    Object? activeCount = null,
    Object? items = null,
    Object? smsHistory = null,
  }) {
    return _then(_$ReceiptDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      receiptNumber: null == receiptNumber
          ? _value.receiptNumber
          : receiptNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerDto,
      trackingUrl: null == trackingUrl
          ? _value.trackingUrl
          : trackingUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      prepaymentAmount: null == prepaymentAmount
          ? _value.prepaymentAmount
          : prepaymentAmount // ignore: cast_nullable_to_non_nullable
              as double,
      collectedAmount: null == collectedAmount
          ? _value.collectedAmount
          : collectedAmount // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      readyCount: null == readyCount
          ? _value.readyCount
          : readyCount // ignore: cast_nullable_to_non_nullable
              as int,
      activeCount: null == activeCount
          ? _value.activeCount
          : activeCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ReceiptItemDto>,
      smsHistory: null == smsHistory
          ? _value._smsHistory
          : smsHistory // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderSmsItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptDtoImpl implements _ReceiptDto {
  const _$ReceiptDtoImpl(
      {required this.id,
      required this.receiptNumber,
      required this.customer,
      required this.trackingUrl,
      required this.createdAt,
      required this.totalPrice,
      required this.prepaymentAmount,
      required this.collectedAmount,
      required this.remainingAmount,
      required this.readyCount,
      required this.activeCount,
      final List<ReceiptItemDto> items = const <ReceiptItemDto>[],
      final List<WorkOrderSmsItemDto> smsHistory =
          const <WorkOrderSmsItemDto>[]})
      : _items = items,
        _smsHistory = smsHistory;

  factory _$ReceiptDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String receiptNumber;
  @override
  final CustomerDto customer;
  @override
  final String trackingUrl;
  @override
  final DateTime createdAt;
  @override
  final double totalPrice;
  @override
  final double prepaymentAmount;
  @override
  final double collectedAmount;
  @override
  final double remainingAmount;
  @override
  final int readyCount;
  @override
  final int activeCount;
  final List<ReceiptItemDto> _items;
  @override
  @JsonKey()
  List<ReceiptItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<WorkOrderSmsItemDto> _smsHistory;
  @override
  @JsonKey()
  List<WorkOrderSmsItemDto> get smsHistory {
    if (_smsHistory is EqualUnmodifiableListView) return _smsHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_smsHistory);
  }

  @override
  String toString() {
    return 'ReceiptDto(id: $id, receiptNumber: $receiptNumber, customer: $customer, trackingUrl: $trackingUrl, createdAt: $createdAt, totalPrice: $totalPrice, prepaymentAmount: $prepaymentAmount, collectedAmount: $collectedAmount, remainingAmount: $remainingAmount, readyCount: $readyCount, activeCount: $activeCount, items: $items, smsHistory: $smsHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.receiptNumber, receiptNumber) ||
                other.receiptNumber == receiptNumber) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.trackingUrl, trackingUrl) ||
                other.trackingUrl == trackingUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.prepaymentAmount, prepaymentAmount) ||
                other.prepaymentAmount == prepaymentAmount) &&
            (identical(other.collectedAmount, collectedAmount) ||
                other.collectedAmount == collectedAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.readyCount, readyCount) ||
                other.readyCount == readyCount) &&
            (identical(other.activeCount, activeCount) ||
                other.activeCount == activeCount) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._smsHistory, _smsHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      receiptNumber,
      customer,
      trackingUrl,
      createdAt,
      totalPrice,
      prepaymentAmount,
      collectedAmount,
      remainingAmount,
      readyCount,
      activeCount,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_smsHistory));

  /// Create a copy of ReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptDtoImplCopyWith<_$ReceiptDtoImpl> get copyWith =>
      __$$ReceiptDtoImplCopyWithImpl<_$ReceiptDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptDtoImplToJson(
      this,
    );
  }
}

abstract class _ReceiptDto implements ReceiptDto {
  const factory _ReceiptDto(
      {required final int id,
      required final String receiptNumber,
      required final CustomerDto customer,
      required final String trackingUrl,
      required final DateTime createdAt,
      required final double totalPrice,
      required final double prepaymentAmount,
      required final double collectedAmount,
      required final double remainingAmount,
      required final int readyCount,
      required final int activeCount,
      final List<ReceiptItemDto> items,
      final List<WorkOrderSmsItemDto> smsHistory}) = _$ReceiptDtoImpl;

  factory _ReceiptDto.fromJson(Map<String, dynamic> json) =
      _$ReceiptDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get receiptNumber;
  @override
  CustomerDto get customer;
  @override
  String get trackingUrl;
  @override
  DateTime get createdAt;
  @override
  double get totalPrice;
  @override
  double get prepaymentAmount;
  @override
  double get collectedAmount;
  @override
  double get remainingAmount;
  @override
  int get readyCount;
  @override
  int get activeCount;
  @override
  List<ReceiptItemDto> get items;
  @override
  List<WorkOrderSmsItemDto> get smsHistory;

  /// Create a copy of ReceiptDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptDtoImplCopyWith<_$ReceiptDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReceiptItemDto _$ReceiptItemDtoFromJson(Map<String, dynamic> json) {
  return _ReceiptItemDto.fromJson(json);
}

/// @nodoc
mixin _$ReceiptItemDto {
  int get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get categoryPath => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get material => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get existingDamages => throw _privateConstructorUsedError;
  @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
  DateTime? get estimatedDeliveryDate => throw _privateConstructorUsedError;
  List<String> get serviceNames => throw _privateConstructorUsedError;
  List<String> get consumableNames => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double? get prepaymentAmount => throw _privateConstructorUsedError;
  double? get finalPaymentAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get mediaCount => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ReceiptItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReceiptItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceiptItemDtoCopyWith<ReceiptItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceiptItemDtoCopyWith<$Res> {
  factory $ReceiptItemDtoCopyWith(
          ReceiptItemDto value, $Res Function(ReceiptItemDto) then) =
      _$ReceiptItemDtoCopyWithImpl<$Res, ReceiptItemDto>;
  @useResult
  $Res call(
      {int id,
      String orderNumber,
      String categoryPath,
      String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
      DateTime? estimatedDeliveryDate,
      List<String> serviceNames,
      List<String> consumableNames,
      double price,
      double? prepaymentAmount,
      double? finalPaymentAmount,
      String status,
      int mediaCount,
      DateTime updatedAt});
}

/// @nodoc
class _$ReceiptItemDtoCopyWithImpl<$Res, $Val extends ReceiptItemDto>
    implements $ReceiptItemDtoCopyWith<$Res> {
  _$ReceiptItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceiptItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? categoryPath = null,
    Object? brand = freezed,
    Object? color = freezed,
    Object? material = freezed,
    Object? description = freezed,
    Object? existingDamages = freezed,
    Object? estimatedDeliveryDate = freezed,
    Object? serviceNames = null,
    Object? consumableNames = null,
    Object? price = null,
    Object? prepaymentAmount = freezed,
    Object? finalPaymentAmount = freezed,
    Object? status = null,
    Object? mediaCount = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
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
      serviceNames: null == serviceNames
          ? _value.serviceNames
          : serviceNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      consumableNames: null == consumableNames
          ? _value.consumableNames
          : consumableNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      prepaymentAmount: freezed == prepaymentAmount
          ? _value.prepaymentAmount
          : prepaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      finalPaymentAmount: freezed == finalPaymentAmount
          ? _value.finalPaymentAmount
          : finalPaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      mediaCount: null == mediaCount
          ? _value.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceiptItemDtoImplCopyWith<$Res>
    implements $ReceiptItemDtoCopyWith<$Res> {
  factory _$$ReceiptItemDtoImplCopyWith(_$ReceiptItemDtoImpl value,
          $Res Function(_$ReceiptItemDtoImpl) then) =
      __$$ReceiptItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String orderNumber,
      String categoryPath,
      String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
      DateTime? estimatedDeliveryDate,
      List<String> serviceNames,
      List<String> consumableNames,
      double price,
      double? prepaymentAmount,
      double? finalPaymentAmount,
      String status,
      int mediaCount,
      DateTime updatedAt});
}

/// @nodoc
class __$$ReceiptItemDtoImplCopyWithImpl<$Res>
    extends _$ReceiptItemDtoCopyWithImpl<$Res, _$ReceiptItemDtoImpl>
    implements _$$ReceiptItemDtoImplCopyWith<$Res> {
  __$$ReceiptItemDtoImplCopyWithImpl(
      _$ReceiptItemDtoImpl _value, $Res Function(_$ReceiptItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReceiptItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? categoryPath = null,
    Object? brand = freezed,
    Object? color = freezed,
    Object? material = freezed,
    Object? description = freezed,
    Object? existingDamages = freezed,
    Object? estimatedDeliveryDate = freezed,
    Object? serviceNames = null,
    Object? consumableNames = null,
    Object? price = null,
    Object? prepaymentAmount = freezed,
    Object? finalPaymentAmount = freezed,
    Object? status = null,
    Object? mediaCount = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ReceiptItemDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
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
      serviceNames: null == serviceNames
          ? _value._serviceNames
          : serviceNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      consumableNames: null == consumableNames
          ? _value._consumableNames
          : consumableNames // ignore: cast_nullable_to_non_nullable
              as List<String>,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      prepaymentAmount: freezed == prepaymentAmount
          ? _value.prepaymentAmount
          : prepaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      finalPaymentAmount: freezed == finalPaymentAmount
          ? _value.finalPaymentAmount
          : finalPaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      mediaCount: null == mediaCount
          ? _value.mediaCount
          : mediaCount // ignore: cast_nullable_to_non_nullable
              as int,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceiptItemDtoImpl implements _ReceiptItemDto {
  const _$ReceiptItemDtoImpl(
      {required this.id,
      required this.orderNumber,
      required this.categoryPath,
      this.brand,
      this.color,
      this.material,
      this.description,
      this.existingDamages,
      @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
      this.estimatedDeliveryDate,
      final List<String> serviceNames = const <String>[],
      final List<String> consumableNames = const <String>[],
      required this.price,
      this.prepaymentAmount,
      this.finalPaymentAmount,
      required this.status,
      required this.mediaCount,
      required this.updatedAt})
      : _serviceNames = serviceNames,
        _consumableNames = consumableNames;

  factory _$ReceiptItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceiptItemDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String orderNumber;
  @override
  final String categoryPath;
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
  @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
  final DateTime? estimatedDeliveryDate;
  final List<String> _serviceNames;
  @override
  @JsonKey()
  List<String> get serviceNames {
    if (_serviceNames is EqualUnmodifiableListView) return _serviceNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_serviceNames);
  }

  final List<String> _consumableNames;
  @override
  @JsonKey()
  List<String> get consumableNames {
    if (_consumableNames is EqualUnmodifiableListView) return _consumableNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_consumableNames);
  }

  @override
  final double price;
  @override
  final double? prepaymentAmount;
  @override
  final double? finalPaymentAmount;
  @override
  final String status;
  @override
  final int mediaCount;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ReceiptItemDto(id: $id, orderNumber: $orderNumber, categoryPath: $categoryPath, brand: $brand, color: $color, material: $material, description: $description, existingDamages: $existingDamages, estimatedDeliveryDate: $estimatedDeliveryDate, serviceNames: $serviceNames, consumableNames: $consumableNames, price: $price, prepaymentAmount: $prepaymentAmount, finalPaymentAmount: $finalPaymentAmount, status: $status, mediaCount: $mediaCount, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceiptItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.categoryPath, categoryPath) ||
                other.categoryPath == categoryPath) &&
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
                .equals(other._serviceNames, _serviceNames) &&
            const DeepCollectionEquality()
                .equals(other._consumableNames, _consumableNames) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.prepaymentAmount, prepaymentAmount) ||
                other.prepaymentAmount == prepaymentAmount) &&
            (identical(other.finalPaymentAmount, finalPaymentAmount) ||
                other.finalPaymentAmount == finalPaymentAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.mediaCount, mediaCount) ||
                other.mediaCount == mediaCount) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderNumber,
      categoryPath,
      brand,
      color,
      material,
      description,
      existingDamages,
      estimatedDeliveryDate,
      const DeepCollectionEquality().hash(_serviceNames),
      const DeepCollectionEquality().hash(_consumableNames),
      price,
      prepaymentAmount,
      finalPaymentAmount,
      status,
      mediaCount,
      updatedAt);

  /// Create a copy of ReceiptItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceiptItemDtoImplCopyWith<_$ReceiptItemDtoImpl> get copyWith =>
      __$$ReceiptItemDtoImplCopyWithImpl<_$ReceiptItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceiptItemDtoImplToJson(
      this,
    );
  }
}

abstract class _ReceiptItemDto implements ReceiptItemDto {
  const factory _ReceiptItemDto(
      {required final int id,
      required final String orderNumber,
      required final String categoryPath,
      final String? brand,
      final String? color,
      final String? material,
      final String? description,
      final String? existingDamages,
      @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
      final DateTime? estimatedDeliveryDate,
      final List<String> serviceNames,
      final List<String> consumableNames,
      required final double price,
      final double? prepaymentAmount,
      final double? finalPaymentAmount,
      required final String status,
      required final int mediaCount,
      required final DateTime updatedAt}) = _$ReceiptItemDtoImpl;

  factory _ReceiptItemDto.fromJson(Map<String, dynamic> json) =
      _$ReceiptItemDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get orderNumber;
  @override
  String get categoryPath;
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
  @JsonKey(toJson: dateOnlyToJson, fromJson: dateOnlyFromJson)
  DateTime? get estimatedDeliveryDate;
  @override
  List<String> get serviceNames;
  @override
  List<String> get consumableNames;
  @override
  double get price;
  @override
  double? get prepaymentAmount;
  @override
  double? get finalPaymentAmount;
  @override
  String get status;
  @override
  int get mediaCount;
  @override
  DateTime get updatedAt;

  /// Create a copy of ReceiptItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceiptItemDtoImplCopyWith<_$ReceiptItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
