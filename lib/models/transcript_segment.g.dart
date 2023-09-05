// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_segment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TranscriptSegment _$$_TranscriptSegmentFromJson(Map<String, dynamic> json) =>
    _$_TranscriptSegment(
      id: json['id'] as int?,
      transcriptDataId: json['transcriptDataId'] as int?,
      start: json['start'] as int,
      end: json['end'] as int,
      startTime: json['startTime'] as String,
      places: (json['places'] as List<dynamic>?)
              ?.map((e) => Place.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      foundScriptures: (json['foundScriptures'] as List<dynamic>?)
              ?.map((e) => BibleVerse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      assignedScripture: json['assignedScripture'] == null
          ? null
          : BibleVerse.fromJson(
              json['assignedScripture'] as Map<String, dynamic>),
      endTime: json['endTime'] as String,
      originalText: json['originalText'] as String? ?? '',
      text: json['text'] as String,
      textSk: json['textSk'] as String? ?? '',
      textEn: json['textEn'] as String? ?? '',
      hasParagraphBreak: json['hasParagraphBreak'] as bool? ?? false,
      isScripture: json['isScripture'] as bool? ?? false,
      isWBQuote: json['isWBQuote'] as bool? ?? false,
      isBrRuss: json['isBrRuss'] as bool? ?? false,
      isSong: json['isSong'] as bool? ?? false,
    );

Map<String, dynamic> _$$_TranscriptSegmentToJson(
        _$_TranscriptSegment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transcriptDataId': instance.transcriptDataId,
      'start': instance.start,
      'end': instance.end,
      'startTime': instance.startTime,
      'places': instance.places,
      'foundScriptures': instance.foundScriptures,
      'assignedScripture': instance.assignedScripture,
      'endTime': instance.endTime,
      'originalText': instance.originalText,
      'text': instance.text,
      'textSk': instance.textSk,
      'textEn': instance.textEn,
      'hasParagraphBreak': instance.hasParagraphBreak,
      'isScripture': instance.isScripture,
      'isWBQuote': instance.isWBQuote,
      'isBrRuss': instance.isBrRuss,
      'isSong': instance.isSong,
    };
