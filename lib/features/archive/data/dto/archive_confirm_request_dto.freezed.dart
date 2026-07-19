// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archive_confirm_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArchiveConfirmRequestDto _$ArchiveConfirmRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _ArchiveConfirmRequestDto.fromJson(json);
}

/// @nodoc
mixin _$ArchiveConfirmRequestDto {
  List<int> get verifiedMediaIds => throw _privateConstructorUsedError;

  /// Serializes this ArchiveConfirmRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArchiveConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchiveConfirmRequestDtoCopyWith<ArchiveConfirmRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchiveConfirmRequestDtoCopyWith<$Res> {
  factory $ArchiveConfirmRequestDtoCopyWith(ArchiveConfirmRequestDto value,
          $Res Function(ArchiveConfirmRequestDto) then) =
      _$ArchiveConfirmRequestDtoCopyWithImpl<$Res, ArchiveConfirmRequestDto>;
  @useResult
  $Res call({List<int> verifiedMediaIds});
}

/// @nodoc
class _$ArchiveConfirmRequestDtoCopyWithImpl<$Res,
        $Val extends ArchiveConfirmRequestDto>
    implements $ArchiveConfirmRequestDtoCopyWith<$Res> {
  _$ArchiveConfirmRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchiveConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verifiedMediaIds = null,
  }) {
    return _then(_value.copyWith(
      verifiedMediaIds: null == verifiedMediaIds
          ? _value.verifiedMediaIds
          : verifiedMediaIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArchiveConfirmRequestDtoImplCopyWith<$Res>
    implements $ArchiveConfirmRequestDtoCopyWith<$Res> {
  factory _$$ArchiveConfirmRequestDtoImplCopyWith(
          _$ArchiveConfirmRequestDtoImpl value,
          $Res Function(_$ArchiveConfirmRequestDtoImpl) then) =
      __$$ArchiveConfirmRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<int> verifiedMediaIds});
}

/// @nodoc
class __$$ArchiveConfirmRequestDtoImplCopyWithImpl<$Res>
    extends _$ArchiveConfirmRequestDtoCopyWithImpl<$Res,
        _$ArchiveConfirmRequestDtoImpl>
    implements _$$ArchiveConfirmRequestDtoImplCopyWith<$Res> {
  __$$ArchiveConfirmRequestDtoImplCopyWithImpl(
      _$ArchiveConfirmRequestDtoImpl _value,
      $Res Function(_$ArchiveConfirmRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArchiveConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? verifiedMediaIds = null,
  }) {
    return _then(_$ArchiveConfirmRequestDtoImpl(
      verifiedMediaIds: null == verifiedMediaIds
          ? _value._verifiedMediaIds
          : verifiedMediaIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArchiveConfirmRequestDtoImpl implements _ArchiveConfirmRequestDto {
  const _$ArchiveConfirmRequestDtoImpl(
      {required final List<int> verifiedMediaIds})
      : _verifiedMediaIds = verifiedMediaIds;

  factory _$ArchiveConfirmRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArchiveConfirmRequestDtoImplFromJson(json);

  final List<int> _verifiedMediaIds;
  @override
  List<int> get verifiedMediaIds {
    if (_verifiedMediaIds is EqualUnmodifiableListView)
      return _verifiedMediaIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_verifiedMediaIds);
  }

  @override
  String toString() {
    return 'ArchiveConfirmRequestDto(verifiedMediaIds: $verifiedMediaIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchiveConfirmRequestDtoImpl &&
            const DeepCollectionEquality()
                .equals(other._verifiedMediaIds, _verifiedMediaIds));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_verifiedMediaIds));

  /// Create a copy of ArchiveConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchiveConfirmRequestDtoImplCopyWith<_$ArchiveConfirmRequestDtoImpl>
      get copyWith => __$$ArchiveConfirmRequestDtoImplCopyWithImpl<
          _$ArchiveConfirmRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArchiveConfirmRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _ArchiveConfirmRequestDto implements ArchiveConfirmRequestDto {
  const factory _ArchiveConfirmRequestDto(
          {required final List<int> verifiedMediaIds}) =
      _$ArchiveConfirmRequestDtoImpl;

  factory _ArchiveConfirmRequestDto.fromJson(Map<String, dynamic> json) =
      _$ArchiveConfirmRequestDtoImpl.fromJson;

  @override
  List<int> get verifiedMediaIds;

  /// Create a copy of ArchiveConfirmRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchiveConfirmRequestDtoImplCopyWith<_$ArchiveConfirmRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
