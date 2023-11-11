// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sermon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SermonImpl _$$SermonImplFromJson(Map<String, dynamic> json) => _$SermonImpl(
      id: json['id'] as int?,
      bookId: json['bookId'] as int?,
      bTitle: json['bTitle'] as String?,
      authorId: json['authorId'] as int?,
      category: json['category'] as int?,
      title: json['title'] as String?,
      language: json['language'] as String?,
      imagePath: json['imagePath'] as String?,
      userItinerarySummary: json['userItinerarySummary'] as String?,
      fileName: json['fileName'] as String?,
      ytId: json['ytId'] as String?,
      meetingId: json['meetingId'] as int?,
      mId: json['mId'] as int?,
      mCity: json['mCity'] as String?,
      mVenue: json['mVenue'] as String?,
      mPreachingName: json['mPreachingName'] as String?,
      meetingStart: json['meetingStart'] as String?,
      brFrank: json['brFrank'] as int?,
      mpId: json['mpId'] as int?,
      mpTitle: json['mpTitle'] as String?,
      mpCity: json['mpCity'] as String?,
      embedCode: json['embedCode'] as String?,
      countryId: json['countryId'] as int?,
      country: json['country'] as String?,
      countryExt: json['countryExt'] as String?,
      broadcastedAt: json['broadcastedAt'] as String?,
      scripturesDone: json['scripturesDone'] as bool?,
    );

Map<String, dynamic> _$$SermonImplToJson(_$SermonImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookId': instance.bookId,
      'bTitle': instance.bTitle,
      'authorId': instance.authorId,
      'category': instance.category,
      'title': instance.title,
      'language': instance.language,
      'imagePath': instance.imagePath,
      'userItinerarySummary': instance.userItinerarySummary,
      'fileName': instance.fileName,
      'ytId': instance.ytId,
      'meetingId': instance.meetingId,
      'mId': instance.mId,
      'mCity': instance.mCity,
      'mVenue': instance.mVenue,
      'mPreachingName': instance.mPreachingName,
      'meetingStart': instance.meetingStart,
      'brFrank': instance.brFrank,
      'mpId': instance.mpId,
      'mpTitle': instance.mpTitle,
      'mpCity': instance.mpCity,
      'embedCode': instance.embedCode,
      'countryId': instance.countryId,
      'country': instance.country,
      'countryExt': instance.countryExt,
      'broadcastedAt': instance.broadcastedAt,
      'scripturesDone': instance.scripturesDone,
    };
