// import 'package:http/http.dart' as http;
// import './meeting_file.dart';
import 'package:diacritic/diacritic.dart';
import 'package:intl/intl.dart';
// import '../services/database.dart';
// import '../services/endpoint.dart';
// import '../services/constants.dart' as Constants;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scriptus/models/place.dart';
// import 'package:intl/intl.dart';
// import 'package:scriptus/models/meeting_place.dart';
// import 'package:flutter_data/flutter_data.dart';
// import 'package:json_annotation/json_annotation.dart';

part 'meeting.freezed.dart';
part 'meeting.g.dart';

@freezed
class Meeting with _$Meeting {
  const Meeting._();

  factory Meeting({
// class Meeting  extends _$Meeting {
    // @override
    int? id,
    // int bookId,
    // int authorId,
    String? mpImage,
    // String userItinerarySummary,
    String? link,
    // int meetingId,
    // int mId,
    int? mpId,
    String? meetingStart,
    String? broadcastedAt,
    bool? brFrank,
    String? mpTitle,
    String? venue,
    String? city,
    String? mpCountry,
    String? preachingName,
    String? note,
    String? zip,
    String? countryExt,
    String? street,
    int? countryId,
    bool? scripturesDone,
    Duration? lastEditTime,
    String? topic,
    List<Place>? places,
    // MeetingPlace? meetingPlace, // Add this field to your class

    // final String embedCode,
    // final List<MeetingFile> meetingFiles,

    // String get coverPath  {
    //   if (!["", null, false, 0].contains(mpImage)) {
    //     return Constants.MEETING_URL + mpImage;
    //   } else {
    //     return mpId == 2 ? 'assets/images/krefeld.jpg' : (mpId == 3 ? 'assets/images/zurich.jpg' : null);
    //   }
    // }

    // const Meeting._();
  }) = _Meeting;

  factory Meeting.fromJson(Map<String, Object?> json) =>
      _$MeetingFromJson(json);

  factory Meeting.fromMap(Map<String, dynamic> json) => Meeting(
        id: json["ID"],
        note: json["note"],
        preachingName: json["preaching_name"],
        link: json["link"],
        venue: json["venue"],
        street: json["street"],
        zip: json["zip"],
        countryExt: json["countryExt"],
        //       ytId: json["yt_video_id"],
        //  meetingId: json["meeting_id"],
        mpImage: json["image"],
        places: json["places"] != null
            ? List<Place>.from(json["places"].map((x) => Place.fromMap(x)))
            : null,
        topic: json["topic"],
        mpId: json["meeting_place_id"],
        meetingStart: json["meeting_start"],
        broadcastedAt: json["broadcastedAt"],
        brFrank: json["with_bro_frank"],
        mpTitle: json["mpTitle"],
        city: json["city"],
        mpCountry: json["country"],
        countryId: json["country_id"],
        scripturesDone: json["scriptures_done"] == 1 ? true : false,
        // lastEditTime: json["lastEditTime"] == null
        //     ? Duration.zero
        //     : Duration(json["lastEditTime"]),
      );

  String commonDate() {
    var dateFormat = DateFormat("dd. MM. yyyy, HH:mm")
        .format(DateTime.parse(meetingStart ?? ''));
    return dateFormat;
    // DateTime today = new DateTime.now();
    // String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    // print(dateSlug);
  }

  String get mp3LinkBase {
    // print(this);
    if (city != null) {
      // final String vcity = city!.replaceAll('ü', 'u');
      var dateFormat = DateFormat("yyyy-MM-dd-HHmm")
          .format(DateTime.parse(meetingStart ?? '0000-00-00 00:00:00'));
      var city2 = removeDiacritics(city ?? '');

      // var lang = '';
      // fill lang based on whether loaded json file name contains string english, german, french etc.

      var filename = '$dateFormat-$city2';
      var link = 'https://www.misia.sk/public/data/sermons/$filename';
      // print(link);
      // https://www.misia.sk/public/data/sermons/1981-09-27-1400-Zurich-deutsch.mp3
      // https://www.misia.sk/public/data/sermons/1974-09-08-1500-Krefeld-english.mp3
      return link;
    } else {
      return '';
    }
    // DateTime today = new DateTime.now();
    // String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    // print(dateSlug);
  }

  String get mp3Link {
    var link = '$mp3LinkBase-deutsch.mp3';
    return link;
  }

  String get miroDate {
    if (meetingStart != null) {
      var dateFormat = DateFormat("yyyy-MM-dd-HHmm")
          .format(DateTime.parse(meetingStart ?? '0000-00-00 00:00:00'));
      return dateFormat;
    } else {
      return 'Select a Meeting…';
    }
    // DateTime today = new DateTime.now();
    // String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    // print(dateSlug);
  }
  // String dateTimeString = '1975-12-21T10:00:00.000Z';
  // DateTime dateTime = DateTime.parse(dateTimeString);

  // Create a new DateFormat.
  // var formatter = DateFormat('yyyy-MM-dd HH:mm');

  // Use the formatter to format the DateTime
// }

  String get properDate {
    try {
      var dateFormat =
          DateFormat("dd. MM. yyyy").format(DateTime.parse(meetingStart ?? ''));
      return dateFormat;
    } catch (e) {
      return 'No Meeting selected.';
    }
    // var dateFormat = DateFormat("yyyy-MM-dd - HH:mm")
    //     .format(DateTime.parse(meetingStart ?? ''));
    // return dateFormat;
    // DateTime today = new DateTime.now();
    // String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    // print(dateSlug);
  }

  // String get mp3Path => ["", null, false, 0].contains(fileName) ? null : Constants.MP3_URL + fileName;
  // bool get hasBook => !["", null, false, 0].contains(bookId) ;
  // String get properTitle => !["", null, false, 0].contains(meetingStart) ? properDate : (["", null, false, 0].contains(title) ? title : fileName);
  // String get cityAndDate => !["", null, false, 0].contains(mpCity)
  //     ? "${properDate} - ${mpCity}"
  //     : properDate;
  // return out;
  // }

  String get location {
    return "$mpTitle, $city, $mpCountry ";
    // title != null ? title : (fileName != null ? fileName : meetingStart);
  }

  String get cityAndCountry {
    return "$city, $mpCountry ";
    // title != null ? title : (fileName != null ? fileName : meetingStart);
  }

  // String get videoId {
  //   if (ytId == null && embedCode != null) {
  //     final id = RegExp(r"d\/(\w+)\' ");
  //     return id.stringMatch(ytId);
  //   } else {
  //     return ytId;
  //   }
  // }

  // String get authorName => authorId != null ? Constants.AUTHORS[authorId] : 'no author';

  // String get titleCalc => title != null ? title : (fileName != null ? fileName : meetingStart);

  // Meeting({
  //   this.id,
  //   // this.bookId,
  //   // this.authorId,
  //   this.preachingName,
  //   this.venue,
  //   this.note,
  //   this.link,
  //   this.mpImage,
  //   this.street,
  //   this.zip,
  //   // this.ytId,
  //   // this.meetingId,
  //   // this.mId,
  //   this.mpId,
  //   this.meetingStart,
  //   this.broadcastedAt,
  //   this.brFrank,
  //   this.mpTitle,
  //   this.mpCity,
  //   this.countryId,
  //   this.mpCountry,
  //   this.countryExt,
  //   this.scripturesDone,
  //   this.lastEditTime,
  //   this.topic,
  //   // this.meetingFiles,
  // });

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

  // Map<String, dynamic> toMap() => {"ID": id, "meeting_place_id": mpId};
}
