// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_media_upload_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestMediaUploadResponseDto _$RequestMediaUploadResponseDtoFromJson(
    Map<String, dynamic> json) {
  return _RequestMediaUploadResponseDto.fromJson(json);
}

/// @nodoc
mixin _$RequestMediaUploadResponseDto {
  int get mediaFileId => throw _privateConstructorUsedError;
  String get uploadUrl => throw _privateConstructorUsedError;
  DateTime get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this RequestMediaUploadResponseDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestMediaUploadResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestMediaUploadResponseDtoCopyWith<RequestMediaUploadResponseDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestMediaUploadResponseDtoCopyWith<$Res> {
  factory $RequestMediaUploadResponseDtoCopyWith(
          RequestMediaUploadResponseDto value,
          $Res Function(RequestMediaUploadResponseDto) then) =
      _$RequestMediaUploadResponseDtoCopyWithImpl<$Res,
          RequestMediaUploadResponseDto>;
  @useResult
  $Res call({int mediaFileId, String uploadUrl, DateTime expiresAt});
}

/// @nodoc
class _$RequestMediaUploadResponseDtoCopyWithImpl<$Res,
        $Val extends RequestMediaUploadResponseDto>
    implements $RequestMediaUploadResponseDtoCopyWith<$Res> {
  _$RequestMediaUploadResponseDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestMediaUploadResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mediaFileId = null,
    Object? uploadUrl = null,
    Object? expiresAt = null,
  }) {
    return _then(_value.copyWith(
      mediaFileId: null == mediaFileId
          ? _value.mediaFileId
          : mediaFileId // ignore: cast_nullable_to_non_nullable
              as int,
      uploadUrl: null == uploadUrl
          ? _value.uploadUrl
          : uploadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestMediaUploadResponseDtoImplCopyWith<$Res>
    implements $RequestMediaUploadResponseDtoCopyWith<$Res> {
  factory _$$RequestMediaUploadResponseDtoImplCopyWith(
          _$RequestMediaUploadResponseDtoImpl value,
          $Res Function(_$RequestMediaUploadResponseDtoImpl) then) =
      __$$RequestMediaUploadResponseDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int mediaFileId, String uploadUrl, DateTime expiresAt});
}

/// @nodoc
class __$$RequestMediaUploadResponseDtoImplCopyWithImpl<$Res>
    extends _$RequestMediaUploadResponseDtoCopyWithImpl<$Res,
        _$RequestMediaUploadResponseDtoImpl>
    implements _$$RequestMediaUploadResponseDtoImplCopyWith<$Res> {
  __$$RequestMediaUploadResponseDtoImplCopyWithImpl(
      _$RequestMediaUploadResponseDtoImpl _value,
      $Res Function(_$RequestMediaUploadResponseDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestMediaUploadResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mediaFileId = null,
    Object? uploadUrl = null,
    Object? expiresAt = null,
  }) {
    return _then(_$RequestMediaUploadResponseDtoImpl(
      mediaFileId: null == mediaFileId
          ? _value.mediaFileId
          : mediaFileId // ignore: cast_nullable_to_non_nullable
              as int,
      uploadUrl: null == uploadUrl
          ? _value.uploadUrl
          : uploadUrl // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestMediaUploadResponseDtoImpl
    implements _RequestMediaUploadResponseDto {
  const _$RequestMediaUploadResponseDtoImpl(
      {required this.mediaFileId,
      required this.uploadUrl,
      required this.expiresAt});

  factory _$RequestMediaUploadResponseDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RequestMediaUploadResponseDtoImplFromJson(json);

  @override
  final int mediaFileId;
  @override
  final String uploadUrl;
  @override
  final DateTime expiresAt;

  @override
  String toString() {
    return 'RequestMediaUploadResponseDto(mediaFileId: $mediaFileId, uploadUrl: $uploadUrl, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestMediaUploadResponseDtoImpl &&
            (identical(other.mediaFileId, mediaFileId) ||
                other.mediaFileId == mediaFileId) &&
            (identical(other.uploadUrl, uploadUrl) ||
                other.uploadUrl == uploadUrl) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mediaFileId, uploadUrl, expiresAt);

  /// Create a copy of RequestMediaUploadResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestMediaUploadResponseDtoImplCopyWith<
          _$RequestMediaUploadResponseDtoImpl>
      get copyWith => __$$RequestMediaUploadResponseDtoImplCopyWithImpl<
          _$RequestMediaUploadResponseDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestMediaUploadResponseDtoImplToJson(
      this,
    );
  }
}

abstract class _RequestMediaUploadResponseDto
    implements RequestMediaUploadResponseDto {
  const factory _RequestMediaUploadResponseDto(
      {required final int mediaFileId,
      required final String uploadUrl,
      required final DateTime expiresAt}) = _$RequestMediaUploadResponseDtoImpl;

  factory _RequestMediaUploadResponseDto.fromJson(Map<String, dynamic> json) =
      _$RequestMediaUploadResponseDtoImpl.fromJson;

  @override
  int get mediaFileId;
  @override
  String get uploadUrl;
  @override
  DateTime get expiresAt;

  /// Create a copy of RequestMediaUploadResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestMediaUploadResponseDtoImplCopyWith<
          _$RequestMediaUploadResponseDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
