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
import 'package:scriptus/services/load_from_DB.dart';
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
  List<String> searchReturn = [];
  // Initialize results
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
    //queryList.removeWhere(
    //    (word) => word == "THE" || word == "A" || word == "#KJVFS#");
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
  //searchReturn = scanAll(kjvquery);
  searchReturn = fuzzyBibleSearch(kjvquery, language, ref, tec) ?? [];

  //print("searchReturn_from_DBSearch: $searchReturn");
  if (searchReturn.isEmpty) {
    return ["No results found@@@___"];
  } else {
    return searchReturn;
  }
}

List<String>? fuzzyBibleSearch(
    String query, String language, WidgetRef ref, tec) {
  //final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);

  if (searchScopeDB == null) {
    loadFromDB();
    print("searchScopeDB is empty, loading content from DB");
  } else {
    print("searchScopeDB is already loaded, skipping DB loading");
  }

  print("string in $language passed to fuzzyBibleSearch DB function: $query");
  //print(searchScopeDB?.sublist(1, 20));

  //clicks = clicks +
  //    1; //increases whenever the function is called, used for updating widget via variable_monitor.dart

  ref.read(variablemonitorProvider.notifier).state++;

  List<String> queryWords = cleanList(
      query); //turns the query string into a list of uppercase words, special characters removed
  List<String> searchWords;

  print("Querywords: $queryWords");
  print(searchScopeDB?.length);

  // Check if a result was found
  try {
    if (searchScopeDB!.isNotEmpty) {
      print(searchScopeDB!.length);
      List<String> resultsVerses = [];
      List<String> priorityResults = [];
      for (int indexScope = 0;
          indexScope < searchScopeDB!.length;
          indexScope++) {
        searchWords = cleanList(searchScopeDB![indexScope]['content']);
        var score = compare2(queryWords, searchWords);

        if (score[0] > 0.70) {
          var bookDB = searchScopeDB![indexScope]['book_id'];
          if (bookDB >= 70 && bookDB <= 136) {
            bookDB = bookDB - 69;
          } //adjust for Slovak books from API, show English book names instead
          bookDB = bookDB - 1;
          Map<String, String> bookInfo = getBookInfo(bookDB, workingLanguage);

          String abbr = bookInfo["name"] ?? "N/A"; // Default value if null
          var chapterDB = searchScopeDB![indexScope]['bible_chapter'];
          var verseDB = searchScopeDB![indexScope]['verse'];

          int priorityResult = (score[0] >= 0.90) ? 1 : 0;
          int preparedScore = ((score[0] * 100).toInt());

          String scoreStr = preparedScore.toStringAsFixed(0);
          var preparedRef =
              "$abbr $chapterDB:$verseDB                 [$scoreStr %]  @@@___";
          var foundWords = score[1];
          print(
              "coming from compare2 in List<dynamic>, score and the list of found words: $score");

          //   var highlightedResult = highlightFoundWords(
          //       searchScopeDB![indexScope]['content'],
          //       score[
          //           1]); //returns the resultant string bold-formatted with all found words from query
/*        

          resultsVerses.add(preparedRef);
          resultsVerses.add(searchScopeDB![indexScope]['content']);
          resultsVerses.add(((score * 100).toStringAsFixed(0)) + " %");
*/
          String foundWordsStr = foundWords.join(", ");
          String combinedCF = searchScopeDB![indexScope]['content'] +
              "@@@" +
              foundWordsStr; //combined result string: Found Stripture+"@@@"+Found Words as CSV
          List<String> preparedResult = [
            preparedRef,
            combinedCF
          ]; //add function to highlight found words, move score to the same line as Reference, increase box height if settings.found OFF

          if (priorityResult == 1) {
            priorityResults.addAll(preparedResult);
            print("adding priority result: $preparedResult");
          }

          print("adding standard preparedResult = $preparedResult");

          resultsVerses.addAll(preparedResult);
        }
      }

      if (resultsVerses.length > 3 && priorityResults.isNotEmpty) {
        priorityResults
            .addAll(["**********************************************@@@***"]);
        priorityResults.addAll(resultsVerses);
        print(
            "adding separator before all standard results after priority results: $priorityResults"); //make a list where the first verses are those with score above 90, then a separator followed by all results
      } else {
        priorityResults = resultsVerses;
        print("only one result found: $resultsVerses");
      }

      resultsVerses = priorityResults;
      //var printResult = resultsVerses[1];
      //print("1-10 from DB search: $printResult");
      ref.read(variablemonitorProvider.notifier).state++;

      searchReturn = resultsVerses;
      //print(searchReturn);
      //print(resultsVerses);

      return searchReturn; // Return the verse content
    } else {
      print("searchScopeDB is empty");
      return null; // No verse found for the given ID
    }
  } catch (e) {
    print('Error retrieving verse: $e');
    searchReturn = ['No results...@@@___'];
    return searchReturn;
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
  // queryList
  //     .removeWhere((word) => word == "THE" || word == "A" || word == "#KJVFS#");
  return queryList;
}

/* Compare the query string with the base string
double compare(List queryString, List baseString) {
  int totalFound = 0;

  for (var word in queryString) {
    if (baseString.contains(word)) {
      totalFound++;
    }
  }

  var compWithQuery = (totalFound / queryString.length);

  var compWithBase = (totalFound / baseString.length);
  if (compWithBase > 0.7 || compWithQuery > 0.7) {
    print("compWithQuery=$compWithQuery----compWithBase=$compWithBase ");
    print(queryString.length);
    print(queryString);
    print(baseString.length);
    print(baseString);
    print(totalFound);
  }
  if (compWithBase > compWithQuery) {
    print("returning substring result -compWithBase is: $compWithBase");
    return compWithBase;
  } else {
    print("returning whole-string result -compWithQuery is: $compWithQuery");
    return compWithQuery;
  }

  //return queryString.isEmpty ? 0.0 : totalFound / queryString.length;
}
*/
List<dynamic> compare2(
    List queryString,
    List
        baseString) //check how many words from baseString is found in queryString, effective when more scriptures contained in one segment
{
  int totalFound_query = 0;
  int totalFound_base = 0;

  List foundWords1 = [];
  List foundWords2 = [];
  //count how many words from queryString is found in each Bible scripture, compWithBase is the percentage of all found words to each Scriture
  //effective when a longer query contains a scripture that is only a short part of the query
  for (var word in baseString) {
    if (queryString.contains(word)) {
      if (word != "xTHE" || word != "xTHE") {
        totalFound_base++;
      }
      foundWords1.add(
          word); //show which words contributed to the score, will be shown in bold
    }
  }
  var compWithBase = (totalFound_base / baseString.length);

/*
  List<dynamic> commonElements =
      baseString.where((item) => queryString.contains(item)).toList();
  bool substring;
  if (commonElements.length / baseString.length > 0.9) {
    substring = true;
  }
*/
//count how many words from each Bible Scripture is found in queryString
//effective to return Scriptures containing the whole or most of the query
  for (var word in queryString) {
    if (baseString.contains(word)) {
      if (word != "xTHE" || word != "xTHE") {
        totalFound_query++;
      }

      foundWords2.add(word);
    }
  }

  var compWithQuery = (totalFound_query / queryString.length);

  if (compWithBase > 0.75) {
    /* print("compWithQuery=$compWithQuery----compWithBase=$compWithBase ");
    print(queryString.length);
    print(queryString);
    print(baseString.length);
    print(baseString);
    print(totalFound_base);
    print(totalFound_query);
*/

    print(
        "returning substring result, compWithQuery=$compWithQuery----compWithBase=$compWithBase ");
    print(baseString);
    print(foundWords1);
    print(baseString.length);
    print(totalFound_base);
    return [compWithBase, foundWords1];
  } else if (compWithQuery > 0.75) {
    /* print("compWithQuery=$compWithQuery----compWithBase=$compWithBase ");
    print(queryString.length);
    print(queryString);
    print(baseString.length);
    print(baseString);
    print(totalFound_base);
    print(totalFound_query);
*/
    print(
        "returning whole-string result, compWithQuery=$compWithQuery----compWithBase=$compWithBase ");
    return [compWithQuery, foundWords2];
  } /*else if (substring = true) {
    print("substring found: $commonElements");
    return 0.90;*/
  else {
    return [0, ""];
  }
}

TextSpan highlightFoundWords(returnedResult, foundWords) {
  List<TextSpan> spans = [];

  // Using RegExp to split text while keeping punctuation
  RegExp exp = RegExp(r"(\b\w+\b|[^\s])");

  for (var match in exp.allMatches(returnedResult)) {
    String word = match.group(0)!; // Extract word or punctuation

    // Check case-insensitive match
    bool isBold =
        foundWords.map((e) => e.toLowerCase()).contains(word.toLowerCase());

    spans.add(TextSpan(
      text: "$word ", // Preserve spacing
      style:
          TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    ));
  }

  print("TextSpan created for: \"$returnedResult\" highlighting: $foundWords");
  print(spans);
  return TextSpan(children: spans);
}

void insertRefAtCursor(WidgetRef ref, String reference) {
  final segmentIndex = ref.watch(editedSegmentIndexProvider); //current segment
  final segment = ref.watch(sentenceProvider); //content of current segment
  final segmentText = segment.text; //text of current segment
  //final newText = '$segmentText [$reference]';
  var cursorPos = ref.watch(
      editedTextCursorPositionProvider); //reads cursor position - place ref at curson position, newText, split segmentText
  print("cursorPosition = $cursorPos");

  final newText = segmentText.substring(0, cursorPos) +
      " [$reference]" +
      segmentText.substring(cursorPos);
  ref
      .read(currentTranscriptProvider.notifier)
      .updateText(segmentIndex!, newText);

  ref.read(sentenceProvider.notifier).state = segment.copyWith(text: newText);
}







  //return queryString.isEmpty ? 0.0 : totalFound / queryString.length;

