// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_detail_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomerDetailDto _$CustomerDetailDtoFromJson(Map<String, dynamic> json) {
  return _CustomerDetailDto.fromJson(json);
}

/// @nodoc
mixin _$CustomerDetailDto {
  CustomerDto get customer => throw _privateConstructorUsedError;
  List<WorkOrderListItemDto> get workOrders =>
      throw _privateConstructorUsedError;

  /// Serializes this CustomerDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerDetailDtoCopyWith<CustomerDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerDetailDtoCopyWith<$Res> {
  factory $CustomerDetailDtoCopyWith(
          CustomerDetailDto value, $Res Function(CustomerDetailDto) then) =
      _$CustomerDetailDtoCopyWithImpl<$Res, CustomerDetailDto>;
  @useResult
  $Res call({CustomerDto customer, List<WorkOrderListItemDto> workOrders});

  $CustomerDtoCopyWith<$Res> get customer;
}

/// @nodoc
class _$CustomerDetailDtoCopyWithImpl<$Res, $Val extends CustomerDetailDto>
    implements $CustomerDetailDtoCopyWith<$Res> {
  _$CustomerDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? workOrders = null,
  }) {
    return _then(_value.copyWith(
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerDto,
      workOrders: null == workOrders
          ? _value.workOrders
          : workOrders // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderListItemDto>,
    ) as $Val);
  }

  /// Create a copy of CustomerDetailDto
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
abstract class _$$CustomerDetailDtoImplCopyWith<$Res>
    implements $CustomerDetailDtoCopyWith<$Res> {
  factory _$$CustomerDetailDtoImplCopyWith(_$CustomerDetailDtoImpl value,
          $Res Function(_$CustomerDetailDtoImpl) then) =
      __$$CustomerDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({CustomerDto customer, List<WorkOrderListItemDto> workOrders});

  @override
  $CustomerDtoCopyWith<$Res> get customer;
}

/// @nodoc
class __$$CustomerDetailDtoImplCopyWithImpl<$Res>
    extends _$CustomerDetailDtoCopyWithImpl<$Res, _$CustomerDetailDtoImpl>
    implements _$$CustomerDetailDtoImplCopyWith<$Res> {
  __$$CustomerDetailDtoImplCopyWithImpl(_$CustomerDetailDtoImpl _value,
      $Res Function(_$CustomerDetailDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CustomerDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customer = null,
    Object? workOrders = null,
  }) {
    return _then(_$CustomerDetailDtoImpl(
      customer: null == customer
          ? _value.customer
          : customer // ignore: cast_nullable_to_non_nullable
              as CustomerDto,
      workOrders: null == workOrders
          ? _value._workOrders
          : workOrders // ignore: cast_nullable_to_non_nullable
              as List<WorkOrderListItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerDetailDtoImpl implements _CustomerDetailDto {
  const _$CustomerDetailDtoImpl(
      {required this.customer,
      final List<WorkOrderListItemDto> workOrders =
          const <WorkOrderListItemDto>[]})
      : _workOrders = workOrders;

  factory _$CustomerDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerDetailDtoImplFromJson(json);

  @override
  final CustomerDto customer;
  final List<WorkOrderListItemDto> _workOrders;
  @override
  @JsonKey()
  List<WorkOrderListItemDto> get workOrders {
    if (_workOrders is EqualUnmodifiableListView) return _workOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workOrders);
  }

  @override
  String toString() {
    return 'CustomerDetailDto(customer: $customer, workOrders: $workOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerDetailDtoImpl &&
            (identical(other.customer, customer) ||
                other.customer == customer) &&
            const DeepCollectionEquality()
                .equals(other._workOrders, _workOrders));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, customer, const DeepCollectionEquality().hash(_workOrders));

  /// Create a copy of CustomerDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerDetailDtoImplCopyWith<_$CustomerDetailDtoImpl> get copyWith =>
      __$$CustomerDetailDtoImplCopyWithImpl<_$CustomerDetailDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerDetailDtoImplToJson(
      this,
    );
  }
}

abstract class _CustomerDetailDto implements CustomerDetailDto {
  const factory _CustomerDetailDto(
      {required final CustomerDto customer,
      final List<WorkOrderListItemDto> workOrders}) = _$CustomerDetailDtoImpl;

  factory _CustomerDetailDto.fromJson(Map<String, dynamic> json) =
      _$CustomerDetailDtoImpl.fromJson;

  @override
  CustomerDto get customer;
  @override
  List<WorkOrderListItemDto> get workOrders;

  /// Create a copy of CustomerDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerDetailDtoImplCopyWith<_$CustomerDetailDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
