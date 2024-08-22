// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bible_verse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BibleVerseImpl _$$BibleVerseImplFromJson(Map<String, dynamic> json) =>
    _$BibleVerseImpl(
      id: (json['id'] as num?)?.toInt(),
      bookId: (json['bookId'] as num?)?.toInt(),
      bibleChapter: (json['bibleChapter'] as num?)?.toInt(),
      verse: (json['verse'] as num?)?.toInt(),
      content: json['content'] as String,
      bookAbb: json['bookAbb'] as String?,
    );

Map<String, dynamic> _$$BibleVerseImplToJson(_$BibleVerseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'bibleChapter': instance.bibleChapter,
      'verse': instance.verse,
      'content': instance.content,
      'bookAbb': instance.bookAbb,
    };
