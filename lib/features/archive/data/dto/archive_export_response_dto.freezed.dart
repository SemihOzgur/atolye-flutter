// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_export_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArchiveExportResponseDto _$ArchiveExportResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _ArchiveExportResponseDto.fromJson(json);
}

/// @nodoc
mixin _$ArchiveExportResponseDto {
  int get workOrderId => throw _privateConstructorUsedError;
  List<ArchiveMediaItemDto> get items => throw _privateConstructorUsedError;

  /// Serializes this ArchiveExportResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArchiveExportResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchiveExportResponseDtoCopyWith<ArchiveExportResponseDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchiveExportResponseDtoCopyWith<$Res> {
  factory $ArchiveExportResponseDtoCopyWith(ArchiveExportResponseDto value,
          $Res Function(ArchiveExportResponseDto) then) =
      _$ArchiveExportResponseDtoCopyWithImpl<$Res, ArchiveExportResponseDto>;
  @useResult
  $Res call({int workOrderId, List<ArchiveMediaItemDto> items});
}

/// @nodoc
class _$ArchiveExportResponseDtoCopyWithImpl<$Res,
        $Val extends ArchiveExportResponseDto>
    implements $ArchiveExportResponseDtoCopyWith<$Res> {
  _$ArchiveExportResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchiveExportResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workOrderId = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      workOrderId: null == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ArchiveMediaItemDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArchiveExportResponseDtoImplCopyWith<$Res>
    implements $ArchiveExportResponseDtoCopyWith<$Res> {
  factory _$$ArchiveExportResponseDtoImplCopyWith(
          _$ArchiveExportResponseDtoImpl value,
          $Res Function(_$ArchiveExportResponseDtoImpl) then) =
      __$$ArchiveExportResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int workOrderId, List<ArchiveMediaItemDto> items});
}

/// @nodoc
class __$$ArchiveExportResponseDtoImplCopyWithImpl<$Res>
    extends _$ArchiveExportResponseDtoCopyWithImpl<$Res,
        _$ArchiveExportResponseDtoImpl>
    implements _$$ArchiveExportResponseDtoImplCopyWith<$Res> {
  __$$ArchiveExportResponseDtoImplCopyWithImpl(
      _$ArchiveExportResponseDtoImpl _value,
      $Res Function(_$ArchiveExportResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArchiveExportResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workOrderId = null,
    Object? items = null,
  }) {
    return _then(_$ArchiveExportResponseDtoImpl(
      workOrderId: null == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ArchiveMediaItemDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArchiveExportResponseDtoImpl implements _ArchiveExportResponseDto {
  const _$ArchiveExportResponseDtoImpl(
      {required this.workOrderId,
      required final List<ArchiveMediaItemDto> items})
      : _items = items;

  factory _$ArchiveExportResponseDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArchiveExportResponseDtoImplFromJson(json);

  @override
  final int workOrderId;
  final List<ArchiveMediaItemDto> _items;
  @override
  List<ArchiveMediaItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'ArchiveExportResponseDto(workOrderId: $workOrderId, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchiveExportResponseDtoImpl &&
            (identical(other.workOrderId, workOrderId) ||
                other.workOrderId == workOrderId) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, workOrderId, const DeepCollectionEquality().hash(_items));

  /// Create a copy of ArchiveExportResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchiveExportResponseDtoImplCopyWith<_$ArchiveExportResponseDtoImpl>
      get copyWith => __$$ArchiveExportResponseDtoImplCopyWithImpl<
          _$ArchiveExportResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArchiveExportResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _ArchiveExportResponseDto implements ArchiveExportResponseDto {
  const factory _ArchiveExportResponseDto(
          {required final int workOrderId,
          required final List<ArchiveMediaItemDto> items}) =
      _$ArchiveExportResponseDtoImpl;

  factory _ArchiveExportResponseDto.fromJson(Map<String, dynamic> json) =
      _$ArchiveExportResponseDtoImpl.fromJson;

  @override
  int get workOrderId;
  @override
  List<ArchiveMediaItemDto> get items;

  /// Create a copy of ArchiveExportResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchiveExportResponseDtoImplCopyWith<_$ArchiveExportResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
