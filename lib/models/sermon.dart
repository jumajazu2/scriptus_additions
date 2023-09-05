// import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// import '../utils/constants.dart' as Constants;

// import './sermon_file.dart';
// import 'package:http/http.dart' as http;
// import '../services/database.dart';
// import '../services/endpoint.dart';


part 'sermon.freezed.dart';
part 'sermon.g.dart';

@freezed
class Sermon with _$Sermon {
  factory Sermon({
    int? id,
    int? bookId,
    String? bTitle,
    int? authorId,
    int? category,
    String? title,
    String? language,
    String? imagePath,
    String? userItinerarySummary,
    String? fileName,
    String? ytId,
    int? meetingId,
    int? mId,
    String? mCity,
    String? mVenue,
    String? mPreachingName,
    String? meetingStart,
    int? brFrank,
    int? mpId,
    String? mpTitle,
    String? mpCity,
    String? embedCode,
    int? countryId,
    String? country,
    String? countryExt,
    String? broadcastedAt,
    bool? scripturesDone,
  }) = _Sermon;

  factory Sermon.fromJson(Map<String, Object?> json) => _$SermonFromJson(json);

  // List<SermonFile> sermonFiles;
  // DateTime today = new DateTime.now();
  // String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";

  // Sermon({
  //   this.id,
  //   this.bookId,
  //   this.bTitle,
  //   this.authorId,
  //   this.category,
  //   this.title,
  //   this.language,
  //   this.imagePath,
  //   this.userItinerarySummary,
  //   this.fileName,
  //   this.ytId,
  //   this.meetingId,
  //   this.mId,
  //   this.mVenue,
  //   this.mPreachingName,
  //   this.mpId,
  //   this.meetingStart,
  //   this.brFrank,
  //   this.mpTitle,
  //   this.mpCity,
  //   this.mCity,
  //   this.countryId,
  //   this.embedCode,
  //   // this.sermonFiles,
  //   this.country,
  //   this.countryExt,
  //   this.broadcastedAt,
  //   this.scripturesDone,
  // });

  factory Sermon.fromMap(Map<String, dynamic> json) => Sermon(
        id: json["ID"],
        bookId: json["book_id"],
        bTitle: json["bTitle"],
        authorId: json["author_id"],
        category: json["category"],
        title: json["title"],
        language: json["language"],
        fileName: json["file_name"],
        ytId: json["yt_video_id"],
        meetingId: json["meeting_id"],
        mId: json["meeting_id"],
        mPreachingName: json["preaching_name"],
        mVenue: json["venue"],
        mpId: json["meeting_place_id"],
        meetingStart: json["meeting_start"],
        brFrank: json["with_bro_frank"],
        mpTitle: json["mpTitle"],
        mpCity: json["city"],
        mCity: json["mCity"],
        embedCode: json["embedCode"],
        countryId: json["country_id"],
        countryExt: json["countryExt"],
        country: json["country"],
        broadcastedAt: json["broadcastedAt"],
        scripturesDone: json["scriptures_done"] == 1 ? true : false,
      );
}
  // factory Sermon.translationsFromMap(Map<String, dynamic> json) => Sermon(
  //       id: json["ID"],
  //       bookId: json["book_id"],
  //       authorId: json["author_id"],
  //       category: json["category"],
  //       title: json["title"],
  //       language: json["language"],
  //       fileName: json["file_name"],
  //       ytId: json["yt_video_id"],
  //       meetingId: json["meeting_id"],
  //       mId: json["mId"],
  //       mpId: json["meeting_place_id"],
  //       meetingStart: json["meeting_start"],
  //       brFrank: json["with_bro_frank"],
  //       mpTitle: json["mpTitle"],
  //       mpCity: json["city"],
  //       mCity: json["mCity"],
  //       embedCode: json["embedCode"],
  //       countryId: json["country_id"],
  //     );

//   Map<String, dynamic> toMap() => {"ID": id, "file_name": fileName};
// }


  // @override
  // int compareTo(other) {
  //   if (this.id == null || other == null) {
  //     return null;
  //   }

  //   if (this.id < other.id) {
  //     return 1;
  //   }

  //   if (this.id > other.id) {
  //     return -1;
  //   }

  //   if (this.id == other.id) {
  //     return 0;
  //   }

  //   return null;
  // }


    // print(dateSlug);

  // String get fileNameSanitized => !["", null, false, 0].contains(fileName)
  //     ? (fileName.replaceAll(' ', '%20'))
  //     : null;

  // String get properDate =>
  //     ["", null, false, 0].contains(meetingStart) ? 'Unknown' : DateFormat("yyyy-MM-dd - HH:mm").format(DateTime.parse(meetingStart));

  // String get mp3Path => ["", null, false, 0].contains(fileName)
  //     ? null
  //     : Constants.MP3_URL + fileNameSanitized;
  // bool get hasBook => !["", null, false, 0].contains(bookId);
  
  // Book get book => hasBook ? Book(id: bookId, title: bTitle, author: authorId) : null;

  // // get getTranslations async => await DBProvider.db.getMeetingTranslations(mId).map(t) => );

  // // bool get hasTranslations  => awaitgetTranslations.length > 0;

  // String get fullTitle => !["", null, false, 0].contains(meetingStart)
  //     ? properDate
  //     : (["", null, false, 0].contains(title) ? title : fileName);

  // String get cityAndDate => !["", null, false, 0].contains(meetingStart)
  //     ? properDate + ' - ' + mpCity
  //     : (["", null, false, 0].contains(title) ? title : fileName);

  // String get properCity => !["", null, false, 0].contains(mpCity)
  //     ? mpCity
  //     : (mCity != null ? mCity : 'test2');

  // String get properTitle => ["", null, false, 0].contains(title)
  //     ? (["", null, false, 0].contains(mPreachingName)
  //         ? (["", null, false, 0, "0000-00-00 00:00:00"].contains(meetingStart)
  //             ? fileName
  //             : properDate)
  //         : mPreachingName)
  //     : title;

  // String get location => "$properCity, $country";

  // String get authorName =>
  //     authorId != null ? Constants.AUTHORS[authorId] : 'no author';
  // // title != null ? title : (fileName != null ? fileName : meetingStart);
  // // String get titleCalc => title != null ? title : (fileName != null ? fileName : meetingStart);

  // AssetImage get sermonImage {
  //   // Image image;
  //   if (category == 3) {
  //     return AssetImage('assets/images/tv.jpg');
  //   } else {
  //     if (authorId == 1) {
  //       return AssetImage('assets/images/bf.jpg');
  //     } else {
  //     return AssetImage('assets/images/wb3.jpg');
  //     }
  //   }
  // }

  // String get videoId {
  //   if (ytId == null && embedCode != null) {
  //     id = RegExp(r"d\/(\w+)\' ");
  //     return id.stringMatch(ytId);
  //   } else {
  //     return ytId;
  //   }
  // }