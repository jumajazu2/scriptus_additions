import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //jumajazu2 added for clipboard operations
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/audio/audio_player.dart';
import 'package:scriptus/extensions/document_service.dart';
import 'package:scriptus/extensions/openAiApi.dart';
import 'package:scriptus/extensions/utilities.dart';
import 'package:scriptus/home_page.dart';
import 'package:scriptus/models/transcript_segment.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/found_verses_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/providers/variable_monitor.dart';
import 'package:scriptus/services/kjv_fuzzy_search.dart';
import 'package:scriptus/screen_parts/settings/settigns_dialog.dart';
import 'package:scriptus/providers/settings_provider.dart';

// import 'package:scriptus/constants.dart';

// create a riverpod provider to hold CMD button pressed status
// final cmdPressedProvider = StateProvider<bool>((ref) {
//   return false;
// });

class EditSentence extends HookConsumerWidget {
  // EditSentence({Key? key}) : super(key: key);

  // final int index;
  // final TextEditingController tec = TextEditingController();
  final TextEditingController tecStart = TextEditingController();
  final TextEditingController tecEnd = TextEditingController();

  EditSentence({super.key});

  // const EditSentence({required this.tec});
  // mergeSegments(TranscriptSegment sentenceState) {
  // final TranscriptSegment previousSentence =
  //     sentenceProvider.read(context).state;
  // tec.text = sentenceState.text.trim();
  // tec.selection = TextSelection.fromPosition(
  //     TextPosition(offset: tec.text.length)); // to set cursor position
  // }

  void splitCurrentSegment(WidgetRef ref) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
    if (editedSegmentIndex != null) {
      final splitIndex = ref.watch(editedTextCursorPositionProvider);
      // final splitIndex = tec.selection.baseOffset;
      ref
          .read(currentTranscriptProvider.notifier)
          .splitSegment(editedSegmentIndex, splitIndex);
      TranscriptSegment ts =
          ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
      ref.read(sentenceProvider.notifier).state = ts;
    }
  }

  void splitCurrentSegmentAsQuote(WidgetRef ref) {
    // print(
    //     "splitCurrentSegmentAsQuote - tec.selection.baseOffsete: ${tec.selection.baseOffset}");
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
    if (editedSegmentIndex != null) {
      final splitIndex = ref.watch(editedTextCursorPositionProvider);
      // final splitIndex = tec.selection.baseOffset;
      print("splitCurrentSegmentAsQuote - splitIndex: $splitIndex");
      ref
          .read(currentTranscriptProvider.notifier)
          .splitCurrentSegmentAsQuote(editedSegmentIndex, splitIndex);
      TranscriptSegment ts =
          ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
      ref.read(sentenceProvider.notifier).state = ts;
    }
  }

  void splitCurrentSegmentAsSentence(WidgetRef ref) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
    if (editedSegmentIndex != null) {
      final splitIndex = ref.watch(editedTextCursorPositionProvider);
      // final splitIndex = tec.selection.baseOffset;
      ref
          .read(currentTranscriptProvider.notifier)
          .splitCurrentSegmentAsSentence(editedSegmentIndex, splitIndex);
      TranscriptSegment ts =
          ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
      ref.read(sentenceProvider.notifier).state = ts;
    }
  }

  void connectWithComma(WidgetRef ref) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
    if (editedSegmentIndex != null) {
      final splitIndex = ref.watch(editedTextCursorPositionProvider);
      // final splitIndex = tec.selection.baseOffset;
      ref
          .read(currentTranscriptProvider.notifier)
          .connectWithComma(editedSegmentIndex, splitIndex);
      TranscriptSegment ts =
          ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
      ref.read(sentenceProvider.notifier).state = ts;
    }
  }

  Future<void> callOpenAiApi(WidgetRef ref, tec) async {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);

    if (editedSegmentIndex != null) {
      // Get the current selection
      TextSelection selection = tec.selection;

      if (selection.isValid && selection.isCollapsed == false) {
        // Get the selected text
        String selectedText =
            tec.text.substring(selection.start, selection.end);

        if (selectedText.isNotEmpty) {
          // Make the API call
          final response = await OpenAIService().getGermanBibleReference(ref,
              selectedText, ref.watch(editedSegmentIndexProvider)!.toInt());
          // Add more verses as needed

          // Update the provider with the response
          ref.read(foundVersesProvider.notifier).state = response;
        }
      }
    }
  }

  // void saveReferencePosition(WidgetRef ref) {
  //   final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);

  //   if (editedSegmentIndex != null) {
  //     // Get the current selection
  //     // TextSelection selection = tec.selection;
  //     int cursorPosition = tec.selection.baseOffset;

  //     if (cursorPosition > 0 && cursorPosition < tec.text.length) {
  //       // Add empty brackets
  //       // String newText = '[]';

  //       String currentText = tec.text;
  //       String newText =
  //           '${currentText.substring(0, cursorPosition!)} [] ${currentText.substring(cursorPosition!)}';
  //       tec.text = newText;

  //       // Adjust the cursor position to be right after the inserted characters
  //       tec.selection = TextSelection.collapsed(offset: cursorPosition! + 2);

  //       ref
  //           .read(currentTranscriptProvider.notifier)
  //           .updateText(editedSegmentIndex, tec.text);
  //     }
  //     TranscriptSegment ts =
  //         ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
  //     ref.read(sentenceProvider.notifier).state = ts;

  //     // if (editedSegmentIndex != null) {
  //     //   final splitIndex = tec.selection.baseOffset;
  //     //   ref
  //     //       .read(currentTranscriptProvider.notifier)
  //     //       .splitSegment(editedSegmentIndex, splitIndex);
  //     // }
  //   }
  // }
  String makeFirstLetterUppercase(String text) {
    if (text.isNotEmpty) {
      text = text[0].toUpperCase() + text.substring(1);
    }
    return text;
  }

  // Add tags around the selected text
  String encloseText(String text, List<String> tags) {
    String result = '"$text"';
    for (var tag in tags.reversed) {
      result = '<$tag>$result</$tag>';
    }
    return result;
  }

  String addColonToEnd(String text) {
    String newText = '';
    text = text.trim();
    if (text.isNotEmpty &&
        ['.', ',', ';', ':', '!', '?']
            .contains(text.substring(text.length - 1))) {
      newText = '${text.substring(0, text.length - 1)}: ';
    } else {
      // add colon instead of replacing last character
      newText = '${text.substring(0, text.length)}: ';
    }
    return newText;
  }

  void addQuotesBoldandItalic(WidgetRef ref, tec, {bool addColon = false}) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);

    if (editedSegmentIndex != null) {
      // Get the current selection
      TextSelection selection = tec.selection;

      if (selection.isValid && selection.isCollapsed == false) {
        String newFirstText = '';
        if (addColon) {
          newFirstText = addColonToEnd(tec.text.substring(0, selection.start));
        } else {
          newFirstText = tec.text.substring(0, selection.start);
        }
        // Get the selected text
        String selectedText =
            tec.text.substring(selection.start, selection.end);

        // Make the first letter uppercase
        //selectedText = makeFirstLetterUppercase(selectedText); disabled as this usually needs to be change to lowercase again

        String enclosedSelectedText = encloseText(selectedText, ["b", "i"]);

        // Replace in the text field the selected text with the new text
        tec.text = tec.text = newFirstText +
            enclosedSelectedText +
            tec.text.substring(selection.end);
        // Update the selection to keep it in the correct place
        // tec.selection = TextSelection(
        //   baseOffset: selection.start,
        //   extentOffset: selection.start + newText.length,
        // );

        // update Document's segment's text
        ref
            .read(currentTranscriptProvider.notifier)
            .updateText(editedSegmentIndex, tec.text);
        TranscriptSegment ts =
            ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
        ref.read(sentenceProvider.notifier).state = ts;
      }

      // if (editedSegmentIndex != null) {
      //   final splitIndex = tec.selection.baseOffset;
      //   ref
      //       .read(currentTranscriptProvider.notifier)
      //       .splitSegment(editedSegmentIndex, splitIndex);
      // }
    }
  }

  void addQuotesandItalic(WidgetRef ref, tec, {bool addColon = false}) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);

    if (editedSegmentIndex != null) {
      // Get the current selection
      TextSelection selection = tec.selection;

      if (selection.isValid && selection.isCollapsed == false) {
        // Get the selected text
        String selectedText =
            tec.text.substring(selection.start, selection.end);
        selectedText = makeFirstLetterUppercase(selectedText);

        String newFirstText = '';
        if (addColon) {
          newFirstText = addColonToEnd(tec.text.substring(0, selection.start));
        } else {
          newFirstText = tec.text.substring(0, selection.start);
        }

        // Make the first letter uppercase
        // if (selectedText.isNotEmpty) {
        //   selectedText =
        //       selectedText[0].toUpperCase() + selectedText.substring(1);
        // }

        String enclosedSelectedText = encloseText(selectedText, ["i"]);

        // Replace in the text field the selected text with the new text
        tec.text = tec.text = newFirstText +
            enclosedSelectedText +
            tec.text.substring(selection.end);

        // String newText = '<i>"$selectedText"</i>';
        // Replace the selected text with the new text
        // tec.text =
        //     tec.text.replaceRange(selection.start, selection.end, newText);
        // Update the selection to keep it in the correct place
        // tec.selection = TextSelection(
        //   baseOffset: selection.start,
        //   extentOffset: selection.start + newText.length,
        // );
      }
      ref
          .read(currentTranscriptProvider.notifier)
          .updateText(editedSegmentIndex, tec.text);
      TranscriptSegment ts =
          ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
      ref.read(sentenceProvider.notifier).state = ts;
    }
  }

  void addQuotesandBold(WidgetRef ref, tec, {bool addColon = false}) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);

    if (editedSegmentIndex != null) {
      // Get the current selection
      TextSelection selection = tec.selection;

      if (selection.isValid && selection.isCollapsed == false) {
        // Get the selected text
        String selectedText =
            tec.text.substring(selection.start, selection.end);

        selectedText = makeFirstLetterUppercase(selectedText);

        String newFirstText = '';
        if (addColon) {
          newFirstText = addColonToEnd(tec.text.substring(0, selection.start));
        } else {
          newFirstText = tec.text.substring(0, selection.start);
        }

        String enclosedSelectedText = encloseText(selectedText, ["b"]);

        // Replace in the text field the selected text with the new text
        tec.text = tec.text = newFirstText +
            enclosedSelectedText +
            tec.text.substring(selection.end);
        // Make the first letter uppercase
        // if (selectedText.isNotEmpty) {
        //   selectedText =
        //       selectedText[0].toUpperCase() + selectedText.substring(1);
        // }

        // Add quotation marks
        // String newText = '<b>"$selectedText"</b>';

        // Replace the selected text with the new text
        // tec.text =
        //     tec.text.replaceRange(selection.start, selection.end, newText);

        // Update the selection to keep it in the correct place
        // tec.selection = TextSelection(
        //   baseOffset: selection.start,
        //   extentOffset: selection.start + newText.length,
        // );
      }
      // if (editedSegmentIndex != null) {
      //   final splitIndex = tec.selection.baseOffset;
      //   ref
      //       .read(currentTranscriptProvider.notifier)
      //       .splitSegment(editedSegmentIndex, splitIndex);
      // }
      ref
          .read(currentTranscriptProvider.notifier)
          .updateText(editedSegmentIndex, tec.text);
      TranscriptSegment ts =
          ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
      ref.read(sentenceProvider.notifier).state = ts;
    }
  }

  void addQuotes(WidgetRef ref, tec, {bool addColon = false}) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);

    if (editedSegmentIndex != null) {
      // Get the current selection
      TextSelection selection = tec.selection;

      if (selection.isValid && selection.isCollapsed == false) {
        // Get the selected text
        String selectedText =
            tec.text.substring(selection.start, selection.end);
        selectedText = makeFirstLetterUppercase(selectedText);

        String newFirstText = '';
        if (addColon) {
          newFirstText = addColonToEnd(tec.text.substring(0, selection.start));
        } else {
          newFirstText = tec.text.substring(0, selection.start);
        }

        // Make the first letter uppercase
        // if (selectedText.isNotEmpty) {
        //   selectedText =
        //       selectedText[0].toUpperCase() + selectedText.substring(1);
        // }

        // Add quotation marks
        String newText = '"$selectedText"';

        tec.text = tec.text =
            newFirstText + newText + tec.text.substring(selection.end);

        // Replace the selected text with the new text
        // tec.text =
        //     tec.text.replaceRange(selection.start, selection.end, newText);

        // Update the selection to keep it in the correct place
        tec.selection = TextSelection(
          baseOffset: selection.start,
          extentOffset: selection.start + newText.length,
        );
      }
      // if (editedSegmentIndex != null) {
      //   final splitIndex = tec.selection.baseOffset;
      //   ref
      //       .read(currentTranscriptProvider.notifier)
      //       .splitSegment(editedSegmentIndex, splitIndex);
      // }
      ref
          .read(currentTranscriptProvider.notifier)
          .updateText(editedSegmentIndex, tec.text);
      TranscriptSegment ts =
          ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
      ref.read(sentenceProvider.notifier).state = ts;
    }
  }

  void addColon(WidgetRef ref, tec, {bool addColon = true}) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
    final splitIndex = tec.selection.baseOffset;
    print(editedSegmentIndex);
    print(splitIndex);
    if (editedSegmentIndex != null && splitIndex > 0) {
      // Get the selected text
      String secondText =
          tec.text.substring(splitIndex, tec.text.length).trim();

      print(secondText);
      secondText = makeFirstLetterUppercase(secondText);

      String newFirstText = '';
      if (addColon) {
        newFirstText = addColonToEnd(tec.text.substring(0, splitIndex));
      } else {
        newFirstText = tec.text.substring(0, splitIndex);
      }
      print(newFirstText);
      tec.text = newFirstText + secondText;
    }
    ref
        .read(currentTranscriptProvider.notifier)
        .updateText(editedSegmentIndex!, tec.text);
    TranscriptSegment ts =
        ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
    ref.read(sentenceProvider.notifier).state = ts;
  }

  void addQuotesSmall(WidgetRef ref, tec) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);

    if (editedSegmentIndex != null) {
      // Get the current selection
      TextSelection selection = tec.selection;

      if (selection.isValid && selection.isCollapsed == false) {
        // Get the selected text
        String selectedText =
            tec.text.substring(selection.start, selection.end);

        // Make the first letter uppercase
        // if (selectedText.isNotEmpty) {
        //   selectedText =
        //       selectedText[0].toUpperCase() + selectedText.substring(1);
        // }

        // Add quotation marks
        String newText = '"… $selectedText"';

        // Replace the selected text with the new text
        tec.text =
            tec.text.replaceRange(selection.start, selection.end, newText);

        // Update the selection to keep it in the correct place
        tec.selection = TextSelection(
          baseOffset: selection.start,
          extentOffset: selection.start + newText.length,
        );
      }
      // if (editedSegmentIndex != null) {
      //   final splitIndex = tec.selection.baseOffset;
      //   ref
      //       .read(currentTranscriptProvider.notifier)
      //       .splitSegment(editedSegmentIndex, splitIndex);
      // }
      ref
          .read(currentTranscriptProvider.notifier)
          .updateText(editedSegmentIndex, tec.text);
      TranscriptSegment ts =
          ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
      ref.read(sentenceProvider.notifier).state = ts;
    }
  }

//jumajazu2 added - send whole segment/selection to clipboard to kjvFuzzySearch amd to Clipboard where it can be intercepted by external code
  void KJVsearch(WidgetRef ref, tec) {
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);

    clicks = clicks + 1;

    ref.read(variablemonitorProvider.notifier).state++;
    print(variablemonitorProvider.notifier);
    if (editedSegmentIndex != null) {
      // Get the current selection
      TextSelection selection = tec.selection;

      if (selection.isValid && selection.isCollapsed == false) {
        // Get the selected text
        String selectedText =
            tec.text.substring(selection.start, selection.end);

        // Make the first letter uppercase
        // if (selectedText.isNotEmpty) {
        //   selectedText =
        //       selectedText[0].toUpperCase() + selectedText.substring(1);
        // }

        // Add quotation marks
        //String queryToClipboard =
        //    '#KJVFS# $selectedText'; //adds activation code to python search app that will monitor the clipboard, this will be removed when search is done in Scriptus
        //Clipboard.setData(ClipboardData(text: queryToClipboard));
        print("selection passed");
        searchReturn = kjvFuzzySearch(selectedText, "en", ref, tec);
        print("searchReturn passed to calling function: $searchReturn");
        if (searchReturn[0] != "No results found") {
          Clipboard.setData(ClipboardData(text: searchReturn[1]));
          print(
              "searchReturn passed to Clipboard - 1st result in list: $searchReturn");
        }

        // Replace the selected text with the new text
        //tec.text =
        //    tec.text.replaceRange(selection.start, selection.end, newText);

        // Update the selection to keep it in the correct place
        //tec.selection = TextSelection(
        //  baseOffset: selection.start,
        //  extentOffset: selection.start + newText.length,
        //);
      } else {
        String wholeSegment = tec.text;
        //String queryToClipboard =
        //    '#KJVFS# $wholeSegment'; //adds activation code to python search app that will monitor the clipboard, this will be removed when search is done in Scriptus
        //Clipboard.setData(ClipboardData(text: queryToClipboard));
        print("whole segment passed");
        searchReturn = kjvFuzzySearch(wholeSegment, "en", ref, tec);
        print("searchReturn passed to calling function: $searchReturn");
        if (searchReturn[0] != "No results found") {
          Clipboard.setData(ClipboardData(text: searchReturn[1]));
          print(
              "searchReturn passed to Clipboard - 1st result in list: $searchReturn");
        }
      } //Passes to the search function the whole segment if nothing is selected
      // if (editedSegmentIndex != null) {
      //   final splitIndex = tec.selection.baseOffset;
      //   ref
      //       .read(currentTranscriptProvider.notifier)
      //       .splitSegment(editedSegmentIndex, splitIndex);
      // }
      ref
          .read(currentTranscriptProvider.notifier)
          .updateText(editedSegmentIndex, tec.text);
      TranscriptSegment ts =
          ref.watch(currentTranscriptProvider).segments[editedSegmentIndex];
      ref.read(sentenceProvider.notifier).state = ts;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sentenceState = ref.watch(sentenceProvider);
    // final tec = useTextEditingController(text: sentenceState.text.trim());
    final tecStart = useTextEditingController(text: sentenceState.startTime);
    final tecEnd = useTextEditingController(text: sentenceState.endTime);
    final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
    final player = ref.read(audioPlayerControllerProvider.notifier);
    print('sentenceState.text: ${sentenceState.text}');
    final selectedTranscript = ref.watch(currentTranscriptProvider);
    final clicks = ref.watch(variablemonitorProvider);
    // Create the TextEditingController without setting the initial text.
    final tec = useTextEditingController();
    final settings = ref.watch(settingsProvider);
    print(clicks);
    // Update the TextEditingController's text when the provider's state changes.
    // This side effect runs every time the widget rebuilds.
    if (tec.text != sentenceState.text.trim()) {
      tec.text = sentenceState.text.trim();
      // Set the cursor at the end of the text field.
      // tec.selection = TextSelection.fromPosition(
      //   TextPosition(offset: tec.text.length),
      // );
    }

    void _handleSelectionChanged() {
      // if (ref.watch(editedTextCursorPositionProvider) !=
      //         tec.selection.baseOffset &&
      //     tec.selection.baseOffset != tec.text.length &&
      //     ref.watch(editedTextCursorPositionProvider) != tec.text.length) {
      // final cursorPosition = tec.selection.baseOffset;
      // ref
      //     .read(editedTextCursorPositionProvider.notifier)
      //     .updateTextPosition(tec.selection.baseOffset);
      // // }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(editedTextCursorPositionProvider.notifier)
            .updateTextPosition(tec.selection.baseOffset);
      });
    }

    useEffect(() {
      tec.addListener(_handleSelectionChanged);
      return () => tec.removeListener(_handleSelectionChanged);
    }, [tec]);

    // final sentenceState = ref.watch(sentenceProvider);
    // // final index = ref.watch(editedSegmentIndexProvider);
    // tec.text = sentenceState.text.trim();
    // tecStart.text = sentenceState.startTime;
    // tecEnd.text = sentenceState.endTime;
    // final editedSegmentIndex = ref.watch(editedSegmentIndexProvider);
    // // print(editedSegmentIndex);
    // final player = ref.read(audioPlayerControllerProvider.notifier);
    // // final FocusNode _focusNode = FocusNode();

    // void _handleSelectionChanged() {
    //   print(ref.watch(editedTextCursorPositionProvider));
    //   print(tec.selection.baseOffset);
    //   if (ref.watch(editedTextCursorPositionProvider) !=
    //           tec.selection.baseOffset &&
    //       tec.selection.baseOffset != tec.text.length &&
    //       ref.watch(editedTextCursorPositionProvider) != tec.text.length) {
    //     final cursorPosition = tec.selection.baseOffset;
    //     ref.read(editedTextCursorPositionProvider.notifier).state =
    //         cursorPosition;
    //   }
    // }

    // useEffect(() {
    //   tec.addListener(_handleSelectionChanged);
    //   return () => tec.removeListener(_handleSelectionChanged);
    // }, [tec]);

    return Column(
      children: [
        // Text(ref.watch(editedTextCursorPositionProvider).toString()),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     SizedBox(
        //       width: 100,
        //       child: TextField(
        //         style: const TextStyle(fontSize: 18, fontFamily: 'Courier New'),
        //         controller: tecStart,
        //         minLines: 1,
        //         maxLines: 1,
        //         textAlign: TextAlign.left,
        //         // onSubmitted: (value) => splitCurrentSegment(ref),
        //         // onChanged: (value) =>
        //         //     ref.read(sentenceProvider.notifier).state = sentenceState.state
        //         //       ..text = value,
        //         decoration: const InputDecoration(
        //           isDense: true,
        //           constraints: BoxConstraints.tightFor(width: 100),
        //           fillColor: Colors.black38,
        //         ),
        //       ),
        //     ),
        //     // const SizedBox(width: 10),
        //     SizedBox(
        //       width: 100,
        //       child: TextField(
        //         style: const TextStyle(fontSize: 18, fontFamily: 'Courier New'),
        //         controller: tecEnd,
        //         minLines: 1,
        //         maxLines: 1,
        //         textAlign: TextAlign.left,
        //         // onSubmitted: (value) => splitCurrentSegment(ref),
        //         // onChanged: (value) =>
        //         //     ref.read(sentenceProvider.notifier).state = sentenceState.state
        //         //       ..text = value,
        //         decoration: const InputDecoration(
        //           isDense: true,
        //           constraints: BoxConstraints.tightFor(width: 100),
        //           fillColor: Colors.black38,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),

        TextField(
          style: const TextStyle(fontSize: 22, fontFamily: 'Courier New'),
          controller: tec,
          minLines: 6,
          maxLines: 6,
          decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
          strutStyle: const StrutStyle(
            // fontSize: 18,
            height: 1.4,
          ),
          textAlign: TextAlign.left,
          // onEditingComplete: () {
          //     ref
          //         .read(currentTranscriptProvider.notifier)
          //         .updateText(editedSegmentIndex!, tec.text);
          //     ref.read(sentenceProvider.notifier).updateText(tec.text);
          //     selectedTranscript.exportTranscriptToJson(ref);
          // } ,
          onChanged: (s) {
            ref
                .read(currentTranscriptProvider.notifier)
                .updateText(editedSegmentIndex!, s);
            ref.read(sentenceProvider.notifier).updateText(s);
            selectedTranscript.exportTranscriptToJson(ref);
            DocumentService().exportToHtml(
                selectedTranscript.fileName,
                selectedTranscript.filePath,
                selectedTranscript.segments,
                'de',
                ref);
            DocumentService().exportToHtml(
                selectedTranscript.fileName,
                selectedTranscript.filePath,
                selectedTranscript.segments,
                'sk',
                ref);
          },
          cursorColor: Colors.red[900],
          autofocus: true,
          cursorWidth: 5,
          // onTap: () {
          //   ref
          //       .read(editedTextCursorPositionProvider.notifier)
          //       .updateTextPosition(tec.selection.baseOffset);
          // },

          // onChanged: (value) =>
          //     ref.read(sentenceProvider.notifier).state = sentenceState.state
          //       ..text = value,
          // decoration: const InputDecoration(
          //   labelText: 'Edit sentence',
          // ),
        ),
        // Text(TextGenerationService().generateSegmentText(sentenceState)),
        // Text(ref.watch(editedTextCursorPositionProvider).toString()),
        const SizedBox(height: 5),
        Row(children: [
          // if (index != null)
          //   EdiSegmentButtons(
          //     index: index ?? 0,
          //     ref: ref,
          //     text: 'MG',
          //     onPressed: () => mergeWithPrevious(ref, index),
          //   ),
          EditSegmentButtons(
            // index: editedSegmentIndex ?? 0,
            // ref: ref,
            text: '',
            icon: const Icon(Icons.find_in_page, size: 18),
            tooltip: 'Get Scripture references',
            onPressed: () => callOpenAiApi(ref, tec),
          ),
          const SizedBox(width: 30),
          EditSegmentButtons(
            // index: editedSegmentIndex ?? 0,
            // ref: ref,
            text: '',
            tooltip: 'Connect sentences with comma',
            icon: const Icon(Icons.join_full, size: 16),
            onPressed: () {
              connectWithComma(ref);
            },
          ),
          const VerticalDivider(
            // height: 20,
            color: Colors.white,
            thickness: 10,
            indent: 10,
            endIndent: 10,
          ),
          EditSegmentButtons(
            // index: editedSegmentIndex ?? 0,
            // ref: ref,
            text: '',
            tooltip: 'Split',
            icon: const Icon(Icons.content_cut, size: 16),
            onPressed: () {
              splitCurrentSegment(ref);
            },
          ),
          EditSegmentButtons(
            // index: editedSegmentIndex ?? 0,
            // ref: ref,
            text: '',
            tooltip: 'Split with :',
            icon: const Icon(Icons.splitscreen, size: 16),
            onPressed: () => splitCurrentSegmentAsQuote(ref),
          ),
          EditSegmentButtons(
            // index: editedSegmentIndex ?? 0,
            // ref: ref,
            text: '',
            tooltip: 'Split with .',
            icon: const Icon(Icons.call_split, size: 16),
            onPressed: () => splitCurrentSegmentAsSentence(ref),
          ),
          const Spacer(),
          ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black38),
            ),
            onPressed: (() {
              ref
                  .read(currentTranscriptProvider.notifier)
                  .updateText(editedSegmentIndex!, tec.text);
              ref.read(sentenceProvider.notifier).updateText(tec.text);
            }),
            icon: const Icon(Icons.save, size: 16),
            label: const Text("Save"),
          ),
          const SizedBox(width: 80),
          IconButton(
            // hoverColor: Colors.white,
            // style: ButtonStyle(
            //   backgroundColor: MaterialStateProperty.all<Color>(Colors.black38),
            // ),
            onPressed: (() {
              player.seek(player.state.position - const Duration(seconds: 5));
              // ref.watch(audioPlayerProvider).play();
            }),
            icon: const Icon(Icons.fast_rewind),
            // label: const Text(""),
          ),
          const SizedBox(width: 5),
          FilledButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            onPressed: (() {
              player.seek(durationFromString(sentenceState.startTime));
              ref.watch(audioPlayerProvider).play();
            }),
            // icon: ref.watch(audioPlayerProvider).playing
            //     ? const Icon(Icons.pause)
            //     : const Icon(Icons.play_arrow, size: 16),
            child: const Icon(Icons.start, size: 16),
          ),
          const SizedBox(width: 5),
          Consumer(
            builder: (context, ref, child) {
              return FilledButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                onPressed: (() {
                  // player.seek(durationFromString(sentenceState.startTime));
                  ref.watch(audioPlayerProvider).playing
                      ? ref.watch(audioPlayerProvider).pause()
                      : ref.watch(audioPlayerProvider).play();
                }),
                child: ref.watch(audioPlayerProvider).playing
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow, size: 16),
                // label: const Text("Play"),
              );
            },
          ),
          const SizedBox(width: 5),
          IconButton(
            // style: ButtonStyle(
            //   backgroundColor: MaterialStateProperty.all<Color>(Colors.black38),
            // ),
            onPressed: (() {
              player.seek(player.state.position + const Duration(seconds: 5));
              // ref.watch(audioPlayerProvider).play();
            }),
            icon: const Icon(Icons.fast_forward),
            // label: const Text(""),
          ),
          // Text(ref.watch(editedTextCursorPositionProvider).toString()),
          // Text(ref.watch(keyPressProvider).cmdKeyPressed.toString()),
          // IconButton(
          //   tooltip: 'Save Reference Position',
          //   icon: const Icon(Icons.push_pin),
          //   onPressed: () => saveReferencePosition(ref),
          const SizedBox(width: 10),
          // ),
        ]),
        const SizedBox(height: 5),
        Row(
          children: [
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              // ref: ref,
              onPressed: () => addQuotesBoldandItalic(ref, tec),
              text: '"BI"',
              icon: const Icon(Icons.format_quote),
              tooltip: 'Add Quotes Bold and Italic',
            ),
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              // ref: ref,
              icon: const Icon(Icons.format_quote),
              onPressed: () => addQuotesandItalic(ref, tec),
              tooltip: 'Add Quotes Italic',
              text: '"I"',
            ),
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              // ref: ref,
              onPressed: () => addQuotesandBold(ref, tec),
              icon: const Icon(Icons.format_quote),
              tooltip: 'Add Quotes Bold',
              text: '"B"',
            ),
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              icon: const Icon(Icons.format_quote),
              // ref: ref,
              text: '""',
              tooltip: 'Add Quotes',
              onPressed: () => addQuotes(ref, tec),
            ),
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              icon: const Icon(Icons.format_quote),
              // ref: ref,
              text: '"…"',
              tooltip: 'Add Quotes Small',
              onPressed: () => addQuotesSmall(ref, tec),
            ),
            if (settings.showKJV)
              EditSegmentButtons(
                // index: editedSegmentIndex ?? 0,
                icon: const Icon(Icons.format_quote),
                // ref: ref,
                text: '#KJV',
                tooltip:
                    'Fuzzy search for selected text in KJV to return the verse in the clipboard',
                onPressed: () => KJVsearch(ref, tec),
              ),
            // const VerticalDivider(
            //   // height: 20,
            //   color: Colors.white,
            //   thickness: 10,
            //   indent: 10,
            //   endIndent: 10,
            // ),
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              // ref: ref,
              onPressed: () => addQuotesBoldandItalic(ref, tec, addColon: true),
              text: ':"BI"',
              icon: const Icon(Icons.format_quote),
              tooltip: 'Add Colon & Quotes with Bold and Italic',
            ),
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              // ref: ref,
              icon: const Icon(Icons.format_quote),
              onPressed: () => addQuotesandItalic(ref, tec, addColon: true),
              tooltip: 'Add Colon & Quotes Italic',
              text: ':"I"',
            ),
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              // ref: ref,
              onPressed: () => addQuotesandBold(ref, tec, addColon: true),
              icon: const Icon(Icons.format_quote),
              tooltip: 'Add Colon & Quotes Bold',
              text: ':"B"',
            ),
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              icon: const Icon(Icons.format_quote),
              // ref: ref,
              text: ':""',
              tooltip: 'Add Colon & Quotes',
              onPressed: () => addQuotes(ref, tec, addColon: true),
            ),
            const SizedBox(width: 50),
            EditSegmentButtons(
              // index: editedSegmentIndex ?? 0,
              icon: const Icon(Icons.format_quote),
              // ref: ref,
              text: ': ->A',
              tooltip: 'Add Colon & UpperCase',
              onPressed: () => addColon(ref, tec, addColon: true),
            ),
            const SizedBox(width: 50),
          ],
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text('Places: ${sentenceState.places.length}'),
        // ),
        // IconButton(
        //   icon: const Icon(Icons.save),
        //   onPressed: () {
        //     // editedSegmentIndex != null
        //     //     ? () {
        //     ref
        //         .read(currentTranscriptProvider.notifier)
        //         .updateText(editedSegmentIndex!, tec.text);
        //     ref.read(sentenceProvider.notifier).updateText(tec.text);
        //     // print(editedSegmentIndex);
        //     // print(tec.text);
        //     //   }
        //     // : null;
        //     // final splitIndex = tec.selection.baseOffset;
        //   },
        // ),
        // Text('Edited segment index: $editedSegmentIndex')
        // IconButton(
        //   onPressed: () => ref.read(sentenceProvider.notifier).update((state) =>
        //       TranscriptSegment(
        //           start: sentenceState.start,
        //           end: sentenceState.end,
        //           hasParagraphBreak: sentenceState.hasParagraphBreak,
        //           text: tec.text,
        //           startTime: '',
        //           endTime: '')),
        //   icon: const Icon(Icons.save),
        // ),
      ],
    );
  }
}

class EditSegmentButtons extends StatelessWidget {
  const EditSegmentButtons({
    super.key,
    // required this.ref,
    // required this.index,
    required this.text,
    required this.icon,
    this.color,
    required this.onPressed,
    required this.tooltip,
  });
  // final WidgetRef ref;
  // final int index;
  final Color? color;
  final String text;
  final String tooltip;
  final Icon icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    // bool cmdPressed = false;
    // _focusNode.requestFocus();

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      width: 59,
      child: Consumer(
        builder: (context, ref, child) {
          // final player = ref.read(audioPlayerControllerProvider.notifier);
          // print(ref.watch(editedTextCursorPositionProvider));
          return Tooltip(
            waitDuration: const Duration(seconds: 1),
            message: tooltip == '' ? text : tooltip,
            child: text != ''
                ? TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor:
                          ref.watch(editedTextCursorPositionProvider) >= 0
                              ? Colors.white
                              : Colors.black87,
                    ),
                    onPressed: ref.watch(editedTextCursorPositionProvider) >= 0
                        ? () => onPressed()
                        : null,
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 14),
                    ),
                  )
                : TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black38),
                    ),
                    onPressed: ref.watch(editedTextCursorPositionProvider) >= 0
                        ? () => onPressed()
                        : null,
                    child: icon,
                    // label: const Text(""),
                  ),
          );
        },
      ),
    );
  }
}
