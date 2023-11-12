import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scriptus/audio/audio_player.dart';
import 'package:scriptus/extensions/deepl_service.dart';
import 'package:scriptus/extensions/openAiApi.dart';
import 'package:scriptus/extensions/utilities.dart';
import 'package:scriptus/models/bible_verse.dart';
import 'package:scriptus/models/transcript_segment.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/found_verses_provider.dart';
import 'package:scriptus/providers/search_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/providers/settings_provider.dart';
import 'package:scriptus/screen_parts/edit_sentence.dart';
import '../models/transcript_data.dart';

@riverpod
final translationProvider = StateProvider<String>((ref) => '');

// @riverpod
// class CurrentHeightProvider extends StateNotifier<double> {
//   CurrentHeightProvider() : super(152);

//   void updateHeight(double newHeight) {
//     state = newHeight;
//   }
// }

class SegmentTable extends ConsumerWidget {
  const SegmentTable({super.key});

  // durationFromString(String timeString) {
  //   List<String> parts = timeString.split(':');
  //   int hours = int.parse(parts[0]);
  //   int minutes = int.parse(parts[1]);
  //   int seconds = int.parse(parts[2]);

  //   Duration duration =
  //       Duration(hours: hours, minutes: minutes, seconds: seconds);
  //   Duration diff = const Duration(seconds: 6);
  //   Duration res = duration - (duration < diff ? duration : diff);
  //   return res;
  // }

  void addParagraphBreak(index) {
    print('addParagraphBreak: $index');
  }

  Future<void> callOpenAiApi(
      WidgetRef ref, TranscriptSegment s, int index) async {
    // Make the API call
    final response = await OpenAIService()
        .getGermanBibleReference(ref, s.text.trim(), index);

    // Update the provider with the response
    ref.read(foundVersesProvider.notifier).state = response;
  }

  Future<void> translateText(WidgetRef ref, String s, index) async {
    // Make the API call
    // This is a placeholder and you'll need to replace it with your actual API call
    final response = await TranslatioServices().translateText(s, "sk");
    print(response);
    ref.read(translationProvider.notifier).state = response;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WidgetRef ref; // Get this from your build method or somewhere else

    // ref
    //     .read(audioPlayerControllerProvider.notifier)
    //     .seek(Duration(seconds: 30));
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
    final sentenceState = ref.watch(sentenceProvider);
    final TranscriptData td = ref.watch(currentTranscriptProvider);
    final tdn = ref.read(currentTranscriptProvider.notifier);
    final settings = ref.watch(settingsProvider);
    // final AudioPlayerWidgetState audioPlayerState =
    //     ref.watch(audioPlayerProvider);
    final player = ref.read(audioPlayerControllerProvider.notifier);
    final searchValue = ref.watch(searchValueProvider);

    // if settings.showSearch is enabled, show the filtered segments from td.segments, otherwise show all
    // List<MapEntry<int,TranscriptSegment>> segments = [];
    List<MapEntry<int, TranscriptSegment>> segments =
        td.segments.asMap().entries.toList();
    List<MapEntry<int, TranscriptSegment>> filteredSegments = segments;
    if (settings.showSearch) {
      // print('ss: $searchValue');
      // print('ss2: $indexedSegments');
      // td.segments.where((s) => s.text.contains(searchValue)).toList();
      if (searchValue != '') {
        // print('ss3: $searchValue');
        filteredSegments = segments
            .where((s) => s.value.text.contains(searchValue))
            // .map((e) => e.value)
            .toList();
        // print('ss4: $filteredSegments');
      }
    }

    // final List<BibleVerse> bv = ref.watch(foundVersesProvider);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredSegments.length,
      // itemExtent: 152,
      itemBuilder: (context, index) {
        final s = filteredSegments[index].value;
        final originalIndex = filteredSegments[index].key;
        String sText = s.isBrRuss ? "Br. Russ: ${s.text}" : s.text;
        // padding: const EdgeInsets.all(0),
        // children: <Widget>[
        // for (var s in td.segments)
        return Container(
          height: editedSegmentIndex == originalIndex ? 300 : 152,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          // margin: EdgeInsets.only(bottom: (s.hasParagraphBreak ? 20 : 1)),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[800]
                : Colors.white,
            border: const Border(
              bottom: BorderSide(
                color: Colors.black54,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200,
                color: Colors.grey[900],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              color: Colors.grey[800],
                              padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                              width: 200,
                              child: Text("${s.startTime} - ${s.endTime}",
                                  style: const TextStyle(
                                      height: 1,
                                      color: Color.fromRGBO(250, 250, 250, 1),
                                      fontSize: 16,
                                      fontFamily: 'Courier New'))),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SegmentTableButton(
                            ref: ref,
                            // color: Colors.blue,
                            tooltip: 'Toggle paragraph break',
                            icon: const Icon(Icons.insert_page_break),
                            index: originalIndex,
                            color: s.hasParagraphBreak
                                ? Colors.blue
                                : Colors.white,
                            selected: s.hasParagraphBreak,
                            onPressed: () {
                              tdn.toggleHasParagraphBreak(originalIndex);
                            },
                          ),
                          SegmentTableButton(
                            ref: ref,
                            color: s.isScripture ? Colors.blue : Colors.white,
                            tooltip: 'Toggle Scripture',
                            icon: const Icon(Icons.menu_book),
                            index: index,
                            onPressed: () {
                              tdn.toggleIsScripture(index);
                            },
                          ),
                          SegmentTableButton(
                            ref: ref,
                            color: s.isWBQuote ? Colors.blue : Colors.white,
                            tooltip: 'Toggle WB Quote',
                            icon: const Icon(Icons.format_quote),
                            index: index,
                            onPressed: () {
                              tdn.toggleIsWBQuote(index);
                            },
                          ),
                          SegmentTableButton(
                            ref: ref,
                            color: s.isBrRuss ? Colors.blue : Colors.white,
                            tooltip: 'Toggle Br. Russ',
                            icon: const Icon(Icons.comment),
                            index: index,
                            onPressed: () {
                              tdn.toggleIsBrRuss(index);
                            },
                          ),
                          SegmentTableButton(
                            ref: ref,
                            color: s.isSong ? Colors.blue : Colors.white,
                            tooltip: 'Toggle Song',
                            icon: const Icon(Icons.music_note),
                            index: index,
                            onPressed: () {
                              tdn.toggleIsSong(index);
                            },
                          ),
                          // SegmentTableButton(
                          //   ref: ref,
                          //   tooltip: 'Delete segment',
                          //   icon: const Icon(Icons.delete),
                          //   onPressed: () {
                          //     tdn
                          //         .deleteSegment(index);
                          //   },
                          //   index: index,
                          // ),
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // const SizedBox(width: 13),
                        Container(
                          padding: const EdgeInsets.all(5),
                          width: 50,
                          decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(5),
                              color: Colors.white),
                          alignment: Alignment.center,
                          child: Text(
                            (filteredSegments[index].key + 1).toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SegmentTableButton(
                          ref: ref,
                          tooltip: 'Clean Scripture',
                          icon: const Icon(Icons.cleaning_services),
                          onPressed: () => {cleanText(ref, index, s.text)},
                          index: index,
                        ),
                        const SizedBox(width: 23),
                        SegmentTableButton(
                          ref: ref,
                          color: Colors.red,
                          tooltip: 'Restore',
                          icon: const Icon(Icons.settings_backup_restore),
                          onPressed: () => {tdn.restoreText(index)},
                          index: index,
                        ),
                        const SizedBox(width: 30),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SegmentTableButton(
                          ref: ref,
                          color: Colors.green,
                          tooltip: 'Translate SK',
                          icon: const Icon(Icons.language),
                          // onPressed: () => {translateText(ref, s.text, index)},
                          onPressed: () => {tdn.translateSegment(index)},
                          index: index,
                        ),
                        SegmentTableButton(
                          ref: ref,
                          color: Colors.green,
                          tooltip: 'Get Scripture references',
                          icon: const Icon(Icons.find_in_page),
                          onPressed: () => callOpenAiApi(ref, s, index),
                          index: index,
                        ),
                        SegmentTableButton(
                          ref: ref,
                          color: Colors.red,
                          tooltip: 'Load Next ',
                          icon: const Icon(Icons.swipe_down_alt),
                          onPressed: () => {
                            tdn.replaceNextSegmentTextWithNextVerse(ref, index)
                            // ref
                            //     .read(currentTranscriptProvider.notifier)
                            //     .replaceSegmentTextWithNextVerse(index)
                          },
                          index: index,
                        ),
                        SegmentTableButton(
                          ref: ref,
                          tooltip: 'Merge with previous',
                          icon: const Icon(Icons.merge),
                          onPressed: () => mergeWithPrevious(ref, index),
                          index: index,
                        ),
                        SegmentTableButton(
                          ref: ref,
                          tooltip: 'Merge with previous with comma',
                          icon: const Icon(Icons.merge),
                          onPressed: () =>
                              mergeWithPreviousWithComma(ref, index),
                          index: index,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
              Expanded(
                child: editedSegmentIndex == originalIndex
                    ? Container(color: Colors.blueGrey, child: EditSentence())
                    : GestureDetector(
                        // onDoubleTap: () => mergeWithPrevious(ref, index),
                        onLongPressEnd: (_) =>
                            player.seek(durationFromString(s.startTime)),
                        onTap: () {
                          ref.read(sentenceProvider.notifier).state = s;
                          ref.read(editedSegmentIndexProvider.notifier).state =
                              originalIndex;
                          ref
                              .read(editedTextCursorPositionProvider.notifier)
                              .state = 0;

                          //  + const Duration(seconds: 50));
                          // TranscriptSegment(
                          //   start: s.start,
                          //   end: s.end,
                          //   text: s.text,
                          //   startTime: s.startTime,
                          //   endTime: s.endTime,
                          //   hasParagraphBreak: s.hasParagraphBreak,
                          // );
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              // set  color: Colors.grey[900] if theme is dark, color: Colors.white if theme is light
                              color: sentenceState.startTime == s.startTime
                                  ? Colors.black12
                                  : Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.white,
                              border: const Border(
                                top: BorderSide(
                                  width: 1,
                                  color: Colors.white10,
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                        s.isScripture
                                            ? "\"$sText\""
                                            : (s.isSong
                                                ? "\u{1F3B5}$sText\u{1F3B5}"
                                                : sText),
                                        style: TextStyle(
                                          // overflow: TextOverflow.ellipsis,
                                          height: 1.6,
                                          fontSize: 22,
                                          // textBaseline: TextBaseline.values[0],
                                          // leadingDistribution:
                                          //     TextLeadingDistribution.proportional,
                                          fontFamily: 'Courier New',
                                          color: s.places.isNotEmpty
                                              ? Colors.blue
                                              : Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey[300]
                                                  : Colors.grey[800],
                                          fontStyle: s.isScripture || s.isSong
                                              ? FontStyle.italic
                                              : FontStyle.normal,
                                          fontWeight: s.isWBQuote
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        )),
                                  ),
                                  // const Divider(color: Colors.black, thickness: 1),
                                  if (settings.showSlovak)
                                    Expanded(
                                      child: Container(
                                        // height: 150,
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: Colors.black,
                                                    width: 1))),
                                        child: Text(s.textSk,
                                            style: TextStyle(
                                              // backgroundColor: Colors.red,
                                              // overflow: TextOverflow.ellipsis,
                                              height: 1.6,
                                              fontSize: 18,
                                              // textBaseline: TextBaseline.values[0],
                                              // leadingDistribution:
                                              //     TextLeadingDistribution.proportional,
                                              fontFamily: 'Courier New',
                                              color: s.places.isNotEmpty
                                                  ? Colors.blue
                                                  : Colors.black,
                                              fontStyle:
                                                  s.isScripture || s.isSong
                                                      ? FontStyle.italic
                                                      : FontStyle.normal,
                                              fontWeight: s.isWBQuote
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                            )),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              if (s.foundScriptures.isNotEmpty || s.places.isNotEmpty)
                Container(
                  color: Colors.blueGrey.shade700,
                  alignment: Alignment.center,
                  width: 40,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // TextButton(
                      //   style: ButtonStyle( backgroundColor: MaterialStateProperty.all<Color>(Colors.black),),
                      //   child: Text("P ${s.places.length}"),
                      //   onPressed: () => ref.read(foundPlacesProvider.notifier).state = s.places),
                      TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            shape: MaterialStateProperty.all(
                                ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(0))),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          child: Text("FS ${s.foundScriptures.length}"),
                          onPressed: () => ref
                              .read(foundVersesProvider.notifier)
                              .state = s.foundScriptures),
                      if (s.places.isNotEmpty)
                        TextButton(
                            style: ButtonStyle(
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                              shape: MaterialStateProperty.all(
                                  ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(0))),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            child: Text("P ${s.places.length}"),
                            onPressed: () =>
                                ref.read(foundVersesProvider.notifier).state = s
                                    .places
                                    .map((e) => BibleVerse.fromPlace(e))
                                    .toList()),
                      // Text("PS ${s.places.length}"),
                      if (s.assignedScripture != null)
                        Text(
                            '${s.assignedScripture!.bookAbb}\n${s.assignedScripture!.bibleChapter}:${s.assignedScripture!.verse}'),
                    ],
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}

class SegmentTableButton extends StatelessWidget {
  const SegmentTableButton({
    super.key,
    // this.key,
    required this.ref,
    required this.index,
    required this.tooltip,
    required this.icon,
    this.color = Colors.white, // Default value for color
    required this.onPressed,
    this.selected = false, // Default value for selected
  });

  // final Key? key;
  final WidgetRef ref;
  final int index;
  final bool selected;
  final Color color;
  final String tooltip;
  final Icon icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // color: Colors.red,
        width: 35,
        child: Tooltip(
          message: tooltip,
          waitDuration: const Duration(seconds: 1),
          child: IconButton(
            color: color,
            // tooltip: tooltip,
            splashRadius: 18,
            iconSize: 20,
            highlightColor: Colors.white,
            hoverColor: Colors.black,
            splashColor: Colors.white,
            icon: icon,
            onPressed: () {
              onPressed();
            },
          ),
        ));
  }
}
