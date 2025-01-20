import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //jumajazu2 added for clipboard operations
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/home_page.dart';
import 'package:scriptus/models/transcript_segment.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/providers/variable_monitor.dart';
import 'package:scriptus/services/kjv_from_db.dart';
import 'dart:convert';
import 'dart:io';
import 'package:scriptus/services/msk_db_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//Function performs fuzzy search in KJV.json and returns verses with match score above 75%

List<String> kjvFuzzySearch(
    String kjvquery, String language, WidgetRef ref, tec) {
  //final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
  List<String> searchReturn = []; // Initialize results
  print(language);
  print("selection passed to kjvFuzzySearch function:");
  print(kjvquery);

  clicks = clicks +
      1; //increases whenever the function is called, used for updating widget via variable_monitor.dart

  ref.read(variablemonitorProvider.notifier).state++;

  if (data.isEmpty) {
    String jsonString = File(
            'kjv.json') //C:\\Users\\Juraj\\scriptus2\\scriptus\\lib\\services\\
        .readAsStringSync();
    data = json.decode(jsonString);
    print("KJV json loaded once when empty");
  } else {
    print("KJV json already has content, loading skipped");
  }

//performing search

// Function to return the chapter count for a specific book
  int bookChapters(int bookNo) {
    int bookIndex = bookNo - 1;
    return data["books"][bookIndex]["chapters"].length;
  }

// Function to return the verse count for a specific chapter in a book
  int chapterVerses(int bookNo, int chapterNo) {
    int bookIndex = bookNo - 1;
    int chapterIndex = chapterNo - 1;
    return data["books"][bookIndex]["chapters"][chapterIndex]["verses"].length;
  }

// Function to get a specific verse from the Bible
  String getVerse(int bookNo, int chapterNo, int verseNo) {
    int bookIndex = bookNo - 1;
    int chapterIndex = chapterNo - 1;
    int verseIndex = verseNo - 1;

    return data["books"][bookIndex]["chapters"][chapterIndex]["verses"]
        [verseIndex]["text"];
  }

// Function to get a reference (Book Chapter:Verse) for specific verse from the Bible
  String getReference(int bookNo, int chapterNo, int verseNo) {
    int bookIndex = bookNo - 1;
    int chapterIndex = chapterNo - 1;
    int verseIndex = verseNo - 1;

    return data["books"][bookIndex]["chapters"][chapterIndex]["verses"]
        [verseIndex]["name"];
  }

// Clean the input query string (remove punctuation, make uppercase)
  List<String> cleanList(String queryString) {
    queryString = queryString.toUpperCase(); // Convert to uppercase
    String cleanedString = queryString.replaceAll(
        RegExp(r'[.,;?!"\-\!]'), ''); // Remove punctuation
    List<String> queryList = cleanedString.split(' ');
    queryList.removeWhere(
        (word) => word == "THE" || word == "A" || word == "#KJVFS#");
    return queryList;
  }

// Compare the query string with the base string
  double compare(String queryString, String baseString) {
    List<String> queryList = cleanList(queryString);
    List<String> baseList = cleanList(baseString);

    int totalFound = 0;
    for (var word in queryList) {
      if (baseList.contains(word)) {
        totalFound++;
      }
    }

    return queryList.isEmpty ? 0.0 : totalFound / queryList.length;
  }

// Function to scan all the Bible books for a match
  List<String> scanAll(String queryInput) {
    int bibleBooks = 66; // Constant for the number of books in the Bible
    List<String> resultsVerses = [];

    for (int indexBook = 1; indexBook <= bibleBooks; indexBook++) {
      for (int indexChapter = 1;
          indexChapter <= bookChapters(indexBook);
          indexChapter++) {
        for (int indexVerse = 1;
            indexVerse <= chapterVerses(indexBook, indexChapter);
            indexVerse++) {
          String baseVerse = getVerse(indexBook, indexChapter, indexVerse);
          String baseReference =
              getReference(indexBook, indexChapter, indexVerse);
          double score = compare(queryInput, baseVerse);

          if (score > 0.75) {
            resultsVerses.add(baseReference);
            resultsVerses.add(baseVerse);
            resultsVerses.add(((score * 100).toStringAsFixed(0)) + " %");
          }
        }
      }
    }

    return resultsVerses;
  }

//returning results
  searchReturn = scanAll(kjvquery);
  //fuzzyBibleSearch(kjvquery, language, ref, tec);
  print("searchReturn: $searchReturn");
  if (searchReturn.isEmpty) {
    return ["No results found"];
  } else {
    return searchReturn;
  }
}

Future<String?> FuzzyBibleSearch(
    String query, String language, WidgetRef ref, tec) async {
  //final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
  List<String> searchReturn = []; // Initialize results
  print("string in $language passed to fuzzyBibleSearch DB function: $query");

  //clicks = clicks +
  //    1; //increases whenever the function is called, used for updating widget via variable_monitor.dart

  ref.read(variablemonitorProvider.notifier).state++;

//DB init
  MskDBProvider mskDBProvider = MskDBProvider();
  final databasePath = await getDatabasesPath();
  final dbPath =
      join(databasePath, 'versei_mengeAdd.db'); // Adjust the database name
  //print(dbPath);
  // Open the database
  final Database db = await databaseFactoryFfi.openDatabase(dbPath);
  //print(db);

//
  List<String> queryWords = cleanList(
      query); //turns the query string into a list of uppercase words, special characters removed
  List<String> searchWords;
  print("Querywords: $queryWords");
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
      endID = 62274;
      print(workingLanguage);
    }
    if (workingLanguage == "de") {
      startID = 124548;
      endID = 155717;
      print(workingLanguage);
    }
    final List<Map<String, dynamic>> resultScope = await db.query(
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

    // Check if a result was found
    if (resultScope.isNotEmpty) {
      //print(result.first['content']);
      // fromAPItoKJV.add("$bookName $chapterNumber:$verseNumber");
      // fromAPItoKJV.add(result.first['content']);
      print("*******XXX**********");
      print(resultScope[1]['content']);
      print(resultScope[1]['book_id']);
      var book = getBookInfo(resultScope[1]['book_id'], workingLanguage);
      var abbr = book["abbr"];
      print(abbr);
      print(resultScope[1]['bible_chapter']);
      print(resultScope[1]['verse']);
      print("********XXX*********");
      print(resultScope.sublist(1000, 1010));
      print("********XXX*XXXX***XXXXX*****");

      List<String> resultsVerses = [];
      for (int indexScope = 0; indexScope == resultScope.length; indexScope++) {
        searchWords = cleanList(resultScope[indexScope]['content']);
        double score = compare(queryWords, searchWords);
        if (score > 0.75) {
          var bookDB = resultScope[indexScope]['book_id'];
          if (bookDB >= 70 && bookDB <= 136) {
            bookDB = bookDB - 69;
          } //adjust for Slovak books from API, show English book names instead
          bookDB = bookDB - 1;
          Map<String, String> bookInfo = getBookInfo(bookDB, workingLanguage);

          String abbr = bookInfo["abbr"] ?? "N/A"; // Default value if null
          var chapterDB = resultScope[indexScope]['bible_chapter'];
          var verseDB = resultScope[indexScope]['verse'];

          var preparedRef = (abbr +
              " " +
              chapterDB.toString() +
              ":" +
              verseDB.toString() +
              " ");

          resultsVerses.add(preparedRef);
          resultsVerses.add(resultScope[indexScope]['content']);
          resultsVerses.add(((score * 100).toStringAsFixed(0)) + " %");
        }
      }

      ref.read(variablemonitorProvider.notifier).state++;
      return resultScope.first['content'] as String; // Return the verse content
    } else {
      return null; // No verse found for the given ID
    }
  } catch (e) {
    print('Error retrieving verse: $e');
    return null;
  } finally {
    // Close the database
    //await db.close();
    print("----");
  }
}

List<String> cleanList(String queryString) {
  queryString = queryString.toUpperCase(); // Convert to uppercase
  String cleanedString = queryString.replaceAll(
      RegExp(r'[.:,;?!"\-\!]'), ''); // Remove punctuation
  List<String> queryList = cleanedString.split(' ');
  queryList
      .removeWhere((word) => word == "THE" || word == "A" || word == "#KJVFS#");
  return queryList;
}

// Compare the query string with the base string
double compare(List queryString, List baseString) {
  int totalFound = 0;
  for (var word in queryString) {
    if (baseString.contains(word)) {
      totalFound++;
    }
  }

  return queryString.isEmpty ? 0.0 : totalFound / queryString.length;
}
/*
// Function to scan all the Bible books for a match
List<String> scanAll(String queryInput) {
  int bibleBooks = 66; // Constant for the number of books in the Bible
  List<String> resultsVerses = [];

  for (int indexBook = 1; indexBook <= bibleBooks; indexBook++) {
    for (int indexChapter = 1;
        indexChapter <= bookChapters(indexBook);
        indexChapter++) {
      for (int indexVerse = 1;
          indexVerse <= chapterVerses(indexBook, indexChapter);
          indexVerse++) {
        String baseVerse = getVerse(indexBook, indexChapter, indexVerse);
        String baseReference =
            getReference(indexBook, indexChapter, indexVerse);
        double score = compare(queryInput, baseVerse);

        if (score > 0.75) {
          resultsVerses.add(baseReference);
          resultsVerses.add(baseVerse);
          resultsVerses.add(((score * 100).toStringAsFixed(0)) + " %");
        }
      }
    }
  }

  return resultsVerses;
}

import 'package:sqflite/sqflite.dart';

Future<void> fuzzySearch(Database db, String searchString) async {
  // Tokenize the search string
  final searchTokens = searchString.split(' ');

  // Perform a basic MATCH query
  final results = await db.rawQuery(
    'SELECT content FROM documents WHERE content MATCH ?',
    [searchString],
  );

  // Filter the results based on the percentage of matching words
  const threshold = 0.7; // 70%
  for (final row in results) {
    final content = row['content'] as String;
    final contentTokens = content.split(' ');

    // Count matches
    final matches = searchTokens.where(contentTokens.contains).length;
    final matchPercentage = matches / searchTokens.length;

    if (matchPercentage >= threshold) {
      print('Match: $content (Match Percentage: ${matchPercentage * 100}%)');
    }
  }
}
*/