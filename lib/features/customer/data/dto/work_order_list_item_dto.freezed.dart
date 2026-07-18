// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order_list_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkOrderListItemDto _$WorkOrderListItemDtoFromJson(Map<String, dynamic> json) {
  return _WorkOrderListItemDto.fromJson(json);
}

/// @nodoc
mixin _$WorkOrderListItemDto {
  int get id => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get customerFullName => throw _privateConstructorUsedError;
  String get customerPhone => throw _privateConstructorUsedError;
  String get categoryPath => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get remainingAmount => throw _privateConstructorUsedError;
  DateTime? get estimatedDeliveryDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WorkOrderListItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkOrderListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkOrderListItemDtoCopyWith<WorkOrderListItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkOrderListItemDtoCopyWith<$Res> {
  factory $WorkOrderListItemDtoCopyWith(WorkOrderListItemDto value,
          $Res Function(WorkOrderListItemDto) then) =
      _$WorkOrderListItemDtoCopyWithImpl<$Res, WorkOrderListItemDto>;
  @useResult
  $Res call(
      {int id,
      String orderNumber,
      String customerFullName,
      String customerPhone,
      String categoryPath,
      String? brand,
      String status,
      double price,
      double remainingAmount,
      DateTime? estimatedDeliveryDate,
      DateTime createdAt});
}

/// @nodoc
class _$WorkOrderListItemDtoCopyWithImpl<$Res,
        $Val extends WorkOrderListItemDto>
    implements $WorkOrderListItemDtoCopyWith<$Res> {
  _$WorkOrderListItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkOrderListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerFullName = null,
    Object? customerPhone = null,
    Object? categoryPath = null,
    Object? brand = freezed,
    Object? status = null,
    Object? price = null,
    Object? remainingAmount = null,
    Object? estimatedDeliveryDate = freezed,
    Object? createdAt = null,
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
      customerFullName: null == customerFullName
          ? _value.customerFullName
          : customerFullName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedDeliveryDate: freezed == estimatedDeliveryDate
          ? _value.estimatedDeliveryDate
          : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkOrderListItemDtoImplCopyWith<$Res>
    implements $WorkOrderListItemDtoCopyWith<$Res> {
  factory _$$WorkOrderListItemDtoImplCopyWith(_$WorkOrderListItemDtoImpl value,
          $Res Function(_$WorkOrderListItemDtoImpl) then) =
      __$$WorkOrderListItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String orderNumber,
      String customerFullName,
      String customerPhone,
      String categoryPath,
      String? brand,
      String status,
      double price,
      double remainingAmount,
      DateTime? estimatedDeliveryDate,
      DateTime createdAt});
}

/// @nodoc
class __$$WorkOrderListItemDtoImplCopyWithImpl<$Res>
    extends _$WorkOrderListItemDtoCopyWithImpl<$Res, _$WorkOrderListItemDtoImpl>
    implements _$$WorkOrderListItemDtoImplCopyWith<$Res> {
  __$$WorkOrderListItemDtoImplCopyWithImpl(_$WorkOrderListItemDtoImpl _value,
      $Res Function(_$WorkOrderListItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkOrderListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? customerFullName = null,
    Object? customerPhone = null,
    Object? categoryPath = null,
    Object? brand = freezed,
    Object? status = null,
    Object? price = null,
    Object? remainingAmount = null,
    Object? estimatedDeliveryDate = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$WorkOrderListItemDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      customerFullName: null == customerFullName
          ? _value.customerFullName
          : customerFullName // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhone: null == customerPhone
          ? _value.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      remainingAmount: null == remainingAmount
          ? _value.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedDeliveryDate: freezed == estimatedDeliveryDate
          ? _value.estimatedDeliveryDate
          : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkOrderListItemDtoImpl implements _WorkOrderListItemDto {
  const _$WorkOrderListItemDtoImpl(
      {required this.id,
      required this.orderNumber,
      required this.customerFullName,
      required this.customerPhone,
      required this.categoryPath,
      this.brand,
      required this.status,
      required this.price,
      required this.remainingAmount,
      this.estimatedDeliveryDate,
      required this.createdAt});

  factory _$WorkOrderListItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkOrderListItemDtoImplFromJson(json);

  @override
  final int id;
  @override
  final String orderNumber;
  @override
  final String customerFullName;
  @override
  final String customerPhone;
  @override
  final String categoryPath;
  @override
  final String? brand;
  @override
  final String status;
  @override
  final double price;
  @override
  final double remainingAmount;
  @override
  final DateTime? estimatedDeliveryDate;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'WorkOrderListItemDto(id: $id, orderNumber: $orderNumber, customerFullName: $customerFullName, customerPhone: $customerPhone, categoryPath: $categoryPath, brand: $brand, status: $status, price: $price, remainingAmount: $remainingAmount, estimatedDeliveryDate: $estimatedDeliveryDate, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkOrderListItemDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.customerFullName, customerFullName) ||
                other.customerFullName == customerFullName) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.categoryPath, categoryPath) ||
                other.categoryPath == categoryPath) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
            (identical(other.estimatedDeliveryDate, estimatedDeliveryDate) ||
                other.estimatedDeliveryDate == estimatedDeliveryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      orderNumber,
      customerFullName,
      customerPhone,
      categoryPath,
      brand,
      status,
      price,
      remainingAmount,
      estimatedDeliveryDate,
      createdAt);

  /// Create a copy of WorkOrderListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkOrderListItemDtoImplCopyWith<_$WorkOrderListItemDtoImpl>
      get copyWith =>
          __$$WorkOrderListItemDtoImplCopyWithImpl<_$WorkOrderListItemDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkOrderListItemDtoImplToJson(
      this,
    );
  }
}

abstract class _WorkOrderListItemDto implements WorkOrderListItemDto {
  const factory _WorkOrderListItemDto(
      {required final int id,
      required final String orderNumber,
      required final String customerFullName,
      required final String customerPhone,
      required final String categoryPath,
      final String? brand,
      required final String status,
      required final double price,
      required final double remainingAmount,
      final DateTime? estimatedDeliveryDate,
      required final DateTime createdAt}) = _$WorkOrderListItemDtoImpl;

  factory _WorkOrderListItemDto.fromJson(Map<String, dynamic> json) =
      _$WorkOrderListItemDtoImpl.fromJson;

  @override
  int get id;
  @override
  String get orderNumber;
  @override
  String get customerFullName;
  @override
  String get customerPhone;
  @override
  String get categoryPath;
  @override
  String? get brand;
  @override
  String get status;
  @override
  double get price;
  @override
  double get remainingAmount;
  @override
  DateTime? get estimatedDeliveryDate;
  @override
  DateTime get createdAt;

  /// Create a copy of WorkOrderListItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkOrderListItemDtoImplCopyWith<_$WorkOrderListItemDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
