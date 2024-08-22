// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TranscriptDataImpl _$$TranscriptDataImplFromJson(Map<String, dynamic> json) =>
    _$TranscriptDataImpl(
      id: (json['id'] as num?)?.toInt(),
      text: json['text'] as String,
      originalText: json['originalText'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      segments: (json['segments'] as List<dynamic>)
          .map((e) => TranscriptSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
      language: json['language'] as String,
      mp3Language: json['mp3Language'] as String,
      meetingId: (json['meetingId'] as num).toInt(),
      offsetSeconds: (json['offsetSeconds'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TranscriptDataImplToJson(
        _$TranscriptDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'originalText': instance.originalText,
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'segments': instance.segments,
      'language': instance.language,
      'mp3Language': instance.mp3Language,
      'meetingId': instance.meetingId,
      'offsetSeconds': instance.offsetSeconds,
    };
