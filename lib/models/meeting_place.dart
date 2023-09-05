import 'package:freezed_annotation/freezed_annotation.dart';
part 'meeting_place.freezed.dart';
part 'meeting_place.g.dart';

@freezed
class MeetingPlace with _$MeetingPlace {
  const MeetingPlace._();

  factory MeetingPlace({
    int? id,
    @JsonKey(name: 'city') String? mCity, // Map the city property here
  }) = _MeetingPlace;

  factory MeetingPlace.fromJson(Map<String, dynamic> json) =>
      _$MeetingPlaceFromJson(json);
}
