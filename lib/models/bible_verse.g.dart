// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BibleVerse _$$_BibleVerseFromJson(Map<String, dynamic> json) =>
    _$_BibleVerse(
      id: json['id'] as int?,
      bookId: json['bookId'] as int?,
      bibleChapter: json['bibleChapter'] as int?,
      verse: json['verse'] as int?,
      content: json['content'] as String,
      bookAbb: json['bookAbb'] as String?,
    );

Map<String, dynamic> _$$_BibleVerseToJson(_$_BibleVerse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'bibleChapter': instance.bibleChapter,
      'verse': instance.verse,
      'content': instance.content,
      'bookAbb': instance.bookAbb,
    };
