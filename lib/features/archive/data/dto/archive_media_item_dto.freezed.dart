// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_media_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArchiveMediaItemDto _$ArchiveMediaItemDtoFromJson(Map<String, dynamic> json) {
  return _ArchiveMediaItemDto.fromJson(json);
}

/// @nodoc
mixin _$ArchiveMediaItemDto {
  int get mediaId => throw _privateConstructorUsedError;
  String get stage => throw _privateConstructorUsedError;
  String get mediaType => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get sizeBytes => throw _privateConstructorUsedError;
  String get downloadUrl => throw _privateConstructorUsedError;

  /// Serializes this ArchiveMediaItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArchiveMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchiveMediaItemDtoCopyWith<ArchiveMediaItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchiveMediaItemDtoCopyWith<$Res> {
  factory $ArchiveMediaItemDtoCopyWith(
          ArchiveMediaItemDto value, $Res Function(ArchiveMediaItemDto) then) =
      _$ArchiveMediaItemDtoCopyWithImpl<$Res, ArchiveMediaItemDto>;
  @useResult
  $Res call(
      {int mediaId,
      String stage,
      String mediaType,
      String fileName,
      int sizeBytes,
      String downloadUrl});
}

/// @nodoc
class _$ArchiveMediaItemDtoCopyWithImpl<$Res, $Val extends ArchiveMediaItemDto>
    implements $ArchiveMediaItemDtoCopyWith<$Res> {
  _$ArchiveMediaItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchiveMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mediaId = null,
    Object? stage = null,
    Object? mediaType = null,
    Object? fileName = null,
    Object? sizeBytes = null,
    Object? downloadUrl = null,
  }) {
    return _then(_value.copyWith(
      mediaId: null == mediaId
          ? _value.mediaId
          : mediaId // ignore: cast_nullable_to_non_nullable
              as int,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: null == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      downloadUrl: null == downloadUrl
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArchiveMediaItemDtoImplCopyWith<$Res>
    implements $ArchiveMediaItemDtoCopyWith<$Res> {
  factory _$$ArchiveMediaItemDtoImplCopyWith(_$ArchiveMediaItemDtoImpl value,
          $Res Function(_$ArchiveMediaItemDtoImpl) then) =
      __$$ArchiveMediaItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int mediaId,
      String stage,
      String mediaType,
      String fileName,
      int sizeBytes,
      String downloadUrl});
}

/// @nodoc
class __$$ArchiveMediaItemDtoImplCopyWithImpl<$Res>
    extends _$ArchiveMediaItemDtoCopyWithImpl<$Res, _$ArchiveMediaItemDtoImpl>
    implements _$$ArchiveMediaItemDtoImplCopyWith<$Res> {
  __$$ArchiveMediaItemDtoImplCopyWithImpl(_$ArchiveMediaItemDtoImpl _value,
      $Res Function(_$ArchiveMediaItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArchiveMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mediaId = null,
    Object? stage = null,
    Object? mediaType = null,
    Object? fileName = null,
    Object? sizeBytes = null,
    Object? downloadUrl = null,
  }) {
    return _then(_$ArchiveMediaItemDtoImpl(
      mediaId: null == mediaId
          ? _value.mediaId
          : mediaId // ignore: cast_nullable_to_non_nullable
              as int,
      stage: null == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      sizeBytes: null == sizeBytes
          ? _value.sizeBytes
          : sizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      downloadUrl: null == downloadUrl
          ? _value.downloadUrl
          : downloadUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArchiveMediaItemDtoImpl implements _ArchiveMediaItemDto {
  const _$ArchiveMediaItemDtoImpl(
      {required this.mediaId,
      required this.stage,
      required this.mediaType,
      required this.fileName,
      required this.sizeBytes,
      required this.downloadUrl});

  factory _$ArchiveMediaItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArchiveMediaItemDtoImplFromJson(json);

  @override
  final int mediaId;
  @override
  final String stage;
  @override
  final String mediaType;
  @override
  final String fileName;
  @override
  final int sizeBytes;
  @override
  final String downloadUrl;

  @override
  String toString() {
    return 'ArchiveMediaItemDto(mediaId: $mediaId, stage: $stage, mediaType: $mediaType, fileName: $fileName, sizeBytes: $sizeBytes, downloadUrl: $downloadUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchiveMediaItemDtoImpl &&
            (identical(other.mediaId, mediaId) || other.mediaId == mediaId) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.sizeBytes, sizeBytes) ||
                other.sizeBytes == sizeBytes) &&
            (identical(other.downloadUrl, downloadUrl) ||
                other.downloadUrl == downloadUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mediaId, stage, mediaType, fileName, sizeBytes, downloadUrl);

  /// Create a copy of ArchiveMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchiveMediaItemDtoImplCopyWith<_$ArchiveMediaItemDtoImpl> get copyWith =>
      __$$ArchiveMediaItemDtoImplCopyWithImpl<_$ArchiveMediaItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArchiveMediaItemDtoImplToJson(
      this,
    );
  }
}

abstract class _ArchiveMediaItemDto implements ArchiveMediaItemDto {
  const factory _ArchiveMediaItemDto(
      {required final int mediaId,
      required final String stage,
      required final String mediaType,
      required final String fileName,
      required final int sizeBytes,
      required final String downloadUrl}) = _$ArchiveMediaItemDtoImpl;

  factory _ArchiveMediaItemDto.fromJson(Map<String, dynamic> json) =
      _$ArchiveMediaItemDtoImpl.fromJson;

  @override
  int get mediaId;
  @override
  String get stage;
  @override
  String get mediaType;
  @override
  String get fileName;
  @override
  int get sizeBytes;
  @override
  String get downloadUrl;

  /// Create a copy of ArchiveMediaItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchiveMediaItemDtoImplCopyWith<_$ArchiveMediaItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
