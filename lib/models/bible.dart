import './bible_book.dart';
// import 'package:http/http.dart' as http;
// import './bible_verse.dart';
// import '../services/database.dart';
// import '../services/endpoint.dart';
// import '../services/constants.dart' as Constants;

/// Represents a sermon.
class Bible {
  final int id;
  final String title;
  final String abb;
  final String language;
  List<BibleBook>? bibleBooks;

  Bible({
    required this.id,
    required this.title,
    required this.abb,
    required this.language,
    this.bibleBooks,
  });

  factory Bible.fromMap(Map<String, dynamic> json) => Bible(
        id: json["ID"],
        title: json["title"],
        abb: json["abb"],
        language: json["language"],
      );

  Map<String, dynamic> toMap() => {
        "ID": id,
        "title": title,
        "abb": abb,
        "language": language,
      };
}
