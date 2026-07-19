// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_upsert_service_prices_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BulkUpsertServicePricesRequestDto _$BulkUpsertServicePricesRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _BulkUpsertServicePricesRequestDto.fromJson(json);
}

/// @nodoc
mixin _$BulkUpsertServicePricesRequestDto {
  List<UpsertServicePriceRequestDto> get items =>
      throw _privateConstructorUsedError;

  /// Serializes this BulkUpsertServicePricesRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BulkUpsertServicePricesRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BulkUpsertServicePricesRequestDtoCopyWith<BulkUpsertServicePricesRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BulkUpsertServicePricesRequestDtoCopyWith<$Res> {
  factory $BulkUpsertServicePricesRequestDtoCopyWith(
          BulkUpsertServicePricesRequestDto value,
          $Res Function(BulkUpsertServicePricesRequestDto) then) =
      _$BulkUpsertServicePricesRequestDtoCopyWithImpl<$Res,
          BulkUpsertServicePricesRequestDto>;
  @useResult
  $Res call({List<UpsertServicePriceRequestDto> items});
}

/// @nodoc
class _$BulkUpsertServicePricesRequestDtoCopyWithImpl<$Res,
        $Val extends BulkUpsertServicePricesRequestDto>
    implements $BulkUpsertServicePricesRequestDtoCopyWith<$Res> {
  _$BulkUpsertServicePricesRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BulkUpsertServicePricesRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UpsertServicePriceRequestDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BulkUpsertServicePricesRequestDtoImplCopyWith<$Res>
    implements $BulkUpsertServicePricesRequestDtoCopyWith<$Res> {
  factory _$$BulkUpsertServicePricesRequestDtoImplCopyWith(
          _$BulkUpsertServicePricesRequestDtoImpl value,
          $Res Function(_$BulkUpsertServicePricesRequestDtoImpl) then) =
      __$$BulkUpsertServicePricesRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UpsertServicePriceRequestDto> items});
}

/// @nodoc
class __$$BulkUpsertServicePricesRequestDtoImplCopyWithImpl<$Res>
    extends _$BulkUpsertServicePricesRequestDtoCopyWithImpl<$Res,
        _$BulkUpsertServicePricesRequestDtoImpl>
    implements _$$BulkUpsertServicePricesRequestDtoImplCopyWith<$Res> {
  __$$BulkUpsertServicePricesRequestDtoImplCopyWithImpl(
      _$BulkUpsertServicePricesRequestDtoImpl _value,
      $Res Function(_$BulkUpsertServicePricesRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of BulkUpsertServicePricesRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_$BulkUpsertServicePricesRequestDtoImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UpsertServicePriceRequestDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BulkUpsertServicePricesRequestDtoImpl
    implements _BulkUpsertServicePricesRequestDto {
  const _$BulkUpsertServicePricesRequestDtoImpl(
      {required final List<UpsertServicePriceRequestDto> items})
      : _items = items;

  factory _$BulkUpsertServicePricesRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$BulkUpsertServicePricesRequestDtoImplFromJson(json);

  final List<UpsertServicePriceRequestDto> _items;
  @override
  List<UpsertServicePriceRequestDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'BulkUpsertServicePricesRequestDto(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BulkUpsertServicePricesRequestDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of BulkUpsertServicePricesRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BulkUpsertServicePricesRequestDtoImplCopyWith<
          _$BulkUpsertServicePricesRequestDtoImpl>
      get copyWith => __$$BulkUpsertServicePricesRequestDtoImplCopyWithImpl<
          _$BulkUpsertServicePricesRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BulkUpsertServicePricesRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _BulkUpsertServicePricesRequestDto
    implements BulkUpsertServicePricesRequestDto {
  const factory _BulkUpsertServicePricesRequestDto(
          {required final List<UpsertServicePriceRequestDto> items}) =
      _$BulkUpsertServicePricesRequestDtoImpl;

  factory _BulkUpsertServicePricesRequestDto.fromJson(
          Map<String, dynamic> json) =
      _$BulkUpsertServicePricesRequestDtoImpl.fromJson;

  @override
  List<UpsertServicePriceRequestDto> get items;

  /// Create a copy of BulkUpsertServicePricesRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BulkUpsertServicePricesRequestDtoImplCopyWith<
          _$BulkUpsertServicePricesRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
