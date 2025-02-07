import 'package:path/path.dart';
import 'package:scriptus/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/services/msk_db_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:scriptus/providers/variable_monitor.dart';

//loads Bible content for working language
//from DB to Map for fuzzy search,
//only once at startup, then search can be done where only synchronous operation is possible

Future loadFromDB() async {
  final databasePath = await getDatabasesPath();
  final dbPath =
      join(databasePath, 'versei_mengeAdd.db'); // Adjust the database name
  //print(dbPath);
  // Open the database
  final Database db = await databaseFactoryFfi.openDatabase(dbPath);
  //print(db);

//

  var startID;
  var endID;
  try {
    // Query the verse by bible, book, chapter, verse
    if (workingLanguage == "en") {
      startID = 0;
      endID = 31102;
      print(workingLanguage);
    }
    if (workingLanguage == "sk") {
      startID = 31103;
      endID = 62279;
      print(workingLanguage);
    }
    if (workingLanguage == "de") {
      startID = 124548;
      endID = 155717;
      print(workingLanguage);
    }
    final List<Map<String, dynamic>> searchScopeDB1 = await db.query(
      'msk_bible_verses', // Table name
      columns: [
        'content',
        'book_id',
        'bible_chapter',
        'verse'
      ], // Columns to retrieve
      where: 'ID BETWEEN ? AND ?',
      whereArgs: [
        startID,
        endID,
      ], // Arguments for the WHERE clause
    );
    //print(searchScopeDB);
    print("DB Search Scope loaded to searchScopeDB with lenght:");
    print(searchScopeDB1.length);
    print(searchScopeDB1.sublist(1, 20));
    searchScopeDB = searchScopeDB1;
    return searchScopeDB;
  } finally {
    print("DB Search Scope loaded to searchScopeDB with lenght:");
    print(searchScopeDB?.length);
    //print(searchScopeDB);
    return searchScopeDB;
  }
}
