import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/models/bible_verse.dart';
// import 'package:scriptus/models/bible_verse.dart';
import 'package:scriptus/models/place.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
// import 'package:scriptus/providers/current_doc_provider.dart';
// import 'package:scriptus/providers/found_places_provider.dart';
// import 'package:scriptus/providers/meeting_provider.dart';
// import 'package:scriptus/providers/places_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';

class AssignedPlaces extends ConsumerWidget {
  /// Displays a list of places that have been assigned to the current segment.
  /// It is used in the SegmentEditor widget.
  const AssignedPlaces({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Place> places = ref.watch(sentenceProvider).places;
    int segmentIndex = ref.watch(editedSegmentIndexProvider) ?? 0;
    return Container(
      color: Colors.blueGrey[800],
      // padding: const EdgeInsets.all(8),
      width: 400,
      // height: 200,
      // color: Colors.blueGrey,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: places.length,
        itemBuilder: (context, index) {
          Place p = places[index];
          BibleVerse verse = BibleVerse.fromPlace(p);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: 400,
                padding: const EdgeInsets.all(10),
                color: Colors.blueGrey[600],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (p.isFullSegment)
                      const SizedBox(
                        child: Icon(Icons.fullscreen),
                      ),
                    if (p.isReference)
                      const SizedBox(
                        child: Icon(Icons.fullscreen),
                      ),
                    Expanded(
                      child: Text(
                        "${p.bookName} ${p.chapterNumber}:${p.verseStartNumber}: ${p.verseText}",
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
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
                    tooltip: "Replace selected segment with this verse",
                    splashRadius: 16,
                    iconSize: 18,
                    onPressed: () {
                      replaceSegmentTextWithVerse(ref, verse);
                      // ref.read(foundVersesProvider.notifier).remove(index);
                    },
                    icon: const Icon(Icons.find_replace),
                  ),
                  TextButton(
                    // highlightColor: Colors.red,
                    // tooltip: "Replace selected segment with this verse",
                    // splashRadius: 20,
                    // iconSize: 18,
                    onPressed: () {
                      addReferenceToEndOfText(
                        ref,
                        verse,
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
                        verse,
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
                  //   ],
                  // ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   // buttonPadding: const EdgeInsets.all(0),
                  //   // alignment: MainAxisAlignment.center,
                  //   children: [
                  IconButton(
                    highlightColor: Colors.white,
                    tooltip: "Include Previous",
                    splashRadius: 16,
                    iconSize: 18,
                    onPressed: () {
                      // replaceSegmentTextWithVerse(ref, places[index]);
                      // ref.read(foundplacesProvider.notifier).remove(index);
                    },
                    icon: const Icon(Icons.skip_previous),
                  ),
                  IconButton(
                    highlightColor: Colors.white,
                    tooltip: "Include Next",
                    splashRadius: 16,
                    iconSize: 18,
                    onPressed: () {
                      addNextVerse2SegmentPlaces(
                        ref,
                        index,
                        verse,
                      );
                      // ref.read(foundplacesProvider.notifier).remove(index);
                    },
                    icon: const Icon(Icons.skip_next),
                    // icon: const Icon(Icons.find_replace),
                  ),
                  IconButton(
                    // highlightColor: Colors.red,
                    tooltip: "Delete Place from Segment",
                    splashRadius: 20,
                    iconSize: 18,
                    onPressed: () {
                      ref.read(currentTranscriptProvider.notifier).deletePlace(
                            ref,
                            segmentIndex,
                            index,
                          );
                      // ref.read(foundplacesProvider.notifier).remove(index);
                    },
                    icon: const Icon(Icons.delete, color: Colors.red),
                    // icon: const Icon(Icons.find_replace),
                  ),
                  // IconButton(
                  //   tooltip:
                  //       "Replace selected Text in the segment with this verse",
                  //   splashRadius: 20,
                  //   iconSize: 18,
                  //   onPressed: () {
                  //     // ref.read(foundplacesProvider.notifier).remove(index);
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
        //   for (var a in places)
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
