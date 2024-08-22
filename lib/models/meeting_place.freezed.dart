// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MeetingPlace _$MeetingPlaceFromJson(Map<String, dynamic> json) {
  return _MeetingPlace.fromJson(json);
}

/// @nodoc
mixin _$MeetingPlace {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'city')
  String? get mCity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MeetingPlaceCopyWith<MeetingPlace> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MeetingPlaceCopyWith<$Res> {
  factory $MeetingPlaceCopyWith(
          MeetingPlace value, $Res Function(MeetingPlace) then) =
      _$MeetingPlaceCopyWithImpl<$Res, MeetingPlace>;
  @useResult
  $Res call({int? id, @JsonKey(name: 'city') String? mCity});
}

/// @nodoc
class _$MeetingPlaceCopyWithImpl<$Res, $Val extends MeetingPlace>
    implements $MeetingPlaceCopyWith<$Res> {
  _$MeetingPlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? mCity = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      mCity: freezed == mCity
          ? _value.mCity
          : mCity // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MeetingPlaceImplCopyWith<$Res>
    implements $MeetingPlaceCopyWith<$Res> {
  factory _$$MeetingPlaceImplCopyWith(
          _$MeetingPlaceImpl value, $Res Function(_$MeetingPlaceImpl) then) =
      __$$MeetingPlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? id, @JsonKey(name: 'city') String? mCity});
}

/// @nodoc
class __$$MeetingPlaceImplCopyWithImpl<$Res>
    extends _$MeetingPlaceCopyWithImpl<$Res, _$MeetingPlaceImpl>
    implements _$$MeetingPlaceImplCopyWith<$Res> {
  __$$MeetingPlaceImplCopyWithImpl(
      _$MeetingPlaceImpl _value, $Res Function(_$MeetingPlaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? mCity = freezed,
  }) {
    return _then(_$MeetingPlaceImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      mCity: freezed == mCity
          ? _value.mCity
          : mCity // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MeetingPlaceImpl extends _MeetingPlace {
  _$MeetingPlaceImpl({this.id, @JsonKey(name: 'city') this.mCity}) : super._();

  factory _$MeetingPlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$MeetingPlaceImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'city')
  final String? mCity;

  @override
  String toString() {
    return 'MeetingPlace(id: $id, mCity: $mCity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MeetingPlaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mCity, mCity) || other.mCity == mCity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, mCity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MeetingPlaceImplCopyWith<_$MeetingPlaceImpl> get copyWith =>
      __$$MeetingPlaceImplCopyWithImpl<_$MeetingPlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MeetingPlaceImplToJson(
      this,
    );
  }
}

abstract class _MeetingPlace extends MeetingPlace {
  factory _MeetingPlace(
      {final int? id,
      @JsonKey(name: 'city') final String? mCity}) = _$MeetingPlaceImpl;
  _MeetingPlace._() : super._();

  factory _MeetingPlace.fromJson(Map<String, dynamic> json) =
      _$MeetingPlaceImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'city')
  String? get mCity;
  @override
  @JsonKey(ignore: true)
  _$$MeetingPlaceImplCopyWith<_$MeetingPlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
