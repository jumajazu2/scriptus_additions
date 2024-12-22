import 'package:path/path.dart';
import 'package:scriptus/services/msk_db_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

//Function returns the string with a verse from versei.db based on bible ID, book, chapter, verse No.

Future<String?> getKJVVerseById(
    int bookNumber, int chapterNumber, int verseNumber, int bibleID) async {
  // Get the path to the database file
  MskDBProvider mskDBProvider = MskDBProvider();

  final databasePath = await getDatabasesPath();

  final dbPath = join(databasePath, 'versei.db'); // Adjust the database name
  //print(dbPath);
  // Open the database
  final Database db = await databaseFactoryFfi.openDatabase(dbPath);
  //print(db);

  try {
    // Query the verse by bible, book, chapter, verse
    final List<Map<String, dynamic>> result = await db.query(
      'msk_bible_verses', // Table name
      columns: ['content'], // Columns to retrieve
      where:
          'bible_id = ? AND book_id = ? AND bible_chapter = ? AND verse = ?', // WHERE clause
      whereArgs: [
        bibleID,
        bookNumber,
        chapterNumber,
        verseNumber
      ], // Arguments for the WHERE clause
    );

    // Check if a result was found
    if (result.isNotEmpty) {
      print(result.first['content']);
      return result.first['content'] as String; // Return the verse content
    } else {
      return null; // No verse found for the given ID
    }
  } catch (e) {
    print('Error retrieving verse: $e');
    return null;
  } finally {
    // Close the database
    //await db.close();
    print("----------------------------------------------------------");
  }
}
