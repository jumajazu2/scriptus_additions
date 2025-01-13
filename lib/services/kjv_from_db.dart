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

Future<String?> contextByID(String verseText, int scope, WidgetRef ref) async {
  MskDBProvider mskDBProvider = MskDBProvider();
  final databasePath = await getDatabasesPath();
  final dbPath = join(databasePath, 'versei.db'); // Adjust the database name

  // Open the database
  final Database db = await databaseFactoryFfi.openDatabase(dbPath);

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
      columns: [
        'content',
        'book_id',
        'bible_chapter',
        'verse'
      ], // Columns to retrieve
      where: 'ID BETWEEN ? AND ?', // WHERE clause
      whereArgs: [
        IDVerse - scope,
        IDVerse + scope,
      ], // Arguments for the WHERE clause
    );
    //print(result);
    //print(result.length);
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
        var bookDB = result[i]['book_id'];
        bookDB = bookDB - 1;
        Map<String, String> bookInfo = getBookInfo(
            bookDB, 1); //1 for English/2 for German + add auto recognition

        String abbr = bookInfo["abbr"] ?? "N/A"; // Default value if null
        var chapterDB = result[i]['bible_chapter'];
        var verseDB = result[i]['verse'];

        var preparedContent = (abbr +
            " " +
            chapterDB.toString() +
            ":" +
            verseDB.toString() +
            " " +
            content.toString());

        contextFromDB.add(preparedContent);
      }
      print("******CONTEXT***********");
      //print(startContext);
      //print(contextFromDB);
      print("******CONTEXT*****");

      ref.read(variablemonitorProvider.notifier).state++;
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

Map<String, String> getBookInfo(int bookID, int languageCode) {
  // Validate the language code to ensure it is 1 (English) or 2 (German)
  if (languageCode != 1 && languageCode != 2) {
    throw ArgumentError(
        "Invalid language code. Please use 1 for English or 2 for German.");
  }

  // Lists of Bible books for English and German
  List<Map<String, String>> booksEnglish = [
    {"abbr": "Gen", "name": "Genesis"},
    {"abbr": "Exod", "name": "Exodus"},
    {"abbr": "Lev", "name": "Leviticus"},
    {"abbr": "Num", "name": "Numbers"},
    {"abbr": "Deut", "name": "Deuteronomy"},
    {"abbr": "Josh", "name": "Joshua"},
    {"abbr": "Judg", "name": "Judges"},
    {"abbr": "Ruth", "name": "Ruth"},
    {"abbr": "1Sam", "name": "1 Samuel"},
    {"abbr": "2Sam", "name": "2 Samuel"},
    {"abbr": "1Kgs", "name": "1 Kings"},
    {"abbr": "2Kgs", "name": "2 Kings"},
    {"abbr": "1Chr", "name": "1 Chronicles"},
    {"abbr": "2Chr", "name": "2 Chronicles"},
    {"abbr": "Ezra", "name": "Ezra"},
    {"abbr": "Neh", "name": "Nehemiah"},
    {"abbr": "Esth", "name": "Esther"},
    {"abbr": "Job", "name": "Job"},
    {"abbr": "Ps", "name": "Psalms"},
    {"abbr": "Prov", "name": "Proverbs"},
    {"abbr": "Eccl", "name": "Ecclesiastes"},
    {"abbr": "Song", "name": "Song of Solomon"},
    {"abbr": "Isa", "name": "Isaiah"},
    {"abbr": "Jer", "name": "Jeremiah"},
    {"abbr": "Lam", "name": "Lamentations"},
    {"abbr": "Ezek", "name": "Ezekiel"},
    {"abbr": "Dan", "name": "Daniel"},
    {"abbr": "Hos", "name": "Hosea"},
    {"abbr": "Joel", "name": "Joel"},
    {"abbr": "Amos", "name": "Amos"},
    {"abbr": "Obad", "name": "Obadiah"},
    {"abbr": "Jonah", "name": "Jonah"},
    {"abbr": "Mic", "name": "Micah"},
    {"abbr": "Nah", "name": "Nahum"},
    {"abbr": "Hab", "name": "Habakkuk"},
    {"abbr": "Zeph", "name": "Zephaniah"},
    {"abbr": "Hag", "name": "Haggai"},
    {"abbr": "Zech", "name": "Zechariah"},
    {"abbr": "Mal", "name": "Malachi"},
    {"abbr": "Matt", "name": "Matthew"},
    {"abbr": "Mark", "name": "Mark"},
    {"abbr": "Luke", "name": "Luke"},
    {"abbr": "John", "name": "John"},
    {"abbr": "Acts", "name": "Acts"},
    {"abbr": "Rom", "name": "Romans"},
    {"abbr": "1Cor", "name": "1 Corinthians"},
    {"abbr": "2Cor", "name": "2 Corinthians"},
    {"abbr": "Gal", "name": "Galatians"},
    {"abbr": "Eph", "name": "Ephesians"},
    {"abbr": "Phil", "name": "Philippians"},
    {"abbr": "Col", "name": "Colossians"},
    {"abbr": "1Thess", "name": "1 Thessalonians"},
    {"abbr": "2Thess", "name": "2 Thessalonians"},
    {"abbr": "1Tim", "name": "1 Timothy"},
    {"abbr": "2Tim", "name": "2 Timothy"},
    {"abbr": "Titus", "name": "Titus"},
    {"abbr": "Philem", "name": "Philemon"},
    {"abbr": "Heb", "name": "Hebrews"},
    {"abbr": "Jas", "name": "James"},
    {"abbr": "1Pet", "name": "1 Peter"},
    {"abbr": "2Pet", "name": "2 Peter"},
    {"abbr": "1John", "name": "1 John"},
    {"abbr": "2John", "name": "2 John"},
    {"abbr": "3John", "name": "3 John"},
    {"abbr": "Jude", "name": "Jude"},
    {"abbr": "Rev", "name": "Revelation"}
  ];

  List<Map<String, String>> booksGerman = [
    {"abbr": "1Mo", "name": "1. Mose"},
    {"abbr": "2Mo", "name": "2. Mose"},
    {"abbr": "3Mo", "name": "3. Mose"},
    {"abbr": "4Mo", "name": "4. Mose"},
    {"abbr": "5Mo", "name": "5. Mose"},
    {"abbr": "Jos", "name": "Josua"},
    {"abbr": "Ri", "name": "Richter"},
    {"abbr": "Rut", "name": "Ruth"},
    {"abbr": "1Sam", "name": "1. Samuel"},
    {"abbr": "2Sam", "name": "2. Samuel"},
    {"abbr": "1Kön", "name": "1. Könige"},
    {"abbr": "2Kön", "name": "2. Könige"},
    {"abbr": "1Chr", "name": "1. Chronik"},
    {"abbr": "2Chr", "name": "2. Chronik"},
    {"abbr": "Esra", "name": "Esra"},
    {"abbr": "Neh", "name": "Nehemia"},
    {"abbr": "Est", "name": "Ester"},
    {"abbr": "Hiob", "name": "Hiob"},
    {"abbr": "Ps", "name": "Psalmen"},
    {"abbr": "Spr", "name": "Sprüche"},
    {"abbr": "Pred", "name": "Prediger"},
    {"abbr": "Hohel", "name": "Hohelied"},
    {"abbr": "Jes", "name": "Jesaja"},
    {"abbr": "Jer", "name": "Jeremia"},
    {"abbr": "Klgl", "name": "Klagelieder"},
    {"abbr": "Hes", "name": "Hesekiel"},
    {"abbr": "Dan", "name": "Daniel"},
    {"abbr": "Hos", "name": "Hosea"},
    {"abbr": "Joel", "name": "Joel"},
    {"abbr": "Amos", "name": "Amos"},
    {"abbr": "Obad", "name": "Obadja"},
    {"abbr": "Jona", "name": "Jona"},
    {"abbr": "Mi", "name": "Micha"},
    {"abbr": "Nah", "name": "Nahum"},
    {"abbr": "Hab", "name": "Habakuk"},
    {"abbr": "Zeph", "name": "Zefanja"},
    {"abbr": "Hag", "name": "Haggai"},
    {"abbr": "Sach", "name": "Sacharja"},
    {"abbr": "Mal", "name": "Maleachi"},
    {"abbr": "Mt", "name": "Matthäus"},
    {"abbr": "Mk", "name": "Markus"},
    {"abbr": "Lk", "name": "Lukas"},
    {"abbr": "Joh", "name": "Johannes"},
    {"abbr": "Apg", "name": "Apostelgeschichte"},
    {"abbr": "Rö", "name": "Römer"},
    {"abbr": "1Kor", "name": "1. Korinther"},
    {"abbr": "2Kor", "name": "2. Korinther"},
    {"abbr": "Gal", "name": "Galater"},
    {"abbr": "Eph", "name": "Epheser"},
    {"abbr": "Phil", "name": "Philipper"},
    {"abbr": "Kol", "name": "Kolosser"},
    {"abbr": "1Thess", "name": "1. Thessalonicher"},
    {"abbr": "2Thess", "name": "2. Thessalonicher"},
    {"abbr": "1Tim", "name": "1. Timotheus"},
    {"abbr": "2Tim", "name": "2. Timotheus"},
    {"abbr": "Tit", "name": "Titus"},
    {"abbr": "Philem", "name": "Philemon"},
    {"abbr": "Heb", "name": "Hebräer"},
    {"abbr": "Jak", "name": "Jakobus"},
    {"abbr": "1Petr", "name": "1. Petrus"},
    {"abbr": "2Petr", "name": "2. Petrus"},
    {"abbr": "1Joh", "name": "1. Johannes"},
    {"abbr": "2Joh", "name": "2. Johannes"},
    {"abbr": "3Joh", "name": "3. Johannes"},
    {"abbr": "Juda", "name": "Judas"},
    {"abbr": "Offb", "name": "Offenbarung"}
  ];

  // Fetch the appropriate list based on the language code
  var books = languageCode == 2 ? booksGerman : booksEnglish;

  // Ensure bookID is valid and within bounds of the list
  if (bookID < 0 || bookID >= books.length) {
    throw ArgumentError("Invalid book ID.");
  }

  // Return the abbreviation and name for the specified book ID
  return {
    "abbr": books[bookID]["abbr"] ?? "",
    "name": books[bookID]["name"] ?? ""
  };
}
