// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceImpl _$$PlaceImplFromJson(Map<String, dynamic> json) => _$PlaceImpl(
      id: (json['id'] as num?)?.toInt(),
      meetingId: (json['meetingId'] as num?)?.toInt(),
      sermonId: (json['sermonId'] as num?)?.toInt(),
      segmentId: (json['segmentId'] as num?)?.toInt(),
      transcriptDataId: (json['transcriptDataId'] as num?)?.toInt(),
      language: json['language'] as String? ?? 'de',
      timePosition: json['timePosition'] as String? ?? 'Unknown',
      chapterNumber: (json['chapterNumber'] as num?)?.toInt() ?? -1,
      bookId: (json['bookId'] as num?)?.toInt() ?? -1,
      bookName: json['bookName'] as String? ?? 'Unknown',
      verseStartId: (json['verseStartId'] as num?)?.toInt(),
      verseText: json['verseText'] as String? ?? 'Unknown',
      verseTextModified: json['verseTextModified'] as String?,
      verses: json['verses'] as String?,
      verseStartNumber: (json['verseStartNumber'] as num?)?.toInt() ?? -1,
      verseEndNumber: (json['verseEndNumber'] as num?)?.toInt() ?? -1,
      verseEndId: (json['verseEndId'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      referencePosition: (json['referencePosition'] as num?)?.toInt(),
      isReference: json['isReference'] as bool? ?? false,
      isFullSegment: json['isFullSegment'] as bool? ?? false,
      note: json['note'] as bool? ?? false,
      keepWithPrevious: json['keepWithPrevious'] as bool? ?? false,
      verseIds: (json['verseIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      createdBy: (json['createdBy'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$PlaceImplToJson(_$PlaceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'meetingId': instance.meetingId,
      'sermonId': instance.sermonId,
      'segmentId': instance.segmentId,
      'transcriptDataId': instance.transcriptDataId,
      'language': instance.language,
      'timePosition': instance.timePosition,
      'chapterNumber': instance.chapterNumber,
      'bookId': instance.bookId,
      'bookName': instance.bookName,
      'verseStartId': instance.verseStartId,
      'verseText': instance.verseText,
      'verseTextModified': instance.verseTextModified,
      'verses': instance.verses,
      'verseStartNumber': instance.verseStartNumber,
      'verseEndNumber': instance.verseEndNumber,
      'verseEndId': instance.verseEndId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'referencePosition': instance.referencePosition,
      'isReference': instance.isReference,
      'isFullSegment': instance.isFullSegment,
      'note': instance.note,
      'keepWithPrevious': instance.keepWithPrevious,
      'verseIds': instance.verseIds,
      'createdBy': instance.createdBy,
    };
