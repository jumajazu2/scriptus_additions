import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scriptus/models/place.dart';

part 'bible_verse.freezed.dart';
part 'bible_verse.g.dart';

@freezed
class BibleVerse with _$BibleVerse {
  const BibleVerse._();

  factory BibleVerse({
    // class BibleVerse {
    final int? id,
    // final int bibleId;
    required int? bookId,
    required int? bibleChapter,
    required int? verse,
    required String content,
    required String? bookAbb,

    // BibleVerse({
    //   // required this.id,
    //   // required this.bibleId,
    //   required this.bookId,
    //   required this.bibleChapter,
    //   required this.verse,
    //   required this.content,
    //   this.bookAbb,
    //   // this.bookTitle,
  }) = _BibleVerse;

  String get reference => '$bookAbb $bibleChapter:$verse';

  // Create a BibleVerse from Place object
  factory BibleVerse.fromPlace(Place place) {
    return BibleVerse(
      verse: place.verseStartId,
      bookId: place.bookId,
      bookAbb: place.bookName,
      bibleChapter: place.chapterNumber,
      content: place.verseText,
    );
  }

  factory BibleVerse.fromJson(Map<String, dynamic> json) =>
      _$BibleVerseFromJson(json);

  factory BibleVerse.fromMap(Map<String, dynamic> json) => BibleVerse(
        id: json["ID"],
        bookId: json["book_number"],
        content: json["text"],
        bibleChapter: json["chapter"],
        verse: json["verse"],
        // bibleId: json["bible_id"],
        bookAbb: json["short_name"],
      );

  factory BibleVerse.fromMapMsk(Map<String, dynamic> json) => BibleVerse(
        id: json["ID"],
        bookId: json["book_id"],
        content: json["content"],
        bibleChapter: json["bible_chapter"],
        verse: json["verse"],
        // bibleId: json["bible_id"],
        bookAbb: json["abb"],
      );
  Map<String, dynamic> toMap() => {
        "ID": id,
        "book_number": bookId,
        "chapter": bibleChapter,
        "text": content,
        "verse": verse,
        // "bible_id": bibleId,
        "short_name": bookAbb,
      };
  // @override
  // toString() =>
  //     " bookId: $bookId bibleChapter: $bibleChapter verse: $verse  content: $content";
}
