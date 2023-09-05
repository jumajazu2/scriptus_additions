// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcript_segment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TranscriptSegment _$TranscriptSegmentFromJson(Map<String, dynamic> json) {
  return _TranscriptSegment.fromJson(json);
}

/// @nodoc
mixin _$TranscriptSegment {
  int? get id => throw _privateConstructorUsedError;
  int? get transcriptDataId =>
      throw _privateConstructorUsedError; // required final int seek,
  int get start => throw _privateConstructorUsedError;
  int get end => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  List<Place> get places => throw _privateConstructorUsedError;
  List<BibleVerse> get foundScriptures => throw _privateConstructorUsedError;
  BibleVerse? get assignedScripture => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  String get originalText => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get textSk => throw _privateConstructorUsedError;
  String get textEn => throw _privateConstructorUsedError;
  bool get hasParagraphBreak => throw _privateConstructorUsedError;
  bool get isScripture => throw _privateConstructorUsedError;
  bool get isWBQuote => throw _privateConstructorUsedError;
  bool get isBrRuss => throw _privateConstructorUsedError;
  bool get isSong => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TranscriptSegmentCopyWith<TranscriptSegment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranscriptSegmentCopyWith<$Res> {
  factory $TranscriptSegmentCopyWith(
          TranscriptSegment value, $Res Function(TranscriptSegment) then) =
      _$TranscriptSegmentCopyWithImpl<$Res, TranscriptSegment>;
  @useResult
  $Res call(
      {int? id,
      int? transcriptDataId,
      int start,
      int end,
      String startTime,
      List<Place> places,
      List<BibleVerse> foundScriptures,
      BibleVerse? assignedScripture,
      String endTime,
      String originalText,
      String text,
      String textSk,
      String textEn,
      bool hasParagraphBreak,
      bool isScripture,
      bool isWBQuote,
      bool isBrRuss,
      bool isSong});

  $BibleVerseCopyWith<$Res>? get assignedScripture;
}

/// @nodoc
class _$TranscriptSegmentCopyWithImpl<$Res, $Val extends TranscriptSegment>
    implements $TranscriptSegmentCopyWith<$Res> {
  _$TranscriptSegmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? transcriptDataId = freezed,
    Object? start = null,
    Object? end = null,
    Object? startTime = null,
    Object? places = null,
    Object? foundScriptures = null,
    Object? assignedScripture = freezed,
    Object? endTime = null,
    Object? originalText = null,
    Object? text = null,
    Object? textSk = null,
    Object? textEn = null,
    Object? hasParagraphBreak = null,
    Object? isScripture = null,
    Object? isWBQuote = null,
    Object? isBrRuss = null,
    Object? isSong = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      transcriptDataId: freezed == transcriptDataId
          ? _value.transcriptDataId
          : transcriptDataId // ignore: cast_nullable_to_non_nullable
              as int?,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as int,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<Place>,
      foundScriptures: null == foundScriptures
          ? _value.foundScriptures
          : foundScriptures // ignore: cast_nullable_to_non_nullable
              as List<BibleVerse>,
      assignedScripture: freezed == assignedScripture
          ? _value.assignedScripture
          : assignedScripture // ignore: cast_nullable_to_non_nullable
              as BibleVerse?,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      textSk: null == textSk
          ? _value.textSk
          : textSk // ignore: cast_nullable_to_non_nullable
              as String,
      textEn: null == textEn
          ? _value.textEn
          : textEn // ignore: cast_nullable_to_non_nullable
              as String,
      hasParagraphBreak: null == hasParagraphBreak
          ? _value.hasParagraphBreak
          : hasParagraphBreak // ignore: cast_nullable_to_non_nullable
              as bool,
      isScripture: null == isScripture
          ? _value.isScripture
          : isScripture // ignore: cast_nullable_to_non_nullable
              as bool,
      isWBQuote: null == isWBQuote
          ? _value.isWBQuote
          : isWBQuote // ignore: cast_nullable_to_non_nullable
              as bool,
      isBrRuss: null == isBrRuss
          ? _value.isBrRuss
          : isBrRuss // ignore: cast_nullable_to_non_nullable
              as bool,
      isSong: null == isSong
          ? _value.isSong
          : isSong // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BibleVerseCopyWith<$Res>? get assignedScripture {
    if (_value.assignedScripture == null) {
      return null;
    }

    return $BibleVerseCopyWith<$Res>(_value.assignedScripture!, (value) {
      return _then(_value.copyWith(assignedScripture: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_TranscriptSegmentCopyWith<$Res>
    implements $TranscriptSegmentCopyWith<$Res> {
  factory _$$_TranscriptSegmentCopyWith(_$_TranscriptSegment value,
          $Res Function(_$_TranscriptSegment) then) =
      __$$_TranscriptSegmentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? transcriptDataId,
      int start,
      int end,
      String startTime,
      List<Place> places,
      List<BibleVerse> foundScriptures,
      BibleVerse? assignedScripture,
      String endTime,
      String originalText,
      String text,
      String textSk,
      String textEn,
      bool hasParagraphBreak,
      bool isScripture,
      bool isWBQuote,
      bool isBrRuss,
      bool isSong});

  @override
  $BibleVerseCopyWith<$Res>? get assignedScripture;
}

/// @nodoc
class __$$_TranscriptSegmentCopyWithImpl<$Res>
    extends _$TranscriptSegmentCopyWithImpl<$Res, _$_TranscriptSegment>
    implements _$$_TranscriptSegmentCopyWith<$Res> {
  __$$_TranscriptSegmentCopyWithImpl(
      _$_TranscriptSegment _value, $Res Function(_$_TranscriptSegment) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? transcriptDataId = freezed,
    Object? start = null,
    Object? end = null,
    Object? startTime = null,
    Object? places = null,
    Object? foundScriptures = null,
    Object? assignedScripture = freezed,
    Object? endTime = null,
    Object? originalText = null,
    Object? text = null,
    Object? textSk = null,
    Object? textEn = null,
    Object? hasParagraphBreak = null,
    Object? isScripture = null,
    Object? isWBQuote = null,
    Object? isBrRuss = null,
    Object? isSong = null,
  }) {
    return _then(_$_TranscriptSegment(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      transcriptDataId: freezed == transcriptDataId
          ? _value.transcriptDataId
          : transcriptDataId // ignore: cast_nullable_to_non_nullable
              as int?,
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as int,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as int,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<Place>,
      foundScriptures: null == foundScriptures
          ? _value._foundScriptures
          : foundScriptures // ignore: cast_nullable_to_non_nullable
              as List<BibleVerse>,
      assignedScripture: freezed == assignedScripture
          ? _value.assignedScripture
          : assignedScripture // ignore: cast_nullable_to_non_nullable
              as BibleVerse?,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      originalText: null == originalText
          ? _value.originalText
          : originalText // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      textSk: null == textSk
          ? _value.textSk
          : textSk // ignore: cast_nullable_to_non_nullable
              as String,
      textEn: null == textEn
          ? _value.textEn
          : textEn // ignore: cast_nullable_to_non_nullable
              as String,
      hasParagraphBreak: null == hasParagraphBreak
          ? _value.hasParagraphBreak
          : hasParagraphBreak // ignore: cast_nullable_to_non_nullable
              as bool,
      isScripture: null == isScripture
          ? _value.isScripture
          : isScripture // ignore: cast_nullable_to_non_nullable
              as bool,
      isWBQuote: null == isWBQuote
          ? _value.isWBQuote
          : isWBQuote // ignore: cast_nullable_to_non_nullable
              as bool,
      isBrRuss: null == isBrRuss
          ? _value.isBrRuss
          : isBrRuss // ignore: cast_nullable_to_non_nullable
              as bool,
      isSong: null == isSong
          ? _value.isSong
          : isSong // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TranscriptSegment extends _TranscriptSegment {
  _$_TranscriptSegment(
      {this.id,
      this.transcriptDataId,
      required this.start,
      required this.end,
      required this.startTime,
      final List<Place> places = const [],
      final List<BibleVerse> foundScriptures = const [],
      this.assignedScripture,
      required this.endTime,
      this.originalText = '',
      required this.text,
      this.textSk = '',
      this.textEn = '',
      this.hasParagraphBreak = false,
      this.isScripture = false,
      this.isWBQuote = false,
      this.isBrRuss = false,
      this.isSong = false})
      : _places = places,
        _foundScriptures = foundScriptures,
        super._();

  factory _$_TranscriptSegment.fromJson(Map<String, dynamic> json) =>
      _$$_TranscriptSegmentFromJson(json);

  @override
  final int? id;
  @override
  final int? transcriptDataId;
// required final int seek,
  @override
  final int start;
  @override
  final int end;
  @override
  final String startTime;
  final List<Place> _places;
  @override
  @JsonKey()
  List<Place> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  final List<BibleVerse> _foundScriptures;
  @override
  @JsonKey()
  List<BibleVerse> get foundScriptures {
    if (_foundScriptures is EqualUnmodifiableListView) return _foundScriptures;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_foundScriptures);
  }

  @override
  final BibleVerse? assignedScripture;
  @override
  final String endTime;
  @override
  @JsonKey()
  final String originalText;
  @override
  final String text;
  @override
  @JsonKey()
  final String textSk;
  @override
  @JsonKey()
  final String textEn;
  @override
  @JsonKey()
  final bool hasParagraphBreak;
  @override
  @JsonKey()
  final bool isScripture;
  @override
  @JsonKey()
  final bool isWBQuote;
  @override
  @JsonKey()
  final bool isBrRuss;
  @override
  @JsonKey()
  final bool isSong;

  @override
  String toString() {
    return 'TranscriptSegment(id: $id, transcriptDataId: $transcriptDataId, start: $start, end: $end, startTime: $startTime, places: $places, foundScriptures: $foundScriptures, assignedScripture: $assignedScripture, endTime: $endTime, originalText: $originalText, text: $text, textSk: $textSk, textEn: $textEn, hasParagraphBreak: $hasParagraphBreak, isScripture: $isScripture, isWBQuote: $isWBQuote, isBrRuss: $isBrRuss, isSong: $isSong)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TranscriptSegment &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transcriptDataId, transcriptDataId) ||
                other.transcriptDataId == transcriptDataId) &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            const DeepCollectionEquality().equals(other._places, _places) &&
            const DeepCollectionEquality()
                .equals(other._foundScriptures, _foundScriptures) &&
            (identical(other.assignedScripture, assignedScripture) ||
                other.assignedScripture == assignedScripture) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.originalText, originalText) ||
                other.originalText == originalText) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.textSk, textSk) || other.textSk == textSk) &&
            (identical(other.textEn, textEn) || other.textEn == textEn) &&
            (identical(other.hasParagraphBreak, hasParagraphBreak) ||
                other.hasParagraphBreak == hasParagraphBreak) &&
            (identical(other.isScripture, isScripture) ||
                other.isScripture == isScripture) &&
            (identical(other.isWBQuote, isWBQuote) ||
                other.isWBQuote == isWBQuote) &&
            (identical(other.isBrRuss, isBrRuss) ||
                other.isBrRuss == isBrRuss) &&
            (identical(other.isSong, isSong) || other.isSong == isSong));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      transcriptDataId,
      start,
      end,
      startTime,
      const DeepCollectionEquality().hash(_places),
      const DeepCollectionEquality().hash(_foundScriptures),
      assignedScripture,
      endTime,
      originalText,
      text,
      textSk,
      textEn,
      hasParagraphBreak,
      isScripture,
      isWBQuote,
      isBrRuss,
      isSong);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TranscriptSegmentCopyWith<_$_TranscriptSegment> get copyWith =>
      __$$_TranscriptSegmentCopyWithImpl<_$_TranscriptSegment>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TranscriptSegmentToJson(
      this,
    );
  }
}

abstract class _TranscriptSegment extends TranscriptSegment {
  factory _TranscriptSegment(
      {final int? id,
      final int? transcriptDataId,
      required final int start,
      required final int end,
      required final String startTime,
      final List<Place> places,
      final List<BibleVerse> foundScriptures,
      final BibleVerse? assignedScripture,
      required final String endTime,
      final String originalText,
      required final String text,
      final String textSk,
      final String textEn,
      final bool hasParagraphBreak,
      final bool isScripture,
      final bool isWBQuote,
      final bool isBrRuss,
      final bool isSong}) = _$_TranscriptSegment;
  _TranscriptSegment._() : super._();

  factory _TranscriptSegment.fromJson(Map<String, dynamic> json) =
      _$_TranscriptSegment.fromJson;

  @override
  int? get id;
  @override
  int? get transcriptDataId;
  @override // required final int seek,
  int get start;
  @override
  int get end;
  @override
  String get startTime;
  @override
  List<Place> get places;
  @override
  List<BibleVerse> get foundScriptures;
  @override
  BibleVerse? get assignedScripture;
  @override
  String get endTime;
  @override
  String get originalText;
  @override
  String get text;
  @override
  String get textSk;
  @override
  String get textEn;
  @override
  bool get hasParagraphBreak;
  @override
  bool get isScripture;
  @override
  bool get isWBQuote;
  @override
  bool get isBrRuss;
  @override
  bool get isSong;
  @override
  @JsonKey(ignore: true)
  _$$_TranscriptSegmentCopyWith<_$_TranscriptSegment> get copyWith =>
      throw _privateConstructorUsedError;
}
