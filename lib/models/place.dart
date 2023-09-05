import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scriptus/models/bible_verse.dart';

part 'place.freezed.dart';
part 'place.g.dart';

/// Represents a place with various properties.
@freezed
class Place with _$Place {
  /// Creates a new place.
  ///
  /// Throws a [FormatException] if [id], [meetingId], [chapterNumber],
  /// [bookId], or [verseStartId] is null.

  const Place._();
  // @override
  const factory Place({
    int? id,
    int? meetingId,
    int? sermonId,
    int? segmentId,
    int? transcriptDataId,
    @Default('de') String language,
    @Default('Unknown') String timePosition,
    @Default(-1) int chapterNumber,
    @Default(-1) int bookId,
    @Default('Unknown') String bookName,
    int? verseStartId,
    @Default('Unknown') String verseText,
    String? verseTextModified,
    String? verses,
    @Default(-1) int verseStartNumber,
    @Default(-1) int verseEndNumber,
    int? verseEndId,
    DateTime? createdAt,
    int? referencePosition,
    @Default(false) bool isReference,
    @Default(false) bool isFullSegment,
    @Default(false) bool note,
    @Default(false) bool keepWithPrevious,
    @Default([]) List<int> verseIds,
    @Default(1) int createdBy,

    // int? sermonId;
    // String? timePosition;
    // String? verseText;
    // String? verseTextModified;
    // int? chapterNumber;
    // int? chapterId;
    // List<int> verseIds = [];
    // String? createdAt;
    // bool? note;
    // bool? keepWithPrevious = false;
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

  // Create a BibleVerse from Place object
  factory Place.fromBibleVerse(BibleVerse verse) {
    return Place(
      verseStartNumber: verse.verse ?? 1,
      verseStartId: verse.verse,
      bookId: verse.bookId ?? 1,
      bookName: verse.bookAbb ?? '1M',
      chapterNumber: verse.bibleChapter ?? 1,
      verseText: verse.content,
    );
  }

  // final place =  _$PlaceFromJson(json);
  bool arePlacesEqual(Place a, Place b) {
    return a.meetingId == b.meetingId &&
        a.language == b.language &&
        a.timePosition == b.timePosition &&
        a.chapterNumber == b.chapterNumber &&
        a.bookName == b.bookName &&
        a.verseStartId == b.verseStartId &&
        a.verseStartNumber == b.verseStartNumber &&
        a.verseEndNumber == b.verseEndNumber &&
        a.verseEndId == b.verseEndId;
  }

  List<Place> removeDuplicates(List<Place> places) {
    List<Place> uniquePlaces = [];

    for (var place in places) {
      if (!uniquePlaces
          .any((existingPlace) => arePlacesEqual(place, existingPlace))) {
        uniquePlaces.add(place);
      }
    }

    return uniquePlaces;
  }

  factory Place.fromMap(Map<String, dynamic> json) => Place(
        id: json["id"],
        meetingId: json["meetingId"],
        sermonId: json["sermonId"],
        bookId: json["bookId"] ?? -1,
        bookName: json["bookName"] ?? 'Unknown',
        // chapterId: json["chapterId"],
        chapterNumber: json["chapterNumber"] ?? -1,
        verseText: json["verseText"],
        verseTextModified: json["verseTextModified"],
        timePosition: json["timePosition"],
        verseStartId: json["verseStartId"] ?? -1,
        verseStartNumber: json["verseStartNumber"] ?? -1,
        verseEndNumber: json["verseEndNumber"] ?? -1,
        verseEndId: json["verseEndId"] ?? -1,
        verses: json["verses"],
        referencePosition: json["referencePosition"] ?? -1,
        isReference: json["isReference"] == 1 ? true : false,
        isFullSegment: json["isFullSegment"] == 1 ? true : false,
        note: json["note"] == 1 ? true : false,
        keepWithPrevious: json["keepWithPrevious"] == 1 ? true : false,
        // verseIds: json["verseIds"] ?? [],
        verseIds: json["verseIds"] != null && json["verseIds"] != ''
            ? List<int>.from(jsonDecode(json["verseIds"]).map((x) => x))
            : [],
        // createdAt: json["createdAt"],
        language: json["language"] ?? 'de',
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "meetingId": meetingId,
        "sermonId": sermonId,
        "segmentId": segmentId,
        "bookId": bookId,
        "bookName": bookName,
        "chapterNumber": chapterNumber,
        "timePosition": timePosition,
        "verseStartId": verseStartId,
        "verseStartNumber": verseStartNumber,
        "verseEndId": verseEndId,
        "verseEndNumber": verseEndNumber,
        "verseText": verseText,
        "verseTextModified": verseTextModified,
        "referencePosition": referencePosition,
        "isReference": isReference,
        "isFullSegment": isFullSegment,
        "note": note,
        "keepWithPrevious": keepWithPrevious,
        "verses": verses,
        // "verseIds": verseIds,
        "language": language,
        "createdAt": createdAt,
      };

  // Place copyWith(
  //         {int? id,
  //         int? meetingId,
  //         int? sermonId,
  //         String? timePosition,
  //         String? verseText,
  //         String? verseTextModified,
  //         List<int>? verseIds,
  //         int? chapterNumber,
  //         // int? chapterId,
  //         String? bookName,
  //         int? bookId,
  //         int? verseStartId,
  //         int? verseStartNumber,
  //         int? verseEndId,
  //         int? verseEndNumber,
  //         bool? note,
  //         bool? keepWithPrevious,
  //         String? createdAt,
  //         String? verses}) =>
  //     Place(
  //       id: id ?? this.id,
  //       meetingId: meetingId ?? this.meetingId,
  //       sermonId: sermonId ?? this.sermonId,
  //       chapterNumber: chapterNumber ?? this.chapterNumber,
  //       bookId: bookId ?? this.bookId,
  //       bookName: bookName ?? this.bookName,
  //       // chapterId: chapterId ?? this.chapterId,
  //       verses: verses ?? this.verses,
  //       verseIds: verseIds ?? this.verseIds,
  //       verseStartId: verseStartId ?? this.verseStartId,
  //       verseEndId: verseEndId ?? this.verseEndId,
  //       verseStartNumber: verseStartNumber ?? this.verseStartNumber,
  //       verseEndNumber: verseEndNumber ?? this.verseEndNumber,
  //       timePosition: timePosition ?? this.timePosition,
  //       verseText: verseText ?? this.verseText,
  //       verseTextModified: verseTextModified ?? this.verseTextModified,
  //       createdAt: createdAt ?? this.createdAt,
  //       note: note ?? this.note,
  //       keepWithPrevious: keepWithPrevious ?? this.keepWithPrevious,
  //     );
}


  // if (place.id == -1 ||
  //     place.meetingId == -1 ||
  //     place.chapterNumber == -1 ||
  //     place.bookId == -1 ||
  //     place.verseStartId == -1 ||
  //     place.position == 'Unknown') {
  //   throw FormatException('Invalid data in JSON');
  // }

  // return place;
  // }

  // final int? id;
  // int? meetingId;
  // int? sermonId;
  // String? timePosition;
  // String? verseText;
  // String? verseTextModified;
  // int? chapterNumber;
  // // int? chapterId;
  // String? bookName;
  // int? bookId;
  // int? verseStartId;
  // int? verseStartNumber;
  // int? verseEndId;
  // int? verseEndNumber;
  // String? verses;
  // List<int> verseIds = [];
  // String? createdAt;
  // bool? note;
  // bool? keepWithPrevious = false;

  // Place(
  //     {this.id,
  //     this.meetingId,
  //     this.sermonId,
  //     this.chapterNumber,
  //     this.bookId,
  //     this.bookName,
  //     // this.chapterId,
  //     this.verses,
  //     required this.verseIds,
  //     this.verseStartId,
  //     this.verseEndId,
  //     this.verseStartNumber,
  //     this.verseEndNumber,
  //     this.timePosition,
  //     this.verseText,
  //     this.verseTextModified,
  //     this.note,
  //     this.keepWithPrevious,
  //     this.createdAt});

  // @override
  // toString() =>
  //     "id: $id meetingId: $meetingId sermonId: $sermonId bookId: $bookId bookName: $bookName, chapterNumber: $chapterNumber timePosition: $timePosition verseStartId: $verseStartId verseStartNumber: $verseStartNumber verseEndId: $verseEndId verseEndNumber: $verseEndNumber verseIds: $verseIds verseText: $verseText";


// import 'package:flutter_data/flutter_data.dart';
// import 'package:json_annotation/json_annotation.dart';

// part 'place.g.dart';

/// Represents a place.
// @JsonSerializable()
// @DataRepository([])
// class Place extends DataModel<Place> {

