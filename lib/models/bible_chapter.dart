/// Represents a Bible Chpater.
/// is created from msk_bible_verses table, from any verse of that chapter
class BibleChapter {
  final int id;
  final int bibleId;
  final int bookId;
  final int bibleChapter;
  final String? chapterText;

  BibleChapter({
    required this.id,
    required this.bibleId,
    required this.bookId,
    required this.bibleChapter,
    this.chapterText,
  });

  factory BibleChapter.fromMap(Map<String, dynamic> json) => BibleChapter(
        id: json["ID"],
        bookId: json["book_id"],
        bibleChapter: json["bible_chapter"],
        bibleId: json["bible_id"],
      );
  @override
  toString() =>
      "id: $id bookId: $bookId bibleChapter: $bibleChapter bibleId: $bibleId";

  Map<String, dynamic> toMap() => {
        "ID": id,
        "book_id": bookId,
        "bible_chapter": bibleChapter,
        "bible_id": bibleId,
      };
}
