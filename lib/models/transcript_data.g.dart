// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TranscriptData _$$_TranscriptDataFromJson(Map<String, dynamic> json) =>
    _$_TranscriptData(
      id: json['id'] as int?,
      text: json['text'] as String,
      originalText: json['originalText'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      segments: (json['segments'] as List<dynamic>)
          .map((e) => TranscriptSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
      language: json['language'] as String,
      meetingId: json['meetingId'] as int,
    );

Map<String, dynamic> _$$_TranscriptDataToJson(_$_TranscriptData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'originalText': instance.originalText,
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'segments': instance.segments,
      'language': instance.language,
      'meetingId': instance.meetingId,
    };
