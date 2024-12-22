import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //jumajazu2 added for clipboard operations
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/home_page.dart';
import 'package:scriptus/models/transcript_segment.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/providers/variable_monitor.dart';
import 'dart:convert';
import 'dart:io';

//Function performs fuzzy search in KJV.json and returns verses with match score above 75%

List<String> kjvFuzzySearch(String kjvquery, WidgetRef ref, tec) {
  //final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
  List<String> searchReturn = []; // Initialize results
  print("selection passed to kjvFuzzySearch function:");
  print(kjvquery);

  clicks = clicks +
      1; //increases whenever the function is called, used for updating widget viac variable_monitor.dart

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
  print("searchReturn: $searchReturn");
  if (searchReturn.isEmpty) {
    return ["No results found"];
  } else {
    return searchReturn;
  }
}
