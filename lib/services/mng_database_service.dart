// CONNECTION TO DATABASE
import 'dart:async';
// import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scriptus/const/constants.dart';
import 'package:sqflite/sqflite.dart';
// import 'dart:typed_data';
import 'package:flutter/services.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:scriptus/models/favorite.dart';
import 'package:scriptus/models/meeting.dart';
import 'package:tuple/tuple.dart';
// import 'package:scriptus/models/book.dart';
// import '../models/book_chapter.dart';
import '../models/place.dart';
import '../models/sermon.dart';
// import '../models/language.dart';
import '../models/bible.dart';
import '../models/bible_book.dart';
import '../models/bible_verse.dart';
import '../models/bible_chapter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../utils/constants.dart' as Constants;

class BibleDBProvider {
  static const _databaseMengeBibleName = 'mng-de.SQLite3';
  // static const _databaseMengeBibleName = 'MENG.SQLite3';
  // static const _databaseMengeBibleName = 'versei.sqlite';
  static const _databaseLocalName = 'scriptus.db';

  static final BibleDBProvider _db = BibleDBProvider._();
  factory BibleDBProvider() => _db;
  BibleDBProvider._();

  static Database? _database;

  _initDb() async {
    // print('_initDB');
    await _checkDB();
    WidgetsFlutterBinding.ensureInitialized();
    var databasesPath = await getDatabasesPath();
    print(databasesPath);
    var path = join(databasesPath, _databaseLocalName);
    // await deleteDatabase(path);
    // var exists = await databaseExists(path);

    Database? thedb; // open the database
    if (Platform.isWindows) {
      // sqfliteFfiInit();
      // thedb = await databaseFactoryFfi.openDatabase(path);
    } else {
      thedb = await openDatabase(path, readOnly: false);
    }
    return thedb;
  }

  Future<Database> get database async {
    //// print('get database');
    //// print(_database?.isOpen);
    //// print('get database @');
    if (_database != null) return _database!;
    //// print('get database NOT');
    // if _database is null we instantiate it
    _database = await _initDb();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // if (prefs.getString('appLanguage') != null &&
    //     prefs.getString('appLanguage').isNotEmpty) {
    //   appLanguage = prefs.getString('appLanguage');
    // }
    // if (prefs.getStringList('contentLanguages') != null &&
    //     prefs.getStringList('contentLanguages').isNotEmpty) {
    //   userLanguages = prefs.getStringList('contentLanguages');
    //   if (userLanguages.length < 1) userLanguages = languages;
    // }
    // userLanguages = userLanguages.map((l) => '\'' + l.toString() + '\'').toList();
    // _loadLangs();
    // // languageQuery = userLanguages.join(", ");
    return _database!;
  }

  void updateDatabase() async {
    // final database = await openDatabase('path_to_your_database');
    Database? thedb; // open the database
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _databaseLocalName);
    thedb = await openDatabase(path, readOnly: false);

    // add column book_number to verses table
    await thedb.execute('ALTER TABLE verses ADD COLUMN book_number INTEGER');
    // add string columng de_book_name to verses table
    await thedb.execute('ALTER TABLE verses ADD COLUMN de_book_name TEXT');

    // var gigi = gigiDeBookNames;

    List<int> bookNumbers = [
      10,
      20,
      30,
      40,
      50,
      60,
      70,
      80,
      90,
      100,
      110,
      120,
      130,
      140,
      150,
      160,
      190,
      220,
      230,
      240,
      250,
      260,
      290,
      300,
      310,
      330,
      340,
      350,
      360,
      370,
      380,
      390,
      400,
      410,
      420,
      430,
      440,
      450,
      460,
      470,
      480,
      490,
      500,
      510,
      520,
      530,
      540,
      550,
      560,
      570,
      580,
      590,
      600,
      610,
      620,
      630,
      640,
      650,
      660,
      670,
      680,
      690,
      700,
      710,
      720,
      730
    ];

    List<String> oldValues = [
      "Gen",
      "Ex",
      "Lev",
      "Num",
      "Deut",
      "Ios",
      "Jud",
      "Rut",
      "1 Sam",
      "2 Sam",
      "1 Împ",
      "2  Împ",
      "1 Cron",
      "2 Cron",
      "Ezra",
      "Neem",
      "Est",
      "Iov",
      "Ps",
      "Prov",
      "Ecl",
      "Cânt",
      "Is",
      "Ier",
      "Plâng",
      "Ezec",
      "Dan",
      "Osea",
      "Ioel",
      "Amos",
      "Obad",
      "Iona",
      "Mica",
      "Naum",
      "Hab",
      "Țef",
      "Hag",
      "Zah",
      "Mal",
      "Mat",
      "Mc",
      "Lc",
      "In",
      "Fapte",
      "Rom",
      "1 Cor",
      "2 Cor",
      "Gal",
      "Ef",
      "Fil",
      "Col",
      "1 Tes",
      "2 Tes",
      "1 Tim",
      "2 Tim",
      "Tit",
      "Flm",
      "Evr",
      "Iac",
      "1 Pet",
      "2 Pet",
      "1 In",
      "2 In",
      "3 In",
      "Iuda",
      "Ap (Des)"
    ];
    // List<String> newValues = ["1.Mose","2.Mose","3.Mose","4.Mose","5.Mose","Jos","Rich","Ruth","1Sam","2Sam","1.Kön","2.Kön","1.Chr","2.Chr","Esra","Neh","Est","Hiob","Ps","Spr","Pred","Hld","Jes","Jer","Klgl","Hes","Dan","Hos","Joel","Am","Obd","Jona","Mich","Nah","Hab","Zeph","Hag","Sach","Mal","Mt","Mk","Lk","Joh","Apg","Röm","1.Kor","2.Kor","Gal","Eph","Phil","Kol","1.Thess","2.Thess","1.Tim","2.Tim","Tit","Phlm","Heb","Jak","1.Petr","2.Petr","1.Joh","2.Joh","3.Joh","Jud","Offb"];
    List<String> newValues = [
      "1Mo",
      "2Mo",
      "3Mo",
      "4Mo",
      "5Mo",
      "Jos",
      "Ri",
      "Rt",
      "1Sam",
      "2Sam",
      "1Kö",
      "2Kö",
      "1Chr",
      "2Chr",
      "Esr",
      "Neh",
      "Est",
      "Hi",
      "Ps",
      "Spr",
      "Pred",
      "Hl",
      "Jes",
      "Jer",
      "Kla",
      "Hes",
      "Dan",
      "Hos",
      "Joe",
      "Am",
      "Ob",
      "Jon",
      "Mi",
      "Nah",
      "Hab",
      "Zeph",
      "Hag",
      "Sach",
      "Mal",
      "Mt",
      "Mk",
      "Lk",
      "Joh",
      "Apg",
      "Röm",
      "1Kor ",
      "2Kor ",
      "Gal ",
      "Eph ",
      "Phil ",
      "Kol ",
      "1Th",
      "2Th",
      "1Tim ",
      "2Tim ",
      "Tit ",
      "Phlm ",
      "Hebr ",
      "Jak ",
      "1Pt",
      "2Pt",
      "1Jo",
      "2Jo",
      "3Jo",
      "Jud",
      "Offb"
    ];
    var converter = BookNameConverter();

    // print(converter.convertDeToGigiRo("1Mo")); // Should print "Gen"
    // print(converter.convertDeToGigiDe("1Mo")); // Should print "1.Mose"
    // print(converter.convertGigiRoToGigiDe("Gen")); // Should print "1.Mose"

    for (int i = 0; i < oldValues.length; i++) {
      String oldValue = oldValues[i];
      String newValue = newValues[i];
      String gigi = converter.convertDeToGigiDe(newValue);
      // print(bookNumbers[i]);
      // print(gigi);

      await thedb.update(
        'books',
        {'short_name': newValue},
        where: 'short_name = ?',
        whereArgs: [oldValue],
      );

      // update verses table with book numbers from bookNumbers
      await thedb.update(
        'verses',
        {'book_number': bookNumbers[i], 'de_book_name': newValues[i]},
        where: 'book = ?',
        whereArgs: [gigi],
      );
    }

    // await thedb.close();
  }

  _checkDB() async {
    // print('checkDB');
    WidgetsFlutterBinding.ensureInitialized();
    String databasesPath = '';
    if (Platform.isWindows) {
      // sqfliteFfiInit();
      // databasesPath = await databaseFactoryFfi.getDatabasesPath();
    } else {
      databasesPath = await getDatabasesPath();
    }

    // var p = "/Users/miro/Projects/flutter/misiask/assets/database/all.sqlite";
    // var exists2 = await io.File(p).exists();
    //// print('exists2');
    //// print(exists2);

    // final stat = FileStat.statSync(p);
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String currentDbString = prefs.getString('currentDbDate');
    //// print(stat);
    //// print(prefs);
    //// print(currentDbString);
    // if (currentDbString == null) {
    //   prefs.setString('currentDbDate', stat.changed.toString());
    // } else {
    //   final DateTime currentDbDate = DateTime.parse(currentDbString);
    //   final DateTime fileDateTime = stat.modified;
    //  // print(currentDbDate);
    //  // print(fileDateTime);
    //   if (fileDateTime.isAfter(currentDbDate)) {
    //     prefs.setString('currentDbDate', stat.modified.toString());
    //   }
    // }
    var path = join(databasesPath, _databaseLocalName);
    // await deleteDatabase(path);
    var exists = await databaseExists(path);
    // print("db start - DB exists? = $exists");
    //// print(exists);
    //// print(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new DB copy from asset");
      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {
        print('error creating directory');
      }

      // Copy from asset
      ByteData data = await rootBundle
          .load(join("assets", "db", "bible", _databaseMengeBibleName));
      // print('data.lengthInBytes');
      // print(data.lengthInBytes);
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // print('bytes.length');
      // print(bytes.length);

      // var exists = await databaseExists(path);
      // print('exists 2');
      // print(exists);

      // Write and flush the bytes written
      try {
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (e) {
        // print(e);
      }
      updateDatabase();
    } else {
      print("Using existing database");
    }
    // var thedb = await openDatabase(
    //   path,
    //   readOnly: false,
    // );
    // var checkVersion = await thedb.rawQuery(
    //     "SELECT name FROM sqlite_master WHERE type='table' AND name='artworks'");
    // print('checkVersion.length is: ' + checkVersion.length.toString());
    //// print(checkVersion.length);
    // if (checkVersion.length > 0) {
    // } else {
    //   await deleteDatabase(path);
    // }
    // get app docs dir
    // var myDir = await getApplicationDocumentsDirectory();
    //// print(myDir.path);
    // var data = await rootBundle.load('/animations/intro.flr');
    //// print(data);
    // var p = "/Users/miro/Projects/flutter/misiask/assets/database/scriptus.sqlite";
    // var exists2 = await io.File(p).exists();
    //// print('exists2');
    //// print(exists2);
  }

  // _resetDb() async {
  //   String databasesPath = await getDatabasesPath();
  //   String path = join(databasesPath, _databaseLocalName);
  //   await deleteDatabase(path);
  // }

  Future<void> insertPlace(Place place) async {
    // print('insertPlace');
    // print(place);
    final db = await database;
    await db.insert(
      'places',
      place.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePlace(Place place) async {
    print('updatePlace');
    print(place);
    final db = await database;
    await db.rawUpdate('UPDATE places SET timePosition = ? WHERE id = ?',
        [place.timePosition, place.id]);
    // .update('places', place.toMap(), where: "id=?", whereArgs: []
    // conflictAlgorithm: ConflictAlgorithm.replace,
    // );
  }

  Future<void> setMeetingScripturesDone(int mId, int value) async {
    // print("DB setMeetingScripturesDone ${mId}");
    final db = await database;
    int c = await db.update('msk_meetings', {'scriptures_done': value},
        where: "id=?", whereArgs: [mId]);
    // print(c);
  }

  Future<void> deletePlace(Place place) async {
    // print("DB delete ${place.id}");
    final db = await database;
    int c = await db.delete('places', where: "id=?", whereArgs: [place.id]);
    // print(c);
  }

  Future<Meeting> getMeetingFromSermon(int id) async {
    // print("getMeetingFromSermon $id");
    //// print(id);
    final db = await database;
    String q = '''select m.*, mp.city
                  from msk_meetings m 
                      left join msk_meeting_places mp on m.meeting_place_id = mp.id 
                  where m.id = ? ''';

    var res = await db.rawQuery(q, [id]);
    // var res = await db.query('msk_meetings', where: 'id=?', whereArgs: [id],);
    // return res.isNotEmpty ? Sermon.fromMap(res.first) : null;
    try {
      return Meeting.fromMap(res.first);
      // res.isNotEmpty ?
    } catch (e) {
      // print(e);
      // return null;
      rethrow;
    }
  }

  Future<Sermon> getSermon(int id) async {
    // print("getSermon $id");
    //// print(id);
    final db = await database;
    var res = await db.query('msk_sermons', where: 'id=?', whereArgs: [id]);
    // return res.isNotEmpty ? Sermon.fromMap(res.first) : null;
    try {
      return Sermon.fromMap(res.first);
      // res.isNotEmpty ?
    } catch (e) {
      // print(e);
      // return null;
      rethrow;
    }
  }

  Future<List<Place>> getSermonPlaces(meetingId) async {
    // print("DB getSermonPlaces $meetingId");
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query('places',
        where: "meetingId = ?",
        whereArgs: [meetingId],
        orderBy: "timePosition asc");

    List<Place> l =
        List.generate(maps.length, (index) => Place.fromMap(maps[index]));
    //// print(l.first.verseText);
    return l;
  }

  Future<List<Sermon>> getSermons() async {
    // print('service - getSermons');

    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      select s.*, m.broadcastedAt, m.scriptures_done
      from msk_sermons s 
          left join msk_meetings m on s.meeting_id = m.id 
      where s.file_name is not NULL 
          AND s.file_name <> '' 
          AND s.language IN('sk','cz','en', 'de') 
      order by m.broadcastedAt desc, s.id desc''');

    List<Sermon> l =
        List.generate(maps.length, (index) => Sermon.fromMap(maps[index]));
    //// print(l.length);
    return l;
  }

  Future<void> createPlacesTable() async {}

  Future<List<Bible>> getBibles() async {
    // print('DB - getBibles');
    final db = await database;
    var res = await db.query('msk_bibles');
    //// print(res);
    List<Bible> list =
        res.isNotEmpty ? res.map((c) => Bible.fromMap(c)).toList() : [];
    // List<Bible> l = [
    //   Bible(id: 1, language: 'en', title: 'KJV'),
    //   Bible(id: 2, language: 'sk', title: 'ROH')
    // ];
    return list;
  }

  Future<List<BibleBook>> getBibleBooks({int bibleId = 1}) async {
    // print("DB - getBibleBooks $bibleId");
    //// print(bibleId);
    final db = await database;
    var res = await db.query(
      'msk_bible_books',
      where: 'bible_id=?',
      whereArgs: [bibleId],
      orderBy: 'position',
      // columns: [
      //   'ID',
      //   'title',
      //   'bible_id',
      //   'title',
      //   'abb',
      //   'testament',
      //   'position',
      // ]
    );
    //// print(res[1]['color']);
    List<BibleBook> list =
        res.isNotEmpty ? res.map((c) => BibleBook.fromMap(c)).toList() : [];
    //// print(list.length);
    return list;
  }

  Future<List<BibleChapter>> getBibleChapters({int bookId = 1}) async {
    // print("DB - getBibleChapters $bookId");
    //// print(bookId);
    final db = await database;
    var res = await db.query('msk_bible_verses',
        where: 'book_id=?',
        whereArgs: [bookId],
        orderBy: 'bible_chapter',
        groupBy: 'bible_chapter',
        columns: ['ID', 'bible_chapter', 'bible_id', 'book_id']);
    //// print(res.length);
    List<BibleChapter> list =
        res.isNotEmpty ? res.map((c) => BibleChapter.fromMap(c)).toList() : [];
    //// print('getBibleChapters');
    //// print(list.length);
    return list;
  }

  Future<List<BibleVerse>> getBibleChapterVerses(
      {int chapterId = 1, int bibleId = 1, int bookId = 1}) async {
    //// print('chapterId');
    //// print(chapterId);
    //// print('bookId');
    //// print(bookId);
    //// print('bibleId');
    //// print(bibleId);
    // print("DB - getBibleChapterVerses $chapterId-$bibleId-$bookId");
    //// print(chapterId);
    //// print(bibleId);
    //// print(bookId);

    final db = await database;
    var res = await db.query(
      'msk_bible_verses',
      where: 'bible_id = ? and book_id=? and bible_chapter=?',
      whereArgs: [bibleId, bookId, chapterId],
      orderBy: 'verse',
    );
    // columns: ['ID', 'verse', 'content']);
    // BibleChapter chapter = res.isNotEmpty ? BibleChapter.fromMap(res.first)  : null;
    List<BibleVerse> list =
        res.isNotEmpty ? res.map((c) => BibleVerse.fromMap(c)).toList() : [];
    //// print('DB list');
    // print(list.length);
    return list;
  }

  Future<List<BibleVerse>> searchBibleChapterVerses(
      String v, bool asEntered, int bibleId) async {
    //// print(bibleId);
    // print("DB - searchBibleChapterVerses - $v");
    //// print(chapterId);
    //// print(bibleId);
    //// print(bookId);

    final db = await database;
    String where = '';

    if (asEntered) {
      where = "$where AND content like '%$v%' ";
    } else {
      List<String> strarray = v.split(" ");

      if (strarray.length == 1) {
        where = " AND content like '%$v%' ";
      } else {
        for (String s in strarray) {
          where = "$where AND content like '%$s%' ";
        }
      }
    }

    var res = await db.rawQuery(
        "SELECT v.*, b.abb from msk_bible_verses v LEFT JOIN msk_bible_books b ON  v.book_id = b.id where v.bible_id = $bibleId $where ORDER BY id ASC");
    //  SELECT v.*, b.abb from msk_bible_verses v, msk_bible_books b where v.bible_id = 2 and content like '%$v%' ORDER BY id ASC");

    // var res = await db.query(
    //   'msk_bible_verses',
    //   where: "bible_id = 2 and content like '%?%'",
    //   whereArgs: [v],
    //   orderBy: 'book_id, verse',
    // );
    // columns: ['ID', 'verse', 'content']);
    // BibleChapter chapter = res.isNotEmpty ? BibleChapter.fromMap(res.first)  : null;
    List<BibleVerse> list =
        res.isNotEmpty ? res.map((c) => BibleVerse.fromMap(c)).toList() : [];
    //// print('DB list');
    //// print(list.first.content);
    // print(list.length);
    return list;
  }

  Future<List<BibleVerse>> getBibleVersesFromIds(List<int> l) async {
    print("MNG DB - getBibleVersesFromIds $l");

    var ls = l.join(',');
    // print(ls);
    final db = await database;
    String query =
        'select * from msk_bible_verses where ID IN($ls) order by verse';
    // print(query);
    var res = await db.rawQuery(query);
    // columns: ['ID', 'verse', 'content']);
    // BibleChapter chapter = res.isNotEmpty ? BibleChapter.fromMap(res.first)  : null;
    List<BibleVerse> list =
        res.isNotEmpty ? res.map((c) => BibleVerse.fromMap(c)).toList() : [];
    //// print('DB list');
    // print(list.length);
    return list;
  }

  String removeTags(String input) {
    print('removeTags');
    print(input);

    String result = input;

    // Remove all text enclosed in <n></n> tags
    result = result.replaceAll(RegExp(r'<n>.*?</n>'), ' ');

    // Remove all remaining tags
    result = result.replaceAll(RegExp(r'<.*?>'), ' ');

    // Remove all instances of the # symbol
    result = result.replaceAll('#', '');

    // Replace all instances of double spaces with a single space
    // The '+' in the regular expression means 'one or more', so this will also handle cases where there are more than two spaces in a row
    result = result.replaceAll(RegExp(' +'), ' ');

    // Remove spaces before periods and commas
    result = result.replaceAll(' .', '.');
    result = result.replaceAll(' ,', ',');

    // Remove spaces at the beginning and end of the string
    result = result.trim();
    print(result);

    return result;
  }

  /// loads bible verse from bible reference stored in Tuple3 argument
  Future<BibleVerse?> getDEBibleVerseFromAPIReference(Tuple3 reference) async {
    print("MNG DB - getBibleVerseFromReference $reference");
    final db = await database;
    var b = reference.item1.toString().trim();
    var c = reference.item2;
    var v = reference.item3;
    // print(b);
    // var converter = BookNameConverter();
    // String bookDe = converter.convertDeToGigiDe(b);
    // old query for myBible app db
    // String query =
    //     'SELECT v.*, TRIM(b.short_name) short_name from verses v LEFT JOIN books b ON b.book_number = v.book_number where v.verse = $v and v.chapter=$c and (TRIM(b.short_name) = "$b" OR TRIM(b.long_name) = "$b") LIMIT 1';

    // get verse text from scriptus.db
    String query = '''SELECT v.*, TRIM(b.short_name) short_name 
           FROM verses v 
           LEFT JOIN books b ON b.short_name = v.de_book_name 
           WHERE v.verse = $v and v.chapter=$c and (TRIM(b.short_name) = "$b" OR TRIM(b.long_name) = "$b") 
           LIMIT 1''';

    print(query);
    var res = await db.rawQuery(query);
    // columns: ['ID', 'verse', 'content']);
    // BibleChapter chapter = res.isNotEmpty ? BibleChapter.fromMap(res.first)  : null;
    if (res.isEmpty) {
      return null;
    } else {
      BibleVerse verse =
          BibleVerse.fromMap(res.isNotEmpty ? res.first : {'content': ''});
      BibleVerse verse2 =
          verse.copyWith(content: removeTags(verse.content ?? ''));
      //// print('DB list');
      // print(verse2);
      return verse2;
    }
  }

  Future<List<BibleVerse>> getBibleChapterVerseRange(int start, int end) async {
    //// print('chapterId');
    //// print(chapterId);
    //// print('bookId');
    //// print(bookId);
    //// print('bibleId');
    //// print(bibleId);
    // print("DB - getBibleChapterVerseRange $start-$end");

    final db = await database;
    var res = await db.query(
      'msk_bible_verses',
      where: 'ID >= ? and ID <=?',
      whereArgs: [start, end],
      orderBy: 'verse',
    );
    // columns: ['ID', 'verse', 'content']);
    // BibleChapter chapter = res.isNotEmpty ? BibleChapter.fromMap(res.first)  : null;
    List<BibleVerse> list =
        res.isNotEmpty ? res.map((c) => BibleVerse.fromMap(c)).toList() : [];
    //// print('DB list');
    // print(list.length);
    return list;
  }

  Future<Bible> getBible(int id) async {
    // print("DB - getBible $id");
    //// print(id);
    final db = await database;
    var res = await db.query("msk_bibles", where: "id = ?", whereArgs: [id]);
    if (res.isNotEmpty) {
      var resSub = await db.query("msk_bible_books",
          where: "bible_id = ?", whereArgs: [res.first['ID']]);
      //// print(res.first);

      try {
        Bible bible = Bible.fromMap(res.first);

        try {
          List<BibleBook> books = resSub.isNotEmpty
              ? resSub.map((c) => BibleBook.fromMap(c)).toList()
              : [];
          bible.bibleBooks = books;
          return bible;
          // res.isNotEmpty ?
        } catch (e) {
          // print(e);
          // return null;
          rethrow;
        }
      } catch (e) {
        // print(e);
        rethrow;
      }
    } else {
      throw (Error);
    }
  }

  Future<BibleChapter> getBibleBookChapter(int id) async {
    // print("DB - getBibleBookChapter $id");
    //// print(id);
    final db = await database;
    var res =
        await db.query("msk_bible_verses", where: "id = ?", whereArgs: [id]);
    //// print(res);
    //// print(resSub);
    if (res.isNotEmpty) {
      try {
        BibleChapter bc = BibleChapter.fromMap(res.first);
        // var resSub = await db.query("msk_bible_verses",
        //     where: "book_id = ? and bible_chapter=1", whereArgs: [id]);
        // // res.isNotEmpty ?
        // List<BibleVerse> verses = resSub.isNotEmpty
        //     ? resSub.map((c) => BibleVerse.fromMap(c)).toList()
        //     : [];
        // book.bibleVerses = verses;
        return bc;
      } catch (e) {
        // print(e);
        // return null;
        rethrow;
      }
    } else {
      throw (Error);
    }
  }

  Future<BibleBook> getBibleBook(int id) async {
    // print("DB - getBibleBook $id");

    final db = await database;
    var res =
        await db.query("msk_bible_books", where: "id = ?", whereArgs: [id]);
    //// print(res);
    //// print(resSub);
    if (res.isNotEmpty) {
      try {
        BibleBook book = BibleBook.fromMap(res.first);
        var resSub = await db.query("msk_bible_verses",
            where: "book_id = ? and bible_chapter=1",
            whereArgs: [id],
            orderBy: 'id');
        // res.isNotEmpty ?
        List<BibleVerse> verses = resSub.isNotEmpty
            ? resSub.map((c) => BibleVerse.fromMap(c)).toList()
            : [];
        book.bibleVerses = verses;
        return book;
      } catch (e) {
        // print(e);
        // return null;
        rethrow;
      }
    } else {
      throw (Error);
    }
  }
}
