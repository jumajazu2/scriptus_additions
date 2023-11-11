// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MeetingImpl _$$MeetingImplFromJson(Map<String, dynamic> json) =>
    _$MeetingImpl(
      id: json['id'] as int?,
      mpImage: json['mpImage'] as String?,
      link: json['link'] as String?,
      mpId: json['mpId'] as int?,
      meetingStart: json['meetingStart'] as String?,
      broadcastedAt: json['broadcastedAt'] as String?,
      brFrank: json['brFrank'] as bool?,
      mpTitle: json['mpTitle'] as String?,
      venue: json['venue'] as String?,
      city: json['city'] as String?,
      mpCountry: json['mpCountry'] as String?,
      preachingName: json['preachingName'] as String?,
      note: json['note'] as String?,
      zip: json['zip'] as String?,
      countryExt: json['countryExt'] as String?,
      street: json['street'] as String?,
      countryId: json['countryId'] as int?,
      scripturesDone: json['scripturesDone'] as bool?,
      lastEditTime: json['lastEditTime'] == null
          ? null
          : Duration(microseconds: json['lastEditTime'] as int),
      topic: json['topic'] as String?,
      places: (json['places'] as List<dynamic>?)
          ?.map((e) => Place.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MeetingImplToJson(_$MeetingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mpImage': instance.mpImage,
      'link': instance.link,
      'mpId': instance.mpId,
      'meetingStart': instance.meetingStart,
      'broadcastedAt': instance.broadcastedAt,
      'brFrank': instance.brFrank,
      'mpTitle': instance.mpTitle,
      'venue': instance.venue,
      'city': instance.city,
      'mpCountry': instance.mpCountry,
      'preachingName': instance.preachingName,
      'note': instance.note,
      'zip': instance.zip,
      'countryExt': instance.countryExt,
      'street': instance.street,
      'countryId': instance.countryId,
      'scripturesDone': instance.scripturesDone,
      'lastEditTime': instance.lastEditTime?.inMicroseconds,
      'topic': instance.topic,
      'places': instance.places,
    };
