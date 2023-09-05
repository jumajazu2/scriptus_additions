// import 'package:http/http.dart' as http;

import './bible_verse.dart';
// import '../services/database.dart';
// import '../services/endpoint.dart';

/// Represents a Bible Book.
class BibleBook {
  final int id;
  final int bibleId;
  final String title;
  final String abb;
  final int? testament;
  final int position;
  final String color;
  // String bookTitle;
  List<BibleVerse>? bibleVerses;

  BibleBook({
    required this.id,
    required this.bibleId,
    required this.title,
    required this.abb,
    required this.position,
    required this.testament,
    required this.color,
    // this.bookTitle,
  });

  factory BibleBook.fromMap(Map<String, dynamic> json) => BibleBook(
        id: json["ID"],
        title: json["title"],
        abb: json["abb"],
        testament: json["testament"],
        position: json["position"],
        bibleId: json["bible_id"],
        color: json["color"] ?? '0xff000088',
      );

  Map<String, dynamic> toMap() => {
        "ID": id,
        "title": title,
        "testament": testament,
        "abb": abb,
        "position": position,
        "bible_id": bibleId,
        "color": color,
      };
}
