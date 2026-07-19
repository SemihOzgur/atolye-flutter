// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_media_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SocialMediaItemDto _$SocialMediaItemDtoFromJson(Map<String, dynamic> json) {
  return _SocialMediaItemDto.fromJson(json);
}

/// @nodoc
mixin _$SocialMediaItemDto {
  int get workOrderId => throw _privateConstructorUsedError;
  String get orderNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get categoryPath => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  DateTime get socialMediaConsentAt => throw _privateConstructorUsedError;
  List<MediaFileDto> get beforeMedia => throw _privateConstructorUsedError;
  List<MediaFileDto> get afterMedia => throw _privateConstructorUsedError;

  /// Serializes this SocialMediaItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialMediaItemDtoCopyWith<SocialMediaItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialMediaItemDtoCopyWith<$Res> {
  factory $SocialMediaItemDtoCopyWith(
          SocialMediaItemDto value, $Res Function(SocialMediaItemDto) then) =
      _$SocialMediaItemDtoCopyWithImpl<$Res, SocialMediaItemDto>;
  @useResult
  $Res call(
      {int workOrderId,
      String orderNumber,
      String status,
      String categoryPath,
      String? brand,
      DateTime socialMediaConsentAt,
      List<MediaFileDto> beforeMedia,
      List<MediaFileDto> afterMedia});
}

/// @nodoc
class _$SocialMediaItemDtoCopyWithImpl<$Res, $Val extends SocialMediaItemDto>
    implements $SocialMediaItemDtoCopyWith<$Res> {
  _$SocialMediaItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workOrderId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? categoryPath = null,
    Object? brand = freezed,
    Object? socialMediaConsentAt = null,
    Object? beforeMedia = null,
    Object? afterMedia = null,
  }) {
    return _then(_value.copyWith(
      workOrderId: null == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      socialMediaConsentAt: null == socialMediaConsentAt
          ? _value.socialMediaConsentAt
          : socialMediaConsentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      beforeMedia: null == beforeMedia
          ? _value.beforeMedia
          : beforeMedia // ignore: cast_nullable_to_non_nullable
              as List<MediaFileDto>,
      afterMedia: null == afterMedia
          ? _value.afterMedia
          : afterMedia // ignore: cast_nullable_to_non_nullable
              as List<MediaFileDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialMediaItemDtoImplCopyWith<$Res>
    implements $SocialMediaItemDtoCopyWith<$Res> {
  factory _$$SocialMediaItemDtoImplCopyWith(_$SocialMediaItemDtoImpl value,
          $Res Function(_$SocialMediaItemDtoImpl) then) =
      __$$SocialMediaItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int workOrderId,
      String orderNumber,
      String status,
      String categoryPath,
      String? brand,
      DateTime socialMediaConsentAt,
      List<MediaFileDto> beforeMedia,
      List<MediaFileDto> afterMedia});
}

/// @nodoc
class __$$SocialMediaItemDtoImplCopyWithImpl<$Res>
    extends _$SocialMediaItemDtoCopyWithImpl<$Res, _$SocialMediaItemDtoImpl>
    implements _$$SocialMediaItemDtoImplCopyWith<$Res> {
  __$$SocialMediaItemDtoImplCopyWithImpl(_$SocialMediaItemDtoImpl _value,
      $Res Function(_$SocialMediaItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? workOrderId = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? categoryPath = null,
    Object? brand = freezed,
    Object? socialMediaConsentAt = null,
    Object? beforeMedia = null,
    Object? afterMedia = null,
  }) {
    return _then(_$SocialMediaItemDtoImpl(
      workOrderId: null == workOrderId
          ? _value.workOrderId
          : workOrderId // ignore: cast_nullable_to_non_nullable
              as int,
      orderNumber: null == orderNumber
          ? _value.orderNumber
          : orderNumber // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      categoryPath: null == categoryPath
          ? _value.categoryPath
          : categoryPath // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      socialMediaConsentAt: null == socialMediaConsentAt
          ? _value.socialMediaConsentAt
          : socialMediaConsentAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      beforeMedia: null == beforeMedia
          ? _value._beforeMedia
          : beforeMedia // ignore: cast_nullable_to_non_nullable
              as List<MediaFileDto>,
      afterMedia: null == afterMedia
          ? _value._afterMedia
          : afterMedia // ignore: cast_nullable_to_non_nullable
              as List<MediaFileDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialMediaItemDtoImpl implements _SocialMediaItemDto {
  const _$SocialMediaItemDtoImpl(
      {required this.workOrderId,
      required this.orderNumber,
      required this.status,
      required this.categoryPath,
      this.brand,
      required this.socialMediaConsentAt,
      required final List<MediaFileDto> beforeMedia,
      required final List<MediaFileDto> afterMedia})
      : _beforeMedia = beforeMedia,
        _afterMedia = afterMedia;

  factory _$SocialMediaItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialMediaItemDtoImplFromJson(json);

  @override
  final int workOrderId;
  @override
  final String orderNumber;
  @override
  final String status;
  @override
  final String categoryPath;
  @override
  final String? brand;
  @override
  final DateTime socialMediaConsentAt;
  final List<MediaFileDto> _beforeMedia;
  @override
  List<MediaFileDto> get beforeMedia {
    if (_beforeMedia is EqualUnmodifiableListView) return _beforeMedia;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_beforeMedia);
  }

  final List<MediaFileDto> _afterMedia;
  @override
  List<MediaFileDto> get afterMedia {
    if (_afterMedia is EqualUnmodifiableListView) return _afterMedia;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_afterMedia);
  }

  @override
  String toString() {
    return 'SocialMediaItemDto(workOrderId: $workOrderId, orderNumber: $orderNumber, status: $status, categoryPath: $categoryPath, brand: $brand, socialMediaConsentAt: $socialMediaConsentAt, beforeMedia: $beforeMedia, afterMedia: $afterMedia)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialMediaItemDtoImpl &&
            (identical(other.workOrderId, workOrderId) ||
                other.workOrderId == workOrderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.categoryPath, categoryPath) ||
                other.categoryPath == categoryPath) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.socialMediaConsentAt, socialMediaConsentAt) ||
                other.socialMediaConsentAt == socialMediaConsentAt) &&
            const DeepCollectionEquality()
                .equals(other._beforeMedia, _beforeMedia) &&
            const DeepCollectionEquality()
                .equals(other._afterMedia, _afterMedia));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      workOrderId,
      orderNumber,
      status,
      categoryPath,
      brand,
      socialMediaConsentAt,
      const DeepCollectionEquality().hash(_beforeMedia),
      const DeepCollectionEquality().hash(_afterMedia));

  /// Create a copy of SocialMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialMediaItemDtoImplCopyWith<_$SocialMediaItemDtoImpl> get copyWith =>
      __$$SocialMediaItemDtoImplCopyWithImpl<_$SocialMediaItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialMediaItemDtoImplToJson(
      this,
    );
  }
}

abstract class _SocialMediaItemDto implements SocialMediaItemDto {
  const factory _SocialMediaItemDto(
      {required final int workOrderId,
      required final String orderNumber,
      required final String status,
      required final String categoryPath,
      final String? brand,
      required final DateTime socialMediaConsentAt,
      required final List<MediaFileDto> beforeMedia,
      required final List<MediaFileDto> afterMedia}) = _$SocialMediaItemDtoImpl;

  factory _SocialMediaItemDto.fromJson(Map<String, dynamic> json) =
      _$SocialMediaItemDtoImpl.fromJson;

  @override
  int get workOrderId;
  @override
  String get orderNumber;
  @override
  String get status;
  @override
  String get categoryPath;
  @override
  String? get brand;
  @override
  DateTime get socialMediaConsentAt;
  @override
  List<MediaFileDto> get beforeMedia;
  @override
  List<MediaFileDto> get afterMedia;

  /// Create a copy of SocialMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialMediaItemDtoImplCopyWith<_$SocialMediaItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
