// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkOrderDto _$WorkOrderDtoFromJson(Map<String, dynamic> json) {
  return _WorkOrderDto.fromJson(json);
}

/// @nodoc
mixin _$WorkOrderDto {
  int get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  CustomerDto get customer => throw _privateConstructorUsedError;
  int get categoryId => throw _privateConstructorUsedError;
  String get categoryPath => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get material => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get existingDamages => throw _privateConstructorUsedError;
  DateTime? get estimatedDeliveryDate => throw _privateConstructorUsedError;
  List<WorkOrderServiceItemDto> get services =>
      throw _privateConstructorUsedError;
  List<WorkOrderConsumableItemDto> get consumables =>
      throw _privateConstructorUsedError;
  double get suggestedPrice => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  bool get hasPrepayment => throw _privateConstructorUsedError;
  double? get prepaymentAmount => throw _privateConstructorUsedError;
  double get remainingAmount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get socialMediaConsent => throw _privateConstructorUsedError;
  String get trackingUrl => throw _privateConstructorUsedError;
  DateTime? get deliveredAt => throw _privateConstructorUsedError;
  double? get finalPaymentAmount => throw _privateConstructorUsedError;
  List<MediaFileDto> get media => throw _privateConstructorUsedError;
  List<StatusLogDto> get statusHistory => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<WorkOrderSmsItemDto> get smsHistory =>
      throw _privateConstructorUsedError;

  /// Serializes this WorkOrderDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkOrderDtoCopyWith<WorkOrderDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkOrderDtoCopyWith<$Res> {
  factory $WorkOrderDtoCopyWith(
          WorkOrderDto value, $Res Function(WorkOrderDto) then) =
      _$WorkOrderDtoCopyWithImpl<$Res, WorkOrderDto>;
  @useResult
  $Res call(
      {int id,
      String orderNumber,
      CustomerDto customer,
      int categoryId,
      String categoryPath,
      String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      DateTime? estimatedDeliveryDate,
      List<WorkOrderServiceItemDto> services,
      List<WorkOrderConsumableItemDto> consumables,
      double suggestedPrice,
      double price,
      bool hasPrepayment,
      double? prepaymentAmount,
      double remainingAmount,
      String status,
      bool socialMediaConsent,
      String trackingUrl,
      DateTime? deliveredAt,
      double? finalPaymentAmount,
      List<MediaFileDto> media,
      List<StatusLogDto> statusHistory,
      DateTime createdAt,
      DateTime updatedAt,
      List<WorkOrderSmsItemDto> smsHistory});

  $CustomerDtoCopyWith<$Res> get customer;
}

/// @nodoc
class _$WorkOrderDtoCopyWithImpl<$Res, $Val extends WorkOrderDto>
    implements $WorkOrderDtoCopyWith<$Res> {
  _$WorkOrderDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customer = null,
    Object? categoryId = null,
    Object? categoryPath = null,
    Object? brand = freezed,
    Object? color = freezed,
    Object? material = freezed,
    Object? description = freezed,
    Object? existingDamages = freezed,
    Object? estimatedDeliveryDate = freezed,
    Object? services = null,
    Object? consumables = null,
    Object? suggestedPrice = null,
    Object? price = null,
    Object? hasPrepayment = null,
    Object? prepaymentAmount = freezed,
    Object? remainingAmount = null,
    Object? status = null,
    Object? socialMediaConsent = null,
    Object? trackingUrl = null,
    Object? deliveredAt = freezed,
    Object? finalPaymentAmount = freezed,
    Object? media = null,
    Object? statusHistory = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? smsHistory = null,
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
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerDto,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
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
      services: null == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderServiceItemDto>,
      consumables: null == consumables
          ? _value.consumables
          : consumables // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderConsumableItemDto>,
      suggestedPrice: null == suggestedPrice
          ? _value.suggestedPrice
          : suggestedPrice // ignore: cast_nullable_to_non_nullable
              as double,
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
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      socialMediaConsent: null == socialMediaConsent
          ? _value.socialMediaConsent
          : socialMediaConsent // ignore: cast_nullable_to_non_nullable
              as bool,
      trackingUrl: null == trackingUrl
          ? _value.trackingUrl
          : trackingUrl // ignore: cast_nullable_to_non_nullable
              as String,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finalPaymentAmount: freezed == finalPaymentAmount
          ? _value.finalPaymentAmount
          : finalPaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<MediaFileDto>,
      statusHistory: null == statusHistory
          ? _value.statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<StatusLogDto>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      smsHistory: null == smsHistory
          ? _value.smsHistory
          : smsHistory // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderSmsItemDto>,
    ) as $Val);
  }

  /// Create a copy of WorkOrderDto
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
abstract class _$$WorkOrderDtoImplCopyWith<$Res>
    implements $WorkOrderDtoCopyWith<$Res> {
  factory _$$WorkOrderDtoImplCopyWith(
          _$WorkOrderDtoImpl value, $Res Function(_$WorkOrderDtoImpl) then) =
      __$$WorkOrderDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String orderNumber,
      CustomerDto customer,
      int categoryId,
      String categoryPath,
      String? brand,
      String? color,
      String? material,
      String? description,
      String? existingDamages,
      DateTime? estimatedDeliveryDate,
      List<WorkOrderServiceItemDto> services,
      List<WorkOrderConsumableItemDto> consumables,
      double suggestedPrice,
      double price,
      bool hasPrepayment,
      double? prepaymentAmount,
      double remainingAmount,
      String status,
      bool socialMediaConsent,
      String trackingUrl,
      DateTime? deliveredAt,
      double? finalPaymentAmount,
      List<MediaFileDto> media,
      List<StatusLogDto> statusHistory,
      DateTime createdAt,
      DateTime updatedAt,
      List<WorkOrderSmsItemDto> smsHistory});

  @override
  $CustomerDtoCopyWith<$Res> get customer;
}

/// @nodoc
class __$$WorkOrderDtoImplCopyWithImpl<$Res>
    extends _$WorkOrderDtoCopyWithImpl<$Res, _$WorkOrderDtoImpl>
    implements _$$WorkOrderDtoImplCopyWith<$Res> {
  __$$WorkOrderDtoImplCopyWithImpl(
      _$WorkOrderDtoImpl _value, $Res Function(_$WorkOrderDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customer = null,
    Object? categoryId = null,
    Object? categoryPath = null,
    Object? brand = freezed,
    Object? color = freezed,
    Object? material = freezed,
    Object? description = freezed,
    Object? existingDamages = freezed,
    Object? estimatedDeliveryDate = freezed,
    Object? services = null,
    Object? consumables = null,
    Object? suggestedPrice = null,
    Object? price = null,
    Object? hasPrepayment = null,
    Object? prepaymentAmount = freezed,
    Object? remainingAmount = null,
    Object? status = null,
    Object? socialMediaConsent = null,
    Object? trackingUrl = null,
    Object? deliveredAt = freezed,
    Object? finalPaymentAmount = freezed,
    Object? media = null,
    Object? statusHistory = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? smsHistory = null,
  }) {
    return _then(_$WorkOrderDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerDto,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int,
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
      services: null == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderServiceItemDto>,
      consumables: null == consumables
          ? _value._consumables
          : consumables // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderConsumableItemDto>,
      suggestedPrice: null == suggestedPrice
          ? _value.suggestedPrice
          : suggestedPrice // ignore: cast_nullable_to_non_nullable
              as double,
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
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      socialMediaConsent: null == socialMediaConsent
          ? _value.socialMediaConsent
          : socialMediaConsent // ignore: cast_nullable_to_non_nullable
              as bool,
      trackingUrl: null == trackingUrl
          ? _value.trackingUrl
          : trackingUrl // ignore: cast_nullable_to_non_nullable
              as String,
      deliveredAt: freezed == deliveredAt
          ? _value.deliveredAt
          : deliveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finalPaymentAmount: freezed == finalPaymentAmount
          ? _value.finalPaymentAmount
          : finalPaymentAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<MediaFileDto>,
      statusHistory: null == statusHistory
          ? _value._statusHistory
          : statusHistory // ignore: cast_nullable_to_non_nullable
              as List<StatusLogDto>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      smsHistory: null == smsHistory
          ? _value._smsHistory
          : smsHistory // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderSmsItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkOrderDtoImpl implements _WorkOrderDto {
  const _$WorkOrderDtoImpl(
      {required this.id,
      required this.orderNumber,
      required this.customer,
      required this.categoryId,
      required this.categoryPath,
      this.brand,
      this.color,
      this.material,
      this.description,
      this.existingDamages,
      this.estimatedDeliveryDate,
      final List<WorkOrderServiceItemDto> services =
          const <WorkOrderServiceItemDto>[],
      final List<WorkOrderConsumableItemDto> consumables =
          const <WorkOrderConsumableItemDto>[],
      required this.suggestedPrice,
      required this.price,
      required this.hasPrepayment,
      this.prepaymentAmount,
      required this.remainingAmount,
      required this.status,
      required this.socialMediaConsent,
      required this.trackingUrl,
      this.deliveredAt,
      this.finalPaymentAmount,
      final List<MediaFileDto> media = const <MediaFileDto>[],
      final List<StatusLogDto> statusHistory = const <StatusLogDto>[],
      required this.createdAt,
      required this.updatedAt,
      final List<WorkOrderSmsItemDto> smsHistory =
          const <WorkOrderSmsItemDto>[]})
      : _services = services,
        _consumables = consumables,
        _media = media,
        _statusHistory = statusHistory,
        _smsHistory = smsHistory;

  factory _$WorkOrderDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkOrderDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String orderNumber;
  @override
  final CustomerDto customer;
  @override
  final int categoryId;
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
  final DateTime? estimatedDeliveryDate;
  final List<WorkOrderServiceItemDto> _services;
  @override
  @JsonKey()
  List<WorkOrderServiceItemDto> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  final List<WorkOrderConsumableItemDto> _consumables;
  @override
  @JsonKey()
  List<WorkOrderConsumableItemDto> get consumables {
    if (_consumables is EqualUnmodifiableListView) return _consumables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_consumables);
  }

  @override
  final double suggestedPrice;
  @override
  final double price;
  @override
  final bool hasPrepayment;
  @override
  final double? prepaymentAmount;
  @override
  final double remainingAmount;
  @override
  final String status;
  @override
  final bool socialMediaConsent;
  @override
  final String trackingUrl;
  @override
  final DateTime? deliveredAt;
  @override
  final double? finalPaymentAmount;
  final List<MediaFileDto> _media;
  @override
  @JsonKey()
  List<MediaFileDto> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  final List<StatusLogDto> _statusHistory;
  @override
  @JsonKey()
  List<StatusLogDto> get statusHistory {
    if (_statusHistory is EqualUnmodifiableListView) return _statusHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statusHistory);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
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
    return 'WorkOrderDto(id: $id, orderNumber: $orderNumber, customer: $customer, categoryId: $categoryId, categoryPath: $categoryPath, brand: $brand, color: $color, material: $material, description: $description, existingDamages: $existingDamages, estimatedDeliveryDate: $estimatedDeliveryDate, services: $services, consumables: $consumables, suggestedPrice: $suggestedPrice, price: $price, hasPrepayment: $hasPrepayment, prepaymentAmount: $prepaymentAmount, remainingAmount: $remainingAmount, status: $status, socialMediaConsent: $socialMediaConsent, trackingUrl: $trackingUrl, deliveredAt: $deliveredAt, finalPaymentAmount: $finalPaymentAmount, media: $media, statusHistory: $statusHistory, createdAt: $createdAt, updatedAt: $updatedAt, smsHistory: $smsHistory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkOrderDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
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
            const DeepCollectionEquality().equals(other._services, _services) &&
            const DeepCollectionEquality()
                .equals(other._consumables, _consumables) &&
            (identical(other.suggestedPrice, suggestedPrice) ||
                other.suggestedPrice == suggestedPrice) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.hasPrepayment, hasPrepayment) ||
                other.hasPrepayment == hasPrepayment) &&
            (identical(other.prepaymentAmount, prepaymentAmount) ||
                other.prepaymentAmount == prepaymentAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.socialMediaConsent, socialMediaConsent) ||
                other.socialMediaConsent == socialMediaConsent) &&
            (identical(other.trackingUrl, trackingUrl) ||
                other.trackingUrl == trackingUrl) &&
            (identical(other.deliveredAt, deliveredAt) ||
                other.deliveredAt == deliveredAt) &&
            (identical(other.finalPaymentAmount, finalPaymentAmount) ||
                other.finalPaymentAmount == finalPaymentAmount) &&
            const DeepCollectionEquality().equals(other._media, _media) &&
            const DeepCollectionEquality()
                .equals(other._statusHistory, _statusHistory) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._smsHistory, _smsHistory));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderNumber,
        customer,
        categoryId,
        categoryPath,
        brand,
        color,
        material,
        description,
        existingDamages,
        estimatedDeliveryDate,
        const DeepCollectionEquality().hash(_services),
        const DeepCollectionEquality().hash(_consumables),
        suggestedPrice,
        price,
        hasPrepayment,
        prepaymentAmount,
        remainingAmount,
        status,
        socialMediaConsent,
        trackingUrl,
        deliveredAt,
        finalPaymentAmount,
        const DeepCollectionEquality().hash(_media),
        const DeepCollectionEquality().hash(_statusHistory),
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_smsHistory)
      ]);

  /// Create a copy of WorkOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkOrderDtoImplCopyWith<_$WorkOrderDtoImpl> get copyWith =>
      __$$WorkOrderDtoImplCopyWithImpl<_$WorkOrderDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkOrderDtoImplToJson(
      this,
    );
  }
}

abstract class _WorkOrderDto implements WorkOrderDto {
  const factory _WorkOrderDto(
      {required final int id,
      required final String orderNumber,
      required final CustomerDto customer,
      required final int categoryId,
      required final String categoryPath,
      final String? brand,
      final String? color,
      final String? material,
      final String? description,
      final String? existingDamages,
      final DateTime? estimatedDeliveryDate,
      final List<WorkOrderServiceItemDto> services,
      final List<WorkOrderConsumableItemDto> consumables,
      required final double suggestedPrice,
      required final double price,
      required final bool hasPrepayment,
      final double? prepaymentAmount,
      required final double remainingAmount,
      required final String status,
      required final bool socialMediaConsent,
      required final String trackingUrl,
      final DateTime? deliveredAt,
      final double? finalPaymentAmount,
      final List<MediaFileDto> media,
      final List<StatusLogDto> statusHistory,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final List<WorkOrderSmsItemDto> smsHistory}) = _$WorkOrderDtoImpl;

  factory _WorkOrderDto.fromJson(Map<String, dynamic> json) =
      _$WorkOrderDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get orderNumber;
  @override
  CustomerDto get customer;
  @override
  int get categoryId;
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
  DateTime? get estimatedDeliveryDate;
  @override
  List<WorkOrderServiceItemDto> get services;
  @override
  List<WorkOrderConsumableItemDto> get consumables;
  @override
  double get suggestedPrice;
  @override
  double get price;
  @override
  bool get hasPrepayment;
  @override
  double? get prepaymentAmount;
  @override
  double get remainingAmount;
  @override
  String get status;
  @override
  bool get socialMediaConsent;
  @override
  String get trackingUrl;
  @override
  DateTime? get deliveredAt;
  @override
  double? get finalPaymentAmount;
  @override
  List<MediaFileDto> get media;
  @override
  List<StatusLogDto> get statusHistory;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  List<WorkOrderSmsItemDto> get smsHistory;

  /// Create a copy of WorkOrderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkOrderDtoImplCopyWith<_$WorkOrderDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
