// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order_consumable_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WorkOrderConsumableItemDto _$WorkOrderConsumableItemDtoFromJson(
    Map<String, dynamic> json) {
  return _WorkOrderConsumableItemDto.fromJson(json);
}

/// @nodoc
mixin _$WorkOrderConsumableItemDto {
  int get consumableProductId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  double get unitPriceSnapshot => throw _privateConstructorUsedError;
  double get lineTotal => throw _privateConstructorUsedError;

  /// Serializes this WorkOrderConsumableItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WorkOrderConsumableItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WorkOrderConsumableItemDtoCopyWith<WorkOrderConsumableItemDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkOrderConsumableItemDtoCopyWith<$Res> {
  factory $WorkOrderConsumableItemDtoCopyWith(WorkOrderConsumableItemDto value,
          $Res Function(WorkOrderConsumableItemDto) then) =
      _$WorkOrderConsumableItemDtoCopyWithImpl<$Res,
          WorkOrderConsumableItemDto>;
  @useResult
  $Res call(
      {int consumableProductId,
      String productName,
      int quantity,
      double unitPriceSnapshot,
      double lineTotal});
}

/// @nodoc
class _$WorkOrderConsumableItemDtoCopyWithImpl<$Res,
        $Val extends WorkOrderConsumableItemDto>
    implements $WorkOrderConsumableItemDtoCopyWith<$Res> {
  _$WorkOrderConsumableItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WorkOrderConsumableItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consumableProductId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? unitPriceSnapshot = null,
    Object? lineTotal = null,
  }) {
    return _then(_value.copyWith(
      consumableProductId: null == consumableProductId
          ? _value.consumableProductId
          : consumableProductId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPriceSnapshot: null == unitPriceSnapshot
          ? _value.unitPriceSnapshot
          : unitPriceSnapshot // ignore: cast_nullable_to_non_nullable
              as double,
      lineTotal: null == lineTotal
          ? _value.lineTotal
          : lineTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkOrderConsumableItemDtoImplCopyWith<$Res>
    implements $WorkOrderConsumableItemDtoCopyWith<$Res> {
  factory _$$WorkOrderConsumableItemDtoImplCopyWith(
          _$WorkOrderConsumableItemDtoImpl value,
          $Res Function(_$WorkOrderConsumableItemDtoImpl) then) =
      __$$WorkOrderConsumableItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int consumableProductId,
      String productName,
      int quantity,
      double unitPriceSnapshot,
      double lineTotal});
}

/// @nodoc
class __$$WorkOrderConsumableItemDtoImplCopyWithImpl<$Res>
    extends _$WorkOrderConsumableItemDtoCopyWithImpl<$Res,
        _$WorkOrderConsumableItemDtoImpl>
    implements _$$WorkOrderConsumableItemDtoImplCopyWith<$Res> {
  __$$WorkOrderConsumableItemDtoImplCopyWithImpl(
      _$WorkOrderConsumableItemDtoImpl _value,
      $Res Function(_$WorkOrderConsumableItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WorkOrderConsumableItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? consumableProductId = null,
    Object? productName = null,
    Object? quantity = null,
    Object? unitPriceSnapshot = null,
    Object? lineTotal = null,
  }) {
    return _then(_$WorkOrderConsumableItemDtoImpl(
      consumableProductId: null == consumableProductId
          ? _value.consumableProductId
          : consumableProductId // ignore: cast_nullable_to_non_nullable
              as int,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPriceSnapshot: null == unitPriceSnapshot
          ? _value.unitPriceSnapshot
          : unitPriceSnapshot // ignore: cast_nullable_to_non_nullable
              as double,
      lineTotal: null == lineTotal
          ? _value.lineTotal
          : lineTotal // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkOrderConsumableItemDtoImpl implements _WorkOrderConsumableItemDto {
  const _$WorkOrderConsumableItemDtoImpl(
      {required this.consumableProductId,
      required this.productName,
      required this.quantity,
      required this.unitPriceSnapshot,
      required this.lineTotal});

  factory _$WorkOrderConsumableItemDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$WorkOrderConsumableItemDtoImplFromJson(json);

  @override
  final int consumableProductId;
  @override
  final String productName;
  @override
  final int quantity;
  @override
  final double unitPriceSnapshot;
  @override
  final double lineTotal;

  @override
  String toString() {
    return 'WorkOrderConsumableItemDto(consumableProductId: $consumableProductId, productName: $productName, quantity: $quantity, unitPriceSnapshot: $unitPriceSnapshot, lineTotal: $lineTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkOrderConsumableItemDtoImpl &&
            (identical(other.consumableProductId, consumableProductId) ||
                other.consumableProductId == consumableProductId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPriceSnapshot, unitPriceSnapshot) ||
                other.unitPriceSnapshot == unitPriceSnapshot) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, consumableProductId, productName,
      quantity, unitPriceSnapshot, lineTotal);

  /// Create a copy of WorkOrderConsumableItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkOrderConsumableItemDtoImplCopyWith<_$WorkOrderConsumableItemDtoImpl>
      get copyWith => __$$WorkOrderConsumableItemDtoImplCopyWithImpl<
          _$WorkOrderConsumableItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkOrderConsumableItemDtoImplToJson(
      this,
    );
  }
}

abstract class _WorkOrderConsumableItemDto
    implements WorkOrderConsumableItemDto {
  const factory _WorkOrderConsumableItemDto(
      {required final int consumableProductId,
      required final String productName,
      required final int quantity,
      required final double unitPriceSnapshot,
      required final double lineTotal}) = _$WorkOrderConsumableItemDtoImpl;

  factory _WorkOrderConsumableItemDto.fromJson(Map<String, dynamic> json) =
      _$WorkOrderConsumableItemDtoImpl.fromJson;

  @override
  int get consumableProductId;
  @override
  String get productName;
  @override
  int get quantity;
  @override
  double get unitPriceSnapshot;
  @override
  double get lineTotal;

  /// Create a copy of WorkOrderConsumableItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WorkOrderConsumableItemDtoImplCopyWith<_$WorkOrderConsumableItemDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
