import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/audio/audio_player.dart';
import 'package:scriptus/home_page.dart';
import 'package:scriptus/screen_parts/segment_table.dart';
import 'package:scriptus/screen_parts/edit_sentence.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scriptus/main.dart';
import 'package:scriptus/extensions/deepl_service.dart';
import 'package:scriptus/extensions/document_service.dart';
//import 'package:scriptus/providers/tec_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/services/kjv_fuzzy_search.dart';

// Define custom intents
class NewFileIntent extends Intent {}

class SaveFileIntent extends Intent {}

class PlayerIntent extends Intent {}

class NewSegmentIntent extends Intent {}

class FindIntent extends Intent {}

/*class BibleSearch {
  void searchKJV() {

    print("Searching Bible...");
  }
}
*/
class KeyboardShortcuts extends ConsumerStatefulWidget {
  final Widget child;
  final WidgetRef ref; // Make sure this is passed when creating the widget
  //final TextEditingController tec;
  //final tec = ref.watch(textControllerProvider);
  const KeyboardShortcuts({
    Key? key,
    required this.ref,
    //required this.tec,
    required this.child,
  }) : super(key: key);

  @override
  _KeyboardShortcutsState createState() => _KeyboardShortcutsState();
}

class _KeyboardShortcutsState extends ConsumerState<KeyboardShortcuts> {
  final FocusNode _focusNode = FocusNode();

  void Search() {
    searchKJV;
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  void _toggleAudioPlayer() {
    debugPrint("Toggling audio player...");
    try {
      final audioPlayer = ref.read(audioPlayerProvider);
      audioPlayer.playing ? audioPlayer.pause() : audioPlayer.play();
    } catch (e, stack) {
      debugPrint("Error toggling player: $e\n$stack");
    }
  }

  @override
  Widget build(BuildContext context) {
    //final tecSearch = ref.read(textControllerProvider);
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
              NewFileIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.tab):
              NewSegmentIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): PlayerIntent(),
          LogicalKeySet(LogicalKeyboardKey.f1):
              PlayerIntent(), //key to toggle Player for Win
          LogicalKeySet(LogicalKeyboardKey.f5):
              PlayerIntent(), //key to toggle Player for Mac
          LogicalKeySet(LogicalKeyboardKey.tab): NewSegmentIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
              FindIntent(),
        },
        child: Actions(
          actions: <Type, Action<Intent>>{
            NewFileIntent: CallbackAction<NewFileIntent>(
              onInvoke: (intent) {
                debugPrint("CTRL + N Pressed: to test shorcut monitor");
                return null;
              },
            ),
            PlayerIntent: CallbackAction<PlayerIntent>(
              onInvoke: (intent) {
                debugPrint("Key Pressed: toggle player");
                _toggleAudioPlayer();
                return null;
              },
            ),
            NewSegmentIntent: CallbackAction<NewSegmentIntent>(
              onInvoke: (intent) {
                debugPrint("CTRL+Tab Pressed: move to next segment:");
                //var segmentText = ref.watch(sentenceProvider).text;

                var currentSegment = ref.watch(editedSegmentIndexProvider);
                //print(segmentText);
                print("current segment: $currentSegment");
                ref.read(editedSegmentIndexProvider.notifier).state =
                    (ref.read(editedSegmentIndexProvider) ?? 0) +
                        1; //set the next segment to editing mode
                ref.read(sentenceProvider.notifier).state =
                    filteredSegmentsShortcuts[currentSegment! +
                        1]; //load the next segment text into the segment in the editing mode
                var nextSeg = ref.watch(editedSegmentIndexProvider);
                print("next segment: $nextSeg");

                scrollToEditedSegment(nextSeg!);

                /* WidgetsBinding.instance.addPostFrameCallback((_) {
                  Scrollable.ensureVisible(
                    context,
                    duration: Duration(milliseconds: 300),
                    alignment: 0.5, // Centers the selected item
                  );
                });
*/

                return null;
              },
            ),
            FindIntent: CallbackAction<FindIntent>(
              onInvoke: (intent) {
                debugPrint("Key Pressed: CTRL+F");

                searchKJV(widget.ref,
                    passTec); //EditSentence().KJVsearch(widget.ref, widget.tec);
                return null;
              },
            ),
          },
          child: widget.child,
        ),
      ),
    );
  }
}
