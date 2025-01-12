import 'package:path/path.dart';
import 'package:scriptus/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/services/msk_db_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:scriptus/providers/variable_monitor.dart';

//Function returns the string with a verse from versei.db based on bible ID, book, chapter, verse No.

Future<String?> getKJVVerseById(int bookNumber, String bookName,
    int chapterNumber, int verseNumber, int bibleID, WidgetRef ref) async {
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
      //print(result.first['content']);
      fromAPItoKJV.add("$bookName $chapterNumber:$verseNumber");
      fromAPItoKJV.add(result.first['content']);
      print("*****************");
      print(fromAPItoKJV);
      print("*****************");
      clicks = clicks +
          1; //increases whenever the function is called, used for updating widget viac variable_monitor.dart

      ref.read(variablemonitorProvider.notifier).state++;
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

Future<String?> contextByID(
    String verseText, int verseID, int scope, WidgetRef ref) async {
  MskDBProvider mskDBProvider = MskDBProvider();
  final databasePath = await getDatabasesPath();
  final dbPath = join(databasePath, 'versei.db'); // Adjust the database name
  //print(dbPath);
  // Open the database
  final Database db = await databaseFactoryFfi.openDatabase(dbPath);
  //print(db);
  //contextFromDB = [];
  var startContext = verseID - scope;

  try {
    // Get verse ID from DB for a verse text
    int? IDVerse = 0;
    final List<Map<String, dynamic>> resultID = await db.query(
      'msk_bible_verses', // Table name
      columns: ['ID'], // Columns to retrieve
      where: 'content = ?', // WHERE clause
      whereArgs: [verseText], // Arguments for the WHERE clause
    );
    IDVerse = resultID.first['ID'] as int;
// Check if the result is not empty
    /*
    if (resultID.isNotEmpty) {
      // Extract the ID from the first row
      int IDVerse = resultID.first['ID'] as int;
      print('Retrieved ID: $IDVerse');
    } else {
      // Handle the case where no rows match the query
      print('No matching verse found for the given text.');
    }
*/
    //verseID = IDVerse;
    // use the verse ID to load Scripture
    print('Passed ID: $IDVerse');
    final List<Map<String, dynamic>> result = await db.query(
      'msk_bible_verses', // Table name
      columns: ['content'], // Columns to retrieve
      where: 'ID BETWEEN ? AND ?', // WHERE clause
      whereArgs: [
        IDVerse - scope,
        IDVerse + scope,
      ], // Arguments for the WHERE clause
    );
    print(result);
    print(result.length);
    // Check if a result was found
    if (result.isNotEmpty) {
      //print(result.first['content']);

      //contextFromDB.add(result.first['content']);
      contextFromDB = [];
      for (int i = 0; i < result.length; i++) {
        print(i);
        //print(result.length);
        //print(result[i]['content']);
        var content = result[i]['content'];
        contextFromDB.add(content.toString());
      }
      print("******CONTEXT***********");
      //print(startContext);
      //print(contextFromDB);
      print("******CONTEXT*****");
      clicks = clicks +
          1; //increases whenever the function is called, used for updating widget viac variable_monitor.dart
      print(clicks);
      //ref.read(variablemonitorProvider.notifier).state++; //reloading in loop when used
      return null; // Return the verse content
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


