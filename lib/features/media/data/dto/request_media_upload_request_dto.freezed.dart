// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_media_upload_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestMediaUploadRequestDto _$RequestMediaUploadRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _RequestMediaUploadRequestDto.fromJson(json);
}

/// @nodoc
mixin _$RequestMediaUploadRequestDto {
  String get mediaType => throw _privateConstructorUsedError;
  String get stage => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  int get sizeBytes => throw _privateConstructorUsedError;

  /// Serializes this RequestMediaUploadRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestMediaUploadRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestMediaUploadRequestDtoCopyWith<RequestMediaUploadRequestDto>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestMediaUploadRequestDtoCopyWith<$Res> {
  factory $RequestMediaUploadRequestDtoCopyWith(
          RequestMediaUploadRequestDto value,
          $Res Function(RequestMediaUploadRequestDto) then) =
      _$RequestMediaUploadRequestDtoCopyWithImpl<$Res,
          RequestMediaUploadRequestDto>;
  @useResult
  $Res call(
      {String mediaType,
      String stage,
      String fileName,
      String mimeType,
      int sizeBytes});
}

/// @nodoc
class _$RequestMediaUploadRequestDtoCopyWithImpl<$Res,
        $Val extends RequestMediaUploadRequestDto>
    implements $RequestMediaUploadRequestDtoCopyWith<$Res> {
  _$RequestMediaUploadRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestMediaUploadRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mediaType = null,
    Object? stage = null,
    Object? fileName = null,
    Object? mimeType = null,
    Object? sizeBytes = null,
  }) {
    return _then(_value.copyWith(
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: null == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestMediaUploadRequestDtoImplCopyWith<$Res>
    implements $RequestMediaUploadRequestDtoCopyWith<$Res> {
  factory _$$RequestMediaUploadRequestDtoImplCopyWith(
          _$RequestMediaUploadRequestDtoImpl value,
          $Res Function(_$RequestMediaUploadRequestDtoImpl) then) =
      __$$RequestMediaUploadRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String mediaType,
      String stage,
      String fileName,
      String mimeType,
      int sizeBytes});
}

/// @nodoc
class __$$RequestMediaUploadRequestDtoImplCopyWithImpl<$Res>
    extends _$RequestMediaUploadRequestDtoCopyWithImpl<$Res,
        _$RequestMediaUploadRequestDtoImpl>
    implements _$$RequestMediaUploadRequestDtoImplCopyWith<$Res> {
  __$$RequestMediaUploadRequestDtoImplCopyWithImpl(
      _$RequestMediaUploadRequestDtoImpl _value,
      $Res Function(_$RequestMediaUploadRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestMediaUploadRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mediaType = null,
    Object? stage = null,
    Object? fileName = null,
    Object? mimeType = null,
    Object? sizeBytes = null,
  }) {
    return _then(_$RequestMediaUploadRequestDtoImpl(
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: null == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestMediaUploadRequestDtoImpl
    implements _RequestMediaUploadRequestDto {
  const _$RequestMediaUploadRequestDtoImpl(
      {required this.mediaType,
      required this.stage,
      required this.fileName,
      required this.mimeType,
      required this.sizeBytes});

  factory _$RequestMediaUploadRequestDtoImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RequestMediaUploadRequestDtoImplFromJson(json);

  @override
  final String mediaType;
  @override
  final String stage;
  @override
  final String fileName;
  @override
  final String mimeType;
  @override
  final int sizeBytes;

  @override
  String toString() {
    return 'RequestMediaUploadRequestDto(mediaType: $mediaType, stage: $stage, fileName: $fileName, mimeType: $mimeType, sizeBytes: $sizeBytes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestMediaUploadRequestDtoImpl &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mediaType, stage, fileName, mimeType, sizeBytes);

  /// Create a copy of RequestMediaUploadRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestMediaUploadRequestDtoImplCopyWith<
          _$RequestMediaUploadRequestDtoImpl>
      get copyWith => __$$RequestMediaUploadRequestDtoImplCopyWithImpl<
          _$RequestMediaUploadRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestMediaUploadRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _RequestMediaUploadRequestDto
    implements RequestMediaUploadRequestDto {
  const factory _RequestMediaUploadRequestDto(
      {required final String mediaType,
      required final String stage,
      required final String fileName,
      required final String mimeType,
      required final int sizeBytes}) = _$RequestMediaUploadRequestDtoImpl;

  factory _RequestMediaUploadRequestDto.fromJson(Map<String, dynamic> json) =
      _$RequestMediaUploadRequestDtoImpl.fromJson;

  @override
  String get mediaType;
  @override
  String get stage;
  @override
  String get fileName;
  @override
  String get mimeType;
  @override
  int get sizeBytes;

  /// Create a copy of RequestMediaUploadRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestMediaUploadRequestDtoImplCopyWith<
          _$RequestMediaUploadRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
