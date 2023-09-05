// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bible_verse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BibleVerse _$BibleVerseFromJson(Map<String, dynamic> json) {
  return _BibleVerse.fromJson(json);
}

/// @nodoc
mixin _$BibleVerse {
// class BibleVerse {
  int? get id => throw _privateConstructorUsedError; // final int bibleId;
  int? get bookId => throw _privateConstructorUsedError;
  int? get bibleChapter => throw _privateConstructorUsedError;
  int? get verse => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get bookAbb => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BibleVerseCopyWith<BibleVerse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BibleVerseCopyWith<$Res> {
  factory $BibleVerseCopyWith(
          BibleVerse value, $Res Function(BibleVerse) then) =
      _$BibleVerseCopyWithImpl<$Res, BibleVerse>;
  @useResult
  $Res call(
      {int? id,
      int? bookId,
      int? bibleChapter,
      int? verse,
      String content,
      String? bookAbb});
}

/// @nodoc
class _$BibleVerseCopyWithImpl<$Res, $Val extends BibleVerse>
    implements $BibleVerseCopyWith<$Res> {
  _$BibleVerseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookId = freezed,
    Object? bibleChapter = freezed,
    Object? verse = freezed,
    Object? content = null,
    Object? bookAbb = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      bookId: freezed == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as int?,
      bibleChapter: freezed == bibleChapter
          ? _value.bibleChapter
          : bibleChapter // ignore: cast_nullable_to_non_nullable
              as int?,
      verse: freezed == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as int?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      bookAbb: freezed == bookAbb
          ? _value.bookAbb
          : bookAbb // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BibleVerseCopyWith<$Res>
    implements $BibleVerseCopyWith<$Res> {
  factory _$$_BibleVerseCopyWith(
          _$_BibleVerse value, $Res Function(_$_BibleVerse) then) =
      __$$_BibleVerseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? bookId,
      int? bibleChapter,
      int? verse,
      String content,
      String? bookAbb});
}

/// @nodoc
class __$$_BibleVerseCopyWithImpl<$Res>
    extends _$BibleVerseCopyWithImpl<$Res, _$_BibleVerse>
    implements _$$_BibleVerseCopyWith<$Res> {
  __$$_BibleVerseCopyWithImpl(
      _$_BibleVerse _value, $Res Function(_$_BibleVerse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookId = freezed,
    Object? bibleChapter = freezed,
    Object? verse = freezed,
    Object? content = null,
    Object? bookAbb = freezed,
  }) {
    return _then(_$_BibleVerse(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      bookId: freezed == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as int?,
      bibleChapter: freezed == bibleChapter
          ? _value.bibleChapter
          : bibleChapter // ignore: cast_nullable_to_non_nullable
              as int?,
      verse: freezed == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as int?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      bookAbb: freezed == bookAbb
          ? _value.bookAbb
          : bookAbb // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_BibleVerse extends _BibleVerse {
  _$_BibleVerse(
      {this.id,
      required this.bookId,
      required this.bibleChapter,
      required this.verse,
      required this.content,
      required this.bookAbb})
      : super._();

  factory _$_BibleVerse.fromJson(Map<String, dynamic> json) =>
      _$$_BibleVerseFromJson(json);

// class BibleVerse {
  @override
  final int? id;
// final int bibleId;
  @override
  final int? bookId;
  @override
  final int? bibleChapter;
  @override
  final int? verse;
  @override
  final String content;
  @override
  final String? bookAbb;

  @override
  String toString() {
    return 'BibleVerse(id: $id, bookId: $bookId, bibleChapter: $bibleChapter, verse: $verse, content: $content, bookAbb: $bookAbb)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BibleVerse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bibleChapter, bibleChapter) ||
                other.bibleChapter == bibleChapter) &&
            (identical(other.verse, verse) || other.verse == verse) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.bookAbb, bookAbb) || other.bookAbb == bookAbb));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, bookId, bibleChapter, verse, content, bookAbb);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BibleVerseCopyWith<_$_BibleVerse> get copyWith =>
      __$$_BibleVerseCopyWithImpl<_$_BibleVerse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BibleVerseToJson(
      this,
    );
  }
}

abstract class _BibleVerse extends BibleVerse {
  factory _BibleVerse(
      {final int? id,
      required final int? bookId,
      required final int? bibleChapter,
      required final int? verse,
      required final String content,
      required final String? bookAbb}) = _$_BibleVerse;
  _BibleVerse._() : super._();

  factory _BibleVerse.fromJson(Map<String, dynamic> json) =
      _$_BibleVerse.fromJson;

  @override // class BibleVerse {
  int? get id;
  @override // final int bibleId;
  int? get bookId;
  @override
  int? get bibleChapter;
  @override
  int? get verse;
  @override
  String get content;
  @override
  String? get bookAbb;
  @override
  @JsonKey(ignore: true)
  _$$_BibleVerseCopyWith<_$_BibleVerse> get copyWith =>
      throw _privateConstructorUsedError;
}
