// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcript_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TranscriptData _$TranscriptDataFromJson(Map<String, dynamic> json) {
  return _TranscriptData.fromJson(json);
}

/// @nodoc
mixin _$TranscriptData {
  int? get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get originalText => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  List<TranscriptSegment> get segments => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get mp3Language => throw _privateConstructorUsedError;
  int get meetingId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TranscriptDataCopyWith<TranscriptData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranscriptDataCopyWith<$Res> {
  factory $TranscriptDataCopyWith(
          TranscriptData value, $Res Function(TranscriptData) then) =
      _$TranscriptDataCopyWithImpl<$Res, TranscriptData>;
  @useResult
  $Res call(
      {int? id,
      String text,
      String originalText,
      String fileName,
      String filePath,
      List<TranscriptSegment> segments,
      String language,
      String mp3Language,
      int meetingId});
}

/// @nodoc
class _$TranscriptDataCopyWithImpl<$Res, $Val extends TranscriptData>
    implements $TranscriptDataCopyWith<$Res> {
  _$TranscriptDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = null,
    Object? originalText = null,
    Object? fileName = null,
    Object? filePath = null,
    Object? segments = null,
    Object? language = null,
    Object? mp3Language = null,
    Object? meetingId = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      segments: null == segments
          ? _value.segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<TranscriptSegment>,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      mp3Language: null == mp3Language
          ? _value.mp3Language
          : mp3Language // ignore: cast_nullable_to_non_nullable
              as String,
      meetingId: null == meetingId
          ? _value.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranscriptDataImplCopyWith<$Res>
    implements $TranscriptDataCopyWith<$Res> {
  factory _$$TranscriptDataImplCopyWith(_$TranscriptDataImpl value,
          $Res Function(_$TranscriptDataImpl) then) =
      __$$TranscriptDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String text,
      String originalText,
      String fileName,
      String filePath,
      List<TranscriptSegment> segments,
      String language,
      String mp3Language,
      int meetingId});
}

/// @nodoc
class __$$TranscriptDataImplCopyWithImpl<$Res>
    extends _$TranscriptDataCopyWithImpl<$Res, _$TranscriptDataImpl>
    implements _$$TranscriptDataImplCopyWith<$Res> {
  __$$TranscriptDataImplCopyWithImpl(
      _$TranscriptDataImpl _value, $Res Function(_$TranscriptDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = null,
    Object? originalText = null,
    Object? fileName = null,
    Object? filePath = null,
    Object? segments = null,
    Object? language = null,
    Object? mp3Language = null,
    Object? meetingId = null,
  }) {
    return _then(_$TranscriptDataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      segments: null == segments
          ? _value._segments
          : segments // ignore: cast_nullable_to_non_nullable
              as List<TranscriptSegment>,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      mp3Language: null == mp3Language
          ? _value.mp3Language
          : mp3Language // ignore: cast_nullable_to_non_nullable
              as String,
      meetingId: null == meetingId
          ? _value.meetingId
          : meetingId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranscriptDataImpl extends _TranscriptData {
  _$TranscriptDataImpl(
      {this.id,
      required this.text,
      required this.originalText,
      required this.fileName,
      required this.filePath,
      required final List<TranscriptSegment> segments,
      required this.language,
      required this.mp3Language,
      required this.meetingId})
      : _segments = segments,
        super._();

  factory _$TranscriptDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranscriptDataImplFromJson(json);

  @override
  final int? id;
  @override
  final String text;
  @override
  final String originalText;
  @override
  final String fileName;
  @override
  final String filePath;
  final List<TranscriptSegment> _segments;
  @override
  List<TranscriptSegment> get segments {
    if (_segments is EqualUnmodifiableListView) return _segments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_segments);
  }

  @override
  final String language;
  @override
  final String mp3Language;
  @override
  final int meetingId;

  @override
  String toString() {
    return 'TranscriptData(id: $id, text: $text, originalText: $originalText, fileName: $fileName, filePath: $filePath, segments: $segments, language: $language, mp3Language: $mp3Language, meetingId: $meetingId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.originalText, originalText) ||
                other.originalText == originalText) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            const DeepCollectionEquality().equals(other._segments, _segments) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.mp3Language, mp3Language) ||
                other.mp3Language == mp3Language) &&
            (identical(other.meetingId, meetingId) ||
                other.meetingId == meetingId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      text,
      originalText,
      fileName,
      filePath,
      const DeepCollectionEquality().hash(_segments),
      language,
      mp3Language,
      meetingId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptDataImplCopyWith<_$TranscriptDataImpl> get copyWith =>
      __$$TranscriptDataImplCopyWithImpl<_$TranscriptDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranscriptDataImplToJson(
      this,
    );
  }
}

abstract class _TranscriptData extends TranscriptData {
  factory _TranscriptData(
      {final int? id,
      required final String text,
      required final String originalText,
      required final String fileName,
      required final String filePath,
      required final List<TranscriptSegment> segments,
      required final String language,
      required final String mp3Language,
      required final int meetingId}) = _$TranscriptDataImpl;
  _TranscriptData._() : super._();

  factory _TranscriptData.fromJson(Map<String, dynamic> json) =
      _$TranscriptDataImpl.fromJson;

  @override
  int? get id;
  @override
  String get text;
  @override
  String get originalText;
  @override
  String get fileName;
  @override
  String get filePath;
  @override
  List<TranscriptSegment> get segments;
  @override
  String get language;
  @override
  String get mp3Language;
  @override
  int get meetingId;
  @override
  @JsonKey(ignore: true)
  _$$TranscriptDataImplCopyWith<_$TranscriptDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
