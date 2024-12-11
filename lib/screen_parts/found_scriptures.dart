import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/extensions/openAiApi.dart';
import 'package:scriptus/models/bible_verse.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/found_verses_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/providers/variable_monitor.dart';
// import 'package:scriptus/screen_parts/segment_table.dart';

StateProvider<bool> fullReferenceChecBoxProvider =
    StateProvider<bool>((ref) => false);

class FoundScriptures extends ConsumerWidget {
  /// Displays a list of places that have been found through the OpenAI API.
  const FoundScriptures({
    super.key,
    // required this.verses,
    // required this.returnedText,
  });

  // final List<BibleVerse> verses;
  // final String returnedText;
  // void addReferenceToEndOfText(WidgetRef ref, BibleVerse verse) {
  //   final segmentIndex = ref.watch(editedSegmentIndexProvider);
  //   final segment = ref.watch(sentenceProvider);
  //   final segmentText = segment.text;
  //   final newText =
  //       '$segmentText [${verse.bookAbb} ${verse.bibleChapter}:${verse.verse}]';
  //   // final currentTranscript = ref.read(currentTranscriptProvider);
  //   // print(segmentIndex);
  //   // print(verse.content);
  //   // final newSegment = currentTranscript.segments[segmentIndex].copyWith(
  //   //   text: '"${verse.verse}"',
  //   // );
  //   ref
  //       .read(currentTranscriptProvider.notifier)
  //       .updateText(segmentIndex!, newText);
  //   ref.read(currentTranscriptProvider.notifier).addPlace(
  //         segmentIndex,
  //         Place(
  //           bookName: verse.bookAbb ?? '',
  //           bookId: verse.bookId ?? 0,
  //           chapterNumber: verse.bibleChapter ?? 0,
  //           verseStartNumber: verse.verse ?? 0,
  //           verseEndNumber: verse.verse ?? 0,
  //           verseText: verse.content,
  //           meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
  //           timePosition: segment.startTime,
  //         ),
  //       );
  //   ref.read(sentenceProvider.notifier).state = segment.copyWith(
  //     text: newText,
  //   );
  //   // ref
  //   //     .read(currentTranscriptProvider.notifier)
  //   //     .toggleIsScripture(segmentIndex);
  // }

  // void addVerseNumberToStart(WidgetRef ref, BibleVerse verse) {
  //   final segmentIndex = ref.watch(editedSegmentIndexProvider);
  //   final segmentText = ref.watch(sentenceProvider).text;
  //   final newText = '(${verse.verse}) $segmentText';
  //   // final currentTranscript = ref.read(currentTranscriptProvider);
  //   // print(segmentIndex);
  //   // print(verse.content);
  //   // final newSegment = currentTranscript.segments[segmentIndex].copyWith(
  //   //   text: '"${verse.verse}"',
  //   // );
  //   ref
  //       .read(currentTranscriptProvider.notifier)
  //       .updateText(segmentIndex!, newText);
  //   ref
  //       .read(currentTranscriptProvider.notifier)
  //       .toggleIsScripture(segmentIndex);
  // }

  // void replaceSegmentTextWithVerse(WidgetRef ref, BibleVerse verse) {
  //   final segmentIndex = ref.watch(editedSegmentIndexProvider);
  //   // final currentTranscript = ref.read(currentTranscriptProvider);
  //   // print(segmentIndex);
  //   // print(verse.content);
  //   // final newSegment = currentTranscript.segments[segmentIndex].copyWith(
  //   //   text: '"${verse.verse}"',
  //   final newText = '(${verse.verse}) ${verse.content}';
  //   // );
  //   ref
  //       .read(currentTranscriptProvider.notifier)
  //       .updateText(segmentIndex!, newText);
  //   ref
  //       .read(currentTranscriptProvider.notifier)
  //       .toggleIsScripture(segmentIndex);
  //   // ref.read(placeRepositoryProvider).createPlace(place: Place(
  //   //   name: verse.content,
  //   //   type: 'scripture',
  //   //   reference: '${verse.bookAbb} ${verse.bibleChapter}:${verse.verse}',))
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<BibleVerse> verses = ref.watch(foundVersesProvider);

    final apiCallStatus = ref.watch(apiCallStatusProvider);
    // final translation = ref.watch(translationProvider);

    //   return Scaffold(
    //     appBar: AppBar(title: Text("Counter: $counter")),
    //     body: Center(
    //       child: ElevatedButton(
    //         onPressed: () {
    //           // Increment the counter when button is pressed
    //           ref.read(variablemonitorProvider.notifier).state++;
    //         },
    //         child: const Text("Increment Counter"),
    //       ),
    //     ),
    //   );

    return SizedBox(
      // padding: const EdgeInsets.all(8),
      width: 400,
      // height: 200,
      // color: Colors.blueGrey,
      child: Column(
        children: [
          if (apiCallStatus == ApiCallStatus.loading)
            const SizedBox(
              height: 10,
              child: Center(
                child: LinearProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          if (verses.isNotEmpty)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: verses.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // if (translation.isNotEmpty)
                      //   Text(translation,
                      //       style: const TextStyle(
                      //         fontSize: 12,
                      //         color: Colors.white,
                      //       )),
                      // apiCallStatus == ApiCallStatus.loading
                      //     ? const Center(
                      //         child: LinearProgressIndicator(
                      //           color: Colors.white,
                      //         ),
                      //       )
                      Container(
                        color: Colors.blueGrey[600],
                        margin: const EdgeInsets.all(0),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "${verses[index].bookAbb} ${verses[index].bibleChapter}:${verses[index].verse}: ${verses[index].content}",
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        // buttonPadding: const EdgeInsets.all(0),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // alignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            highlightColor: Colors.red,
                            color: Colors.blue,
                            tooltip: "Insert Reference at saved position",
                            splashRadius: 20,
                            iconSize: 18,
                            onPressed: () {
                              insertReferenceToSavedPosition(ref, verses[index],
                                  ref.watch(editedTextCursorPositionProvider));
                              // ref.read(foundVersesProvider.notifier).remove(index);
                            },
                            icon: const Icon(Icons.merge),
                          ),
                          IconButton(
                            highlightColor: Colors.red,
                            color: Colors.blue,
                            tooltip: "Replace selected segment with this verse",
                            splashRadius: 20,
                            iconSize: 18,
                            onPressed: () {
                              replaceSegmentTextWithVerse(ref, verses[index]);
                              // ref.read(foundVersesProvider.notifier).remove(index);
                            },
                            icon: const Icon(Icons.find_replace),
                          ),
                          IconButton(
                            highlightColor: Colors.red,
                            color: Colors.blue,
                            tooltip: "Assign selected this verse to segment",
                            splashRadius: 20,
                            iconSize: 18,
                            onPressed: () {
                              assignVerseToSegment(ref, verses[index]);
                              // ref.read(foundVersesProvider.notifier).remove(index);
                            },
                            icon: const Icon(Icons.assignment_add),
                          ),
                          TextButton(
                            // highlightColor: Colors.red,
                            // tooltip: "Replace selected segment with this verse",
                            // splashRadius: 20,
                            // iconSize: 18,
                            onPressed: () {
                              addReferenceToEndOfText(
                                ref,
                                verses[index],
                              );
                              // ref.read(foundVersesProvider.notifier).remove(index);
                            },
                            child: const Text("[xx]"),
                            // icon: const Icon(Icons.find_replace),
                          ),
                          TextButton(
                            // highlightColor: Colors.red,
                            // tooltip: "Replace selected segment with this verse",
                            // splashRadius: 20,
                            // iconSize: 18,
                            onPressed: () {
                              addVerseNumberToStart(
                                ref,
                                verses[index],
                              );
                              // ref.read(foundVersesProvider.notifier).remove(index);
                            },
                            child: const Text("(x)"),
                            // icon: const Icon(Icons.find_replace),
                          ),
                          // TextButton(
                          //   // highlightColor: Colors.red,
                          //   // tooltip: "Replace selected segment with this verse",
                          //   // splashRadius: 20,
                          //   // iconSize: 18,
                          //   onPressed: () {
                          //     replaceNextSegmentTextWithNextVerse(
                          //       ref,
                          //       verses[index],
                          //     );
                          //     // ref.read(foundVersesProvider.notifier).remove(index);
                          //   },
                          //   child: const Text(">>"),
                          //   // icon: const Icon(Icons.find_replace),
                          // ),
                          // IconButton(
                          //   tooltip:
                          //       "Replace selected Text in the segment with this verse",
                          //   splashRadius: 20,
                          //   iconSize: 18,
                          //   onPressed: () {
                          //     // ref.read(foundVersesProvider.notifier).remove(index);
                          //   },
                          //   icon: const Icon(Icons.find_replace),
                          // ),
                        ],
                      ),
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
            ),
        ],
      ),
    );
  }
}
