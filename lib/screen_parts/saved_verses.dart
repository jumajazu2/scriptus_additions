import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/extensions/openAiApi.dart';
import 'package:scriptus/extensions/utilities.dart';
import 'package:scriptus/home_page.dart';
import 'package:scriptus/models/bible_verse.dart';
import 'package:scriptus/models/meeting.dart';
import 'package:scriptus/models/place.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/found_verses_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/services/kjv_from_db.dart';
import 'package:scriptus/services/meeting_service.dart';
import 'package:scriptus/services/msk_db_service.dart';
import 'package:scriptus/providers/variable_monitor.dart';
import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// import 'package:scriptus/screen_parts/segment_table.dart';

// part 'saved_verses.g.dart';

// StateProvider<bool> fullReferenceChecBoxProvider =
//     StateProvider<bool>((ref) => false);

// // load ApiService api provider
// final apiServiceProvider = Provider<ApiService>((ref) {
//   return ApiService();
// });

// @riverpod
// Future<List<BibleVerse>> fetchBibleVerses(FetchBibleVersesRef ref,
//     {required int meetingId}) async {
//   final Response json =
//       await ApiService().dio.get('meetings/$meetingId/bibleVerses');
//   return json.data.map((bv) => BibleVerse.fromJson(bv)).toList();
// }

class SavedVerses extends ConsumerWidget {
  /// Displays a filtered list of places from API that have been assigned to the current segment.
  const SavedVerses({
    super.key,
    // required this.verses,
    // required this.returnedText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<BibleVerse> verses = ref.watch(foundVersesProvider);
    final apiCallStatus = ref.watch(apiCallStatusProvider);
    // final translation = ref.watch(translationProvider);
    final meetingsAsyncValue = ref.read(meetingsProvider);
    final td = ref.watch(currentTranscriptProvider);
    final sentence = ref.watch(sentenceProvider);
    // print(meetingsAsyncValue);

    Meeting m;
    List<Place> places = [];
    // Check if the data is available
    if (meetingsAsyncValue is AsyncData<List<Meeting>>) {
      List<Meeting> ms = meetingsAsyncValue.value;
      print('meetingsAsyncValue: ${ms.length}');
      // print('meetingsAsyncValue: ${ms.first.id} ${td.meetingId}');
      try {
        m = ms.firstWhere((metting) => metting.id == td.meetingId);
        print('m: ${m.id}');
        print('m.places!.length: ${m.places!.length}');
        if (m.places != null) {
          // List<Place> places = // ... your list of Place objects
          List<Place> uniquePlaces = const Place().removeDuplicates(m.places!);
          // List<Place> uniquePlaces = m.places!;
          if (sentence.startTime == '') {
            places = uniquePlaces;
          } else {
            places = uniquePlaces
                .where((p) =>
                    // p.language != 'de' &&
                    parseDuration(p.timePosition) >
                        parseDuration(sentence.startTime) -
                            const Duration(seconds: 30) &&
                    parseDuration(p.timePosition) <
                        parseDuration(sentence.endTime) +
                            const Duration(seconds: 30))
                .toList();
          }
          places = List.from(places)
            ..sort((a, b) => parseDuration(a.timePosition)
                .compareTo(parseDuration(b.timePosition)));
          if (places.isEmpty) {
            fromAPItoKJV = [];
            //clicks = clicks + 1;
            //ref.read(variablemonitorProvider.notifier).state++;
          }

          //print("Debug places loaded for a segment:");
          //print(places);

          // places.sort((a, b) => parseDuration(a.timePosition)
          // .compareTo(parseDuration(b.timePosition)));
        }
      } catch (e) {
        print(e);
        throw RangeError('Meeting or places not found');
      }
    } else {
      throw RangeError('Not AsyncData data');
    }
    return Container(
      color: Colors.black,
      // padding: const EdgeInsets.all(8),
      width: 400,
      // height: 200,
      // color: Colors.blueGrey,
      child: m.places == null
          ? const SizedBox(
              height: 30,
              width: 30,
              child: Center(
                child: LinearProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : places.isEmpty
              ? const Text('No places in this meeting. Reload Meetings?')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    Place place = places[index];
                    if (index == 0) fromAPItoKJV = [];
                    //The following sends the SK places for the segment to getKJVVerseById when EN verses are retrieved from DB
                    var idSK = place.verseStartId;
                    var bookID = (place.bookId -
                        69); //offset to move from SK book to EN book
                    var language = place.language;
                    var bibleID = 1; //1 for English
                    var bookName = place.bookName;
                    var chapterNumber = place.chapterNumber;
                    var verseStartNumber = place.verseStartNumber;
                    if (idSK != null && language == "sk") {
                      print("result from getKJVVerseById:");
                      print("$bookName $chapterNumber:$verseStartNumber");
                      getKJVVerseById(bookID, bookName, chapterNumber,
                              verseStartNumber, bibleID, ref)
                          .then((resultKJV) {
                        String outputKJV = resultKJV ?? 'Default Value';

                        print(
                            outputKJV); // the output is to console for now, as the getKJVVerseById function is async and await/async cannot be used in this widget
                      });
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (translation.isNotEmpty)
                        //   Text(translation,
                        //       style: const TextStyle(
                        //         fontSize: 12,
                        //         color: Colors.white,
                        //       )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${place.timePosition} - ${place.bookName} ${place.chapterNumber}:${place.verseStartNumber} - ${place.verseEndNumber != place.verseStartNumber ? place.verseEndNumber : ""} - ${place.id} - ${place.sermonId != null ? "DURI" : "MIRO"}',
                            style: TextStyle(
                              fontSize: 16,
                              color: place.language == 'de'
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),
                        apiCallStatus == ApiCallStatus.loading
                            ? const Center(
                                child: LinearProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Container(
                                color: Colors.blueGrey[600],
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.all(10),
                                child: SelectableText(
                                  // "${place.bookName} ${place.chapterNumber}:${place.verseStartNumber}:
                                  //outputKJV,
                                  place.verseText,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Cambria',
                                  ),
                                ),
                              ),
                        // Row(
                        //   // buttonPadding: const EdgeInsets.all(0),
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   // alignment: MainAxisAlignment.center,
                        //   children: [
                        //     IconButton(
                        //       highlightColor: Colors.red,
                        //       color: Colors.blue,
                        //       tooltip: "Insert Reference at saved position",
                        //       splashRadius: 20,
                        //       iconSize: 18,
                        //       onPressed: () {
                        //         insertReferenceToSavedPosition(
                        //             ref,
                        //             verses[index],
                        //             ref.watch(
                        //                 editedTextCursorPositionProvider));
                        //         // ref.read(foundVersesProvider.notifier).remove(index);
                        //       },
                        //       icon: const Icon(Icons.merge),
                        //     ),
                        //     IconButton(
                        //       highlightColor: Colors.red,
                        //       color: Colors.blue,
                        //       tooltip:
                        //           "Replace selected segment with this verse",
                        //       splashRadius: 20,
                        //       iconSize: 18,
                        //       onPressed: () {
                        //         replaceSegmentTextWithVerse(ref, verses[index]);
                        //         // ref.read(foundVersesProvider.notifier).remove(index);
                        //       },
                        //       icon: const Icon(Icons.find_replace),
                        //     ),
                        //     TextButton(
                        //       // highlightColor: Colors.red,
                        //       // tooltip: "Replace selected segment with this verse",
                        //       // splashRadius: 20,
                        //       // iconSize: 18,
                        //       onPressed: () {
                        //         addReferenceToEndOfText(
                        //           ref,
                        //           verses[index],
                        //         );
                        //         // ref.read(foundVersesProvider.notifier).remove(index);
                        //       },
                        //       child: const Text("[xx]"),
                        //       // icon: const Icon(Icons.find_replace),
                        //     ),
                        //     TextButton(
                        //       // highlightColor: Colors.red,
                        //       // tooltip: "Replace selected segment with this verse",
                        //       // splashRadius: 20,
                        //       // iconSize: 18,
                        //       onPressed: () {
                        //         addVerseNumberToStart(
                        //           ref,
                        //           verses[index],
                        //         );
                        //         // ref.read(foundVersesProvider.notifier).remove(index);
                        //       },
                        //       child: const Text("(x)"),
                        //       // icon: const Icon(Icons.find_replace),
                        //     ),
                        //     // TextButton(
                        //     //   // highlightColor: Colors.red,
                        //     //   // tooltip: "Replace selected segment with this verse",
                        //     //   // splashRadius: 20,
                        //     //   // iconSize: 18,
                        //     //   onPressed: () {
                        //     //     replaceNextSegmentTextWithNextVerse(
                        //     //       ref,
                        //     //       verses[index],
                        //     //     );
                        //     //     // ref.read(foundVersesProvider.notifier).remove(index);
                        //     //   },
                        //     //   child: const Text(">>"),
                        //     //   // icon: const Icon(Icons.find_replace),
                        //     // ),
                        //     // IconButton(
                        //     //   tooltip:
                        //     //       "Replace selected Text in the segment with this verse",
                        //     //   splashRadius: 20,
                        //     //   iconSize: 18,
                        //     //   onPressed: () {
                        //     //     // ref.read(foundVersesProvider.notifier).remove(index);
                        //     //   },
                        //     //   icon: const Icon(Icons.find_replace),
                        //     // ),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Checkbox(
                        //         // hoverColor: Colors.red[200],
                        //         checkColor: Colors.white,
                        //         fillColor: MaterialStateProperty.all(Colors.red),
                        //         value: ref.watch(fullReferenceChecBoxProvider),
                        //         onChanged: (a) => ref
                        //             .read(fullReferenceChecBoxProvider.notifier)
                        //             .state = a!),
                        //     const Text("Copy Full Reference"),
                        //   ],
                        // ),
                      ],
                    );
                  },
                  // children: [
                  //   const Text('Related Scriptures'),
                  //   for (var a in verses)
                  //     Container(
                  //       color: Colors.blueGrey[600],
                  //       margin: const EdgeInsets.only(bottom: 4),
                  //       padding: const EdgeInsets.all(4),
                  //       child: Text(
                  //         "${a.bookAbb} ${a.bibleChapter}:${a.verse}: ${a.content}",
                  //         style: const TextStyle(
                  //           fontSize: 16,
                  //         ),
                  //       ),
                  //     ),
                  //   // Text(returnedText),
                  // ],
                ),
    );
  }
}
