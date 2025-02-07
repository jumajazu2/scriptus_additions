import 'dart:convert';
import 'dart:io';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';
import 'package:id3tag/id3tag.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as path;
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scriptus/audio/audio_player.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:scriptus/extensions/utilities.dart';
import 'package:scriptus/home_page.dart';
import 'package:scriptus/models/bible_verse.dart';
import 'package:scriptus/models/sermon.dart';
import 'package:scriptus/models/transcript_data.dart';
import 'package:scriptus/models/transcript_segment.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/meeting_provider.dart';
import 'package:scriptus/providers/settings_provider.dart';
import 'package:scriptus/services/msk_db_service.dart';
// import 'package:docx_template/docx_template.dart';
import 'package:process_run/process_run.dart';
import 'package:mp3_info/mp3_info.dart';

import '../models/place.dart';

class DocumentService {
  var _json = [];
  // Map<String, dynamic> _json = {};
  // var _hover = [];
  var list = [];
  var _csv = [];
  List<TranscriptSegment> segments = [];
  List<int> paragraphBreaks = [];
  String input = '';
  List paragraphs = List.generate(136, (index) => index * 10000);
  String fileName = '';
  String filePath = '';
  String returnedText = '';

  void importJson3(ref) async {
    _json = [];
    list = [];
    _csv = [];
    segments = [];
    paragraphBreaks = [];
    input = '';
    const segmentCharacterLimit = 500;

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      var f = File(file.path as String);

      try {
        final bytes = await File(file.path as String).readAsBytes();
        input = utf8.decode(bytes, allowMalformed: true);
        // print(content);
      } catch (e) {
        print('An error occurred while reading the file: $e');
      }

      // input = await f.readAsString();
      filePath = file.path as String;

      fileName = file.name;
      Map<String, dynamic> rawJsonData = json.decode(input);

      _json = rawJsonData['transcription'];
      // print(_json);
      // print(_json['segments'][0]['start']);
      // print(_json['segments'][0]['end']);
      // print(_json['segments'][0]['text']);

      String text = '';
      int startTmp = 0;
      String startTimeTmp = '00:00:00';

      // This loop iterates over each element in the _json map.
      // For each element, it processes the text and other data, checking various conditions to
      // determine how to handle each segment of text. It also handles the creation and modification of
      // TranscriptSegment objects, adding them to the segments list.
      // It also handles the splitting of text into paragraphs based on certain conditions.
      // 'index' is the current index of the loop and 'a' is the current value.
      // 'text' is a string that accumulates the text of the current segment.
      // 'start' and 'end' are integers that represent the start and end times of the segment.
      // 'startTime' and 'endTime' are strings that represent the start and end times of the segment in a human-readable format.
      // 'nextText' is a string that holds the text of the next segment in the _json map.
      // 'shouldBeNewParagraph', 'withNextTextIsTooLong', and 'hasEndingCharacter' are booleans used to check certain conditions.
      // 'segment' is a map that holds data about the current segment that will be converted into a TranscriptSegment object.
      // 'startTmp' and 'startTimeTmp' are temporary variables used to hold the start time of a segment while accumulating text.

      // for (var a in _json) {
      List<Map<String, dynamic>> splittedJsonElements =
          _json.expand((jsonPart) {
        // Split the text into sentences
        // List<String> sentences = a['text'].split(RegExp(r'(?<=[.!?])\s+'));

        // for (String sentence in sentences) {
        // List<Map<String, dynamic>> sentencesWithTimestamps =
        return splitIntoSentences(jsonPart).toList();
      }).toList();
      // Now, you can loop through sentencesWithTimestamps and use the text, startTime, and endTime as needed
      // for (var data in sentencesWithTimestamps) {
      print(splittedJsonElements[20]);
      splittedJsonElements.asMap().forEach((index2, sentencePart) {
        // print(sentencePart);
        String sentence = sentencePart['text'];
        Map<String, dynamic> segment = {};
        int start = sentencePart['offsets']['from'];
        int end = sentencePart['offsets']['to'];
        String startTime =
            sentencePart['timestamps']['from'].toString().substring(0, 8);
        String endTime =
            sentencePart['timestamps']['to'].toString().substring(0, 8);
        // print("$start $end $startTime $endTime");
        // String startTime = a['timestamps']['from'].toString().substring(0, 8);
        // String endTime = a['timestamps']['to'].toString().substring(0, 8);
        // String nextText = sentencesWithTimestamps.length == index2 + 1
        // ? ''
        // : sentencesWithTimestamps[index2 + 1]['text'];
        bool shouldBeNewParagraph = ([
          '[music]',
          '[MUSIC]',
          '[Music]',
          '[BLANK_AUDIO]',
          'Brüder und Schwestern'
        ].contains(sentence))
            ? true
            : false;

        // bool withNextTextIsTooLong =
        //     (text.length + sentence.length > segmentCharacterLimit);
        // bool textWillBeTooLong =
        //     (text.length + sentence.length > segmentCharacterLimit);
        bool hasEndingCharacter = sentence.isNotEmpty &&
            [']', '.', '?', '!'].contains(sentence[sentence.length - 1]);

        // if (hasEndingCharacter || withNextTextIsTooLong || shouldBeNewParagraph) {
        // ... [rest of your segment creation code]

        // print(a['text'].forEach((element) => print(element[1])));
        // a['text'].forEach((element) {
        //   text = text + (element[1]);
        // });
        // text = text + a['text'];
        // Map<String, dynamic> segment = {};
        // int start = a['offsets']['from'];
        // int end = a['offsets']['to'];
        // String startTime = a['timestamps']['from'].toString().substring(0, 8);
        // String endTime = a['timestamps']['to'].toString().substring(0, 8);

        String nextText = splittedJsonElements.length == index2 + 1
            ? ''
            : splittedJsonElements[index2 + 1]['text'];
        // bool shouldBeNewParagraph = ([
        //   '[music]',
        //   '[MUSIC]',
        //   '[Music]',
        //   '[BLANK_AUDIO]',
        //   'Brüder und Schwestern'
        // ].contains(a['text']))
        //     ? true
        //     : false;
        bool withNextTextIsTooLong =
            (text.length + nextText.length > segmentCharacterLimit);
        // print('${text.length} ${nextText.length}');
        // bool hasEndingCharacter =
        //     [']', '.', '?', '!'].contains(text[text.length - 1]);
        // print(
        //     ' $withNextTextIsTooLong $hasEndingCharacter $shouldBeNewParagraph');

        // if (text.length < segmentCharacterLimit) {
        // if segment's text ends with punctuation, add to list with break and reset text and TMP start time
        if (withNextTextIsTooLong ||
            (hasEndingCharacter || shouldBeNewParagraph)) {
          text += sentence;
          // jsonPart['text'] = text;
          segment['text'] = text.trim();
          segment['originalText'] = text.trim();
          // jsonPart['start'] = startTmp != 0 ? startTmp : start;
          segment['start'] = startTmp != 0 ? startTmp : start;
          // jsonPart['startTime'] =
          //     startTimeTmp != '00:00:00' ? startTimeTmp : startTime;
          segment['startTime'] =
              startTimeTmp != '00:00:00' ? startTimeTmp : startTime;
          segment['end'] = end;
          segment['endTime'] = endTime;
          // print(segment);
          // print(a['text']);
          // if ([
          //   '[music]',
          //   '[MUSIC]',
          //   '[Music]',
          //   '[BLANK_AUDIO]',
          //   'Brüder und Schwestern'
          // ].contains(a['text'])) {
          //   segment['hasParagraphBreak'] = true;
          //   paragraphBreaks.add(start);
          //   paragraphBreaks.add(end);
          // }
          // if (paragraphs.any((n) => start < n && end > n)) {
          //   segment['hasParagraphBreak'] = true;
          //   paragraphBreaks.add(start);
          // }
          segments.add(TranscriptSegment.fromJson(segment));

          text = '';
          startTmp = 0;
          startTimeTmp = '00:00:00';
        } else {
          text += sentence;
          // jsonPart['text'] = text;
          segment['text'] = text.trim();
          segment['originalText'] = text.trim();
          // jsonPart['start'] = startTmp != 0 ? startTmp : start;
          // segment['start'] = startTmp != 0 ? startTmp : start;
          // jsonPart['startTime'] =
          //     startTimeTmp != '00:00:00' ? startTimeTmp : startTime;
          // segment['startTime'] =
          //     startTimeTmp != '00:00:00' ? startTimeTmp : startTime;
          segment['end'] = end;
          segment['endTime'] = endTime;

          if (startTmp == 0) startTmp = start;
          if (startTimeTmp == '00:00:00') startTimeTmp = startTime;
        }
        // print(a['text']);
        // }
        //     if (startTmp == 0) startTmp = start;
        //     if (startTimeTmp == '00:00:00') startTimeTmp = startTime;
        // text = '';
        // startTmp = 0;
        // startTimeTmp = '00:00:00';
      });
      // });

      // List<Meeting> meetings = ref.watch(meetingsProvider).whenData((value) => value.asMap()).
      // Meeting m = findMeetingWithDate(ref, '2021-05-02') as Meeting;

      // set language to language shortcut based on fileName, english, french, german
      // set language to 'de' if no language is found
      String language = 'de';
      String mp3Language = 'deutsch';
      workingLanguage = language;
      print("Work Lang init: $workingLanguage");
      if (fileName.toLowerCase().contains('french')) {
        language = 'fr';
        workingLanguage = language;
        mp3Language = 'french';
      }
      if (fileName.toLowerCase().contains('english')) {
        language = 'en';
        workingLanguage = language;
        mp3Language = 'english';
      }
      if (fileName.toLowerCase().contains('deutsch')) {
        language = 'de';
        workingLanguage = language;
        mp3Language = 'deutsch';
      }
      print("Work Lang init: $workingLanguage");
      TranscriptData td = ref.watch(currentTranscriptProvider.notifier).state;
      td = td.copyWith(
        originalText: input,
        text: input,
        segments: segments,
        language: language,
        mp3Language: mp3Language,
        filePath: filePath,
        fileName: fileName,
      );

      ref.read(currentTranscriptProvider.notifier).state = td;

      if (ref.watch(selectedMeetingProvider).mp3LinkBase != '') {
        ref.read(audioPlayerControllerProvider).setAudioSource(AudioSource.uri(
            Uri.parse(
                "${ref.watch(selectedMeetingProvider).mp3LinkBase}-$mp3Language.mp3")));
      }
    } else {
      print('canceled');
    }
  }

  /// Splits the given [element] into sentences based on punctuation marks (. ! ? ").
  /// Returns a list of maps, where each map represents a sentence and contains the following keys:
  /// - 'text': The text of the sentence.
  /// - 'timestamps': An object with 'from' and 'to' keys representing the start and end timestamps of the sentence.
  /// - 'offsets': An object with 'from' and 'to' keys representing the start and end offsets of the sentence.
  List<Map<String, dynamic>> splitIntoSentences(Map<String, dynamic> element) {
    String text = element['text'];
    List<String> sentences = text.split(RegExp(r'(?<=[.!?])\s+'));

    if (sentences.length == 1) {
      return [element];
    }

    int totalLength = text.length;
    int accumulatedLength = 0;

    int startOffset = element['offsets']['from'];
    int endOffset = element['offsets']['to'];

    Duration startTime = _parseTime(element['timestamps']['from']);
    Duration endTime = _parseTime(element['timestamps']['to']);
    Duration totalDuration = endTime - startTime;

    List<Map<String, dynamic>> result = [];

    for (String sentence in sentences) {
      int sentenceLength = sentence.length;

      double proportion = sentenceLength / totalLength;
      int sentenceDurationMillis =
          (totalDuration.inSeconds * proportion).round();

      Duration sentenceEndTime =
          startTime + Duration(seconds: sentenceDurationMillis);
      int sentenceEndOffset =
          startOffset + (proportion * (endOffset - startOffset)).round();

      print('$startTime $sentenceDurationMillis $sentenceEndTime');
      result.add({
        'text': sentence,
        'timestamps': {
          'from': _formatTime(startTime),
          'to': _formatTime(sentenceEndTime),
        },
        'offsets': {
          'from': startOffset,
          'to': sentenceEndOffset,
        },
      });

      accumulatedLength += sentenceLength;
      startTime = sentenceEndTime;
      startOffset = sentenceEndOffset;
    }

    return result;
  }

  Duration _parseTime(String time) {
    List<String> parts = time.split(RegExp(r'[:,]'));
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    // String threeDigits(int n) => n.toString().padLeft(3, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  List<Map<String, dynamic>> splitTextIntoSentencesWithTimestamps(
      Map<String, dynamic> a) {
    List<String> sentences = a['text'].split(RegExp(r'(?<=[.!?])\s+'));

    int totalLength = a['text'].length;
    int start = a['offsets']['from'];
    int end = a['offsets']['to'];

    List<Map<String, dynamic>> sentenceData = [];
    int previousEnd = start;

    for (String sentence in sentences) {
      int sentenceLength = sentence.length;

      // Calculate the proportional start and end times for the sentence
      int sentenceStart = previousEnd;
      int sentenceEnd =
          start + ((sentenceLength * (end - start)) / totalLength).round();

      String sentenceStartTime = formatDuration(sentenceStart);
      String sentenceEndTime = formatDuration(sentenceEnd);

      sentenceData.add({
        'text': sentence,
        'startTime': sentenceStartTime,
        'endTime': sentenceEndTime
      });

      previousEnd = sentenceEnd;
    }

    return sentenceData;
  }
  // void exportCsv() async {
  //   List<List<dynamic>> csvData = [
  //     ['start', 'end', 'text'],
  //     // header row
  //     ...segments.map((obj) => [obj.start, obj.end, obj.text]),
  //     // data rows
  //   ];

  //   String csv = const ListToCsvConverter().convert(csvData);

  //   final directoryPath = await FilePicker.platform.getDirectoryPath();
  //   if (directoryPath == null) {
  //     print('No directory selected');
  //     return;
  //   }

  //   final filePath = path.join(directoryPath, 'myFile.csv');
  //   // specify the file path where you want to save the CSV file

  //   final file = File(filePath);
  //   await file.writeAsString(csv);

  //   print('CSV file saved at $filePath');
  // }

  void importJson() async {
    // _json = {};
    _json = [];
    // _hover = [];
    list = [];
    _csv = [];
    segments = [];
    paragraphBreaks = [];
    input = '';
    // const segmentCharacterLimit = 500;

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      // OpenFile.open(file.path);
      var f = File(file.path as String);
      input = await f.readAsString();

      fileName = file.name;

      _json = jsonDecode(input);
      // print(_json);
      // print(_json['segments'][0]['start']);
      // print(_json['segments'][0]['end']);
      // print(_json['segments'][0]['text']);
      // {"start":2300, "end": 3100, "text": [[3, " Blessed"],[4, " be"],[5, " the"],[3, " name"],[7, " of"],[4, " our"],[6, " Lord"],[4, " Jesus"],[4, " Christ"],[4, "."]]},

      // for (var a in _json['segments']) {
      var text = '';
      var startTmp = 0;

      for (var a in _json) {
        // print(a['text'].forEach((element) => print(element[1])));
        a['text'].forEach((element) {
          text = text + (element[1]);
        });
        if ([']', '.', '?', '!'].contains(text[text.length - 1])) {
          a['text'] = text;
          a['start'] = startTmp != 0 ? startTmp : a['start'];
          segments.add(TranscriptSegment.fromJson(a));
          // print(a['text']);
          if ([' [music]', ' [MUSIC]', ' [Music]', ' [BLANK_AUDIO]']
              .contains(a['text'])) {
            paragraphBreaks.add(a['start']);
            paragraphBreaks.add(a['end']);
          }
          if (paragraphs.any((n) => a['start'] < n && a['end'] > n)) {
            paragraphBreaks.add(a['start']);
          }

          text = '';
          startTmp = 0;
        } else {
          if (startTmp == 0) startTmp = a['start'];
        }
        // print(a['text']);
      }
      // print(segments);
      // setState(() {
      //   // list = _json.forEach((key, value) => value);
      // });
      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
      // await rootBundle.loadString(file.path as String);
    } else {
      print('canceled');
    }

    // final String input = await loadAsset();
  }

  void importJson2() async {
    // _json = {};
    _json = [];
    // _hover = [];
    list = [];
    _csv = [];
    // segments = [];
    // paragraphBreaks = [];
    input = '';

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      // OpenFile.open(file.path);
      var f = File(file.path as String);
      input = await f.readAsString();

      fileName = file.name;

      _json = jsonDecode(input);
      // print(_json);
      // print(_json['segments'][0]['start']);
      // print(_json['segments'][0]['end']);
      // print(_json['segments'][0]['text']);
// {"start":2300, "end": 3100, "text": [[3, " Blessed"],[4, " be"],[5, " the"],[3, " name"],[7, " of"],[4, " our"],[6, " Lord"],[4, " Jesus"],[4, " Christ"],[4, "."]]},

      // for (var a in _json['segments']) {
      var text = '';
      var startTmp = 0;

      for (var a in _json) {
        // print(a['text'].forEach((element) => print(element[1])));
        // a['text'].forEach((element) {
        text = text + (a['text']);
        // });
        if ([']', '.', '?', '!'].contains(text[text.length - 1])) {
          a['text'] = text;
          a['start'] = startTmp != 0 ? startTmp : a['start'];
          segments.add(TranscriptSegment.fromJson(a));
          // print(a['text']);
          if ([' [music]', ' [MUSIC]', ' [Music]', ' [BLANK_AUDIO]']
              .contains(a['text'])) {
            paragraphBreaks.add(a['start']);
            paragraphBreaks.add(a['end']);
          }
          if (paragraphs.any((n) => a['start'] < n && a['end'] > n)) {
            paragraphBreaks.add(a['start']);
          }

          text = '';
          startTmp = 0;
        } else {
          if (startTmp == 0) startTmp = a['start'];
        }
        // print(a['text']);
      }
      // print(segments);
      // setState(() {
      //   // list = _json.forEach((key, value) => value);
      // });
      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
      // await rootBundle.loadString(file.path as String);
    } else {
      print('canceled');
    }

    // final String input = await loadAsset();
  }

  /// CSV exported from Whisper does not have " escaped
  /// therefore it must be first replaced with other character
  void importCSV() async {
    var d = const FirstOccurrenceSettingsDetector(
      eols: ['\r\n', '\n'],
      // textDelimiters: ['"'],
      // textEndDelimiters: ['≥'],
    );

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      // OpenFile.open(file.path);
      var f = File(file.path as String);
      input = await f.readAsString();

      fileName = file.name;

      // final String input = await loadAsset();
      // var a = File(
      //         '/Volumes/DEVEL/AI/scriptus/assets/2023-03-18-1984-12-29-1000-Krefeld-english.mp3.csv')
      //     .openRead();
      // final fields = input
      //     // .transform(utf8.decoder)
      //     .transform(new CsvToListConverter())
      //     .toList();
      // print(input);
      final res =
          const CsvToListConverter().convert(input, csvSettingsDetector: d);
      print(res.length);
      res.removeAt(0);
      print(res[0]);
      print(res[1]);

      // setState(() {
      _csv = res;
      // });
    }
  }

  void _jsonToDelta() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      // OpenFile.open(file.path);
      var f = File(file.path as String);
      input = await f.readAsString(encoding: utf8);

      _json = jsonDecode(input);
      // print(_json);
// [
//   {
//     "insert": "Flutter Quill"
//   },
//   {
//     "attributes": {
//       "header": 1
//     },
//     "insert": "\n"
//   },
//   {
//     "insert": "\nRich text editor for Flutter"
//   },]

      var text = '';
      List jsonForDelta = [];
      // var startTmp = 0;

      for (var a in _json) {
        // print(a['text'].forEach((element) => print(element[1])));
        a['text'].forEach((element) {
          text = text + (element[1]);
        });
        if ([']', '.', '?', '!'].contains(text[text.length - 1])) {
          a['text'] = text;
          jsonForDelta.add({"insert": text.trim()});
          // a['start'] = startTmp != 0 ? startTmp : a['start'];
          // segments.add(TranscriptSegment.fromJson(a));
          // print(a['text']);
          if ([' [music]', ' [Music]', ' [BLANK_AUDIO]'].contains(a['text'])) {
            jsonForDelta.add({"insert": '\n'});
            // paragraphBreaks.add(a['start']);
            // paragraphBreaks.add(a['end']);
          }
          // if (paragraphs.any((n) => a['start'] < n && a['end'] > n)) {
          //   paragraphBreaks.add(a['start']);
          // }
          jsonForDelta.add({"insert": '\n'});

          text = '';
          // startTmp = 0;
        } else {
          // if (startTmp == 0) startTmp = a['start'];
        }
        // print(a['text']);
      }
      // final doc = q.Document.fromDelta(delta);
      // final doc = q.Document.fromJson(jsonForDelta);

      // print(segments);
      // setState(() {
      //   _controller = q.QuillController(
      //     document: doc,
      //     selection: const TextSelection.collapsed(offset: 0),
      //   );

      //   // list = _json.forEach((key, value) => value);
      // });
      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
      // await rootBundle.loadString(file.path as String);
    } else {
      print('canceled');
    }
  }

  void exportCsv(segments) async {
    List<List<dynamic>> csvData = [
      ['start', 'end', 'text'],
      // header row
      ...segments.map((obj) => [obj.start, obj.end, obj.text]),
      // data rows
    ];

    String csv = const ListToCsvConverter().convert(csvData);

    final directoryPath = await FilePicker.platform.getDirectoryPath();
    if (directoryPath == null) {
      print('No directory selected');
      return;
    }

    final filePath = path.join(directoryPath, 'myFile.csv');
    // specify the file path where you want to save the CSV file

    final file = File(filePath);
    await file.writeAsString(csv);

    print('CSV file saved at $filePath');
  }

  // Future<void> copyToClipboardHtml(
  //     List<TranscriptSegment> segments, language) async {
  //   final htmlText = await generateHtml(segments, language,ref);
  //   copyToClipboard(htmlText);
  // }

  Future<String> generateHtmlJs(List<TranscriptSegment> segments) async {
    final sb = StringBuffer();

    sb.write('''<!DOCTYPE html>
        <html>
          <head>
            <meta charset="UTF-8"> 
              <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> 
              <script>

              // Load the color scheme from localStorage
              var savedColorScheme = localStorage.getItem('colorScheme');
              if (savedColorScheme) {
                  \$('#color-scheme').val(savedColorScheme);
                  \$('body').attr('class', savedColorScheme);
              }
              \$(document).ready(function() { 
                \$('#show-german-references, #show-english-references').change(function() { var language = \$(this).attr('id').split('-')[1]; if (\$(this).is(':checked')) { \$('.' + language + '-text').css({'display': 'block', 'width': '300px'}); \$('.text').css('width', 'calc(100% - 300px)'); } else { \$('.' + language + '-text').css('display', 'none'); if (!\$('#show-german-references').is(':checked') && !\$('#show-english-references').is(':checked')) { \$('.text').css('width', '100%'); } } }); 
                \$('.bible-reference').hover(function() { var germanReference = \$(this).data('german'); var englishReference = \$(this).data('english'); \$(this).append('<div class="hover-text">' + germanReference + '<br>' + englishReference + '</div>'); }, function() { \$(this).find('.hover-text').remove(); });  

                \$('#color-scheme').change(function() {
                    var colorScheme = \$(this).val();
                    \$('body').attr('class', colorScheme);

                    // Save the color scheme to localStorage
                    localStorage.setItem('colorScheme', colorScheme);
                });
            });
            </script> 
            <style>
              body {
                  font-family: 'Courier New', Courier, monospace;
                  color: white;
                  padding-left: 10px;
                  padding-top: 40px;
                  background-color: black;
              }
              body.scheme1 {
                  background-color: #f0f0f0;
                  color: #333;
              }

              body.scheme2 {
                  background-color: #333;
                  color: #f0f0f0;
              }

              body.scheme3 {
                  background-color: #ffffff;
                  color: #000000;
              }

              body.scheme4 {
                  background-color: #000000;
                  color: #ffff00;
              }

              body.scheme5 {
                  background-color: #000080;
                  color: #ffffff;
              }

              body.scheme6 {
                  background-color: #800000;
                  color: #ffffff;
              }

              body.scheme7 {
                  background-color: #808000;
                  color: #000000;
              }

              body.scheme8 {
                  background-color: #008080;
                  color: #ffffff;
              }

              body.scheme9 {
                  background-color: #000080;
                  color: #ffffff;
              }

              body.scheme10 {
                  background-color: #800080;
                  color: #ffffff;
              }

              #button-bar {
                  position: fixed;
                  top: 10px;
                  width: 100%;
                  margin-bottom: 30px;
                  background-color: black; /* Add a background color to make the text readable */
                  z-index: 100; /* Optional: This ensures the button bar stays above other elements */
              }

              .paragraph {
                  display: flex;
                  /* align-items: flex-start;  */
                  margin-bottom: 10px;
              }

              .text, .scripture-text {
                  margin-right: 20px;
                  /* margin-top: 0px; */
                  display: flex;
                  flex-direction: column;
                  justify-content: flex-start;
                  align-items: flex-start;
                  /* width: 300px; */
              }

              .quotedScripture {
                color: black;
              }

              .bible-reference {
                  color: yellow;
                  position: relative;
                  cursor: pointer;
              }

              .hover-text {
                  position: absolute;
                  top: 100%;
                  background-color: white;
                  color: black;
                  padding: 10px;
                  /* width: 400px; */
                  border: 1px solid black;
                  white-space: wrap;
              }

              .scripture-text {
                  display: none;
                  background-color: white;
                  color: black;
                  padding: 10px;
                  border: 1px solid black;
              }
              .wb {
                color:red;
              }
              .song {
                color: green;
              }
          </style>
        </head>
        <body>
          <div id="button-bar">
              <input type="checkbox" id="show-german-references">SHOW GERMAN REFERENCES
              <input type="checkbox" id="show-english-references">SHOW ENGLISH REFERENCES
              <select id="color-scheme">
                <option value="default">Default</option>
                <option value="scheme1">Scheme 1</option>
                <option value="scheme2">Scheme 2</option>
                <option value="scheme3">Scheme 3</option>
                <option value="scheme4">Scheme 4</option>
                <option value="scheme5">Scheme 5</option>
                <option value="scheme6">Scheme 6</option>
                <option value="scheme7">Scheme 7</option>
                <option value="scheme8">Scheme 8</option>
                <option value="scheme9">Scheme 9</option>
                <option value="scheme10">Scheme 10</option>
            </select>

          </div>
          <div id="sermon-text">
        ''');

    // for (final segment in segments) {
    segments.asMap().forEach((index, segment) {
      sb.write('<div class="paragraph">');

      if (index > 1 &&
          segment.isBrRuss &&
          segments[index - 1].isBrRuss == false) {
        sb.write('<b>Bruder Russ</b><br>');
      }
      if (index == 0 && segment.isBrRuss) {
        sb.write('<b>Bruder Russ</b><br>');
      }

      if (index > 1 &&
          segment.isBrRuss == false &&
          segments[index - 1].isBrRuss) {
        sb.write('<b>Bruder Frank</b><br>');
      }

      if (segment.isScripture) {
        // sb.write('<b><i>'); // Start bold and italic in HTML
      }

      if (segment.isSong) {
        sb.write('<blockquote class="song">'); // Start bold and italic in HTML
      }

      if (segment.isWBQuote) {
        sb.write('<blockquote class="wb">'); // Start bold and italic in HTML
      }

      // if (language == 'de') {
      sb.write('''<div class="text">
                    <p>${segment.text}''');

      if (segment.assignedScripture != null) {
        sb.write(
            '''       <span class="bible-reference" data-german="${segment.assignedScripture!.content}" data-english="">[${segment.assignedScripture!.reference}]</span>
            ''');
      }
      if (segment.places.isNotEmpty) {
        for (Place p in segment.places) {
          if (p.language == 'de') {
            sb.write('''
                <div class="scripture-text german-text"> ${p.verseText} </div>
            ''');
          } else {
            sb.write('''
                <div class="scripture-text english-text"> English ${p.verseText} </div>
            ''');
          }
        }
        sb.write('</p> </div>');

        // sb.write(
        //          ''' <div class="scripture-text german-text"> ${segment.assignedScripture!.content} </div>
        //           <div class="scripture-text english-text"> English ${segment.assignedScripture!.content} </div>
        //     ''');
      } else {
        sb.write('''</p>
                  </div>
        ''');
      }

      if (segment.isWBQuote || segment.isSong) {
        sb.write('</blockquote>'); // Start bold and italic in HTML
      }

      // if (segment.isSong) {
      //   sb.write('</blockquote>');
      // }

      // if (segment.isScripture) {
      // sb.write('</i></b>'); // End bold and italic in HTML
      // }

      // if (segment.hasParagraphBreak) {
      sb.write('</div></div>'); // Paragraph break in HTML
      // } else {
      //   sb.write(' '); // Space between segments in the same paragraph
      // }
    });

    sb.write(
        '<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script></body></html>');

    final htmlText = sb.toString();

    return htmlText;
  }

  Future<void> exportToWord(String fileName, String filePath,
      List<TranscriptSegment> segments, String language, ref) async {
    try {
      String reference_docx = 'custom-reference-deutsch.docx';
      fileName = fileName.replaceAll('.wav.json', '');
      // replace deutsch with slovak or english or deutsch according to language parameter
      if (language == 'sk') {
        fileName = fileName.replaceAll('deutsch', 'slovak');
        reference_docx = 'custom-reference-slovak.docx';
      } else if (language == 'en') {
        fileName = fileName.replaceAll('deutsch', 'english');
        reference_docx = 'custom-reference-english.docx';
      }

      // Get temporary directory that the app has access to
      final tempDir = await getTemporaryDirectory();
      final tempHtmlPath = '${tempDir.path}/$fileName.html';
      final tempDocxPath = '${tempDir.path}/$fileName.docx';

      // Generate HTML content
      final htmlText = await generateHtml(segments, filePath, language, ref);

      // Save HTML to temporary location
      await File(tempHtmlPath).writeAsString(htmlText);

      // Run pandoc command using temporary paths
      var shell = Shell(workingDirectory: tempDir.path);
      await shell.run(
          '/opt/homebrew/bin/pandoc -f html -t docx "$tempHtmlPath" -o "$tempDocxPath" --reference-doc=/Users/miro/$reference_docx');

      // Copy the generated DOCX to Downloads
      final downloadsPath = await getDownloadsDir();
      final finalPath = '$downloadsPath/$fileName.docx';
      await File(tempDocxPath).copy(finalPath);

      // Clean up temporary files
      await File(tempHtmlPath).delete();
      await File(tempDocxPath).delete();
    } catch (e) {
      print('Error converting file: $e');
      rethrow;
    }
  }

  String extractSermonTitle(String filePath, String language) {
    // MP3Info mp3 = MP3Processor.fromFile(File(filePath));

    final parser = ID3TagReader.path(filePath);
    final tag = parser.readTagSync();
    // print(broadcastDate.toString().substring(0, 10));
    // print(tag.comment?.comment);
    // print(tag.frameDictionaries);

    String cleanTitle = tag.comment?.comment ?? '';
    // if cleanTitle is empty, extract title from file name
    // if (cleanTitle == '') {
    //   print('no title found in id3 tag');
    //   // cleanTitle = extractFileInfo(file.path)['title'];
    // }
    // print(filePath);
    // print(cleanTitle);

    // String cleanTitle = title == '' ? tag.title ?? '' : title;
    cleanTitle = cleanTitle.replaceAll('"', '');
    // remove line breaks from title
    cleanTitle = cleanTitle.replaceAll('\n', '');
    if (language == 'deutsch') {}
    // print(cleanTitle);

    return cleanTitle;
  }

  Future<String> generateHtml(List<TranscriptSegment> segments, String filePath,
      String language, ref) async {
    final selectedTranscript = ref.watch(currentTranscriptProvider);
    // print(selectedTranscript.filePath);
    // print(selectedTranscript.fileName);
    // strip filename
    String dirName = selectedTranscript.fileName.split('.').first;
    // remove trailing city and language info, starting with deutsch
    dirName = dirName.replaceAll(RegExp(r'-deutsch|-english'), '');
    String fileName = selectedTranscript.fileName.split('.').first;
    // remove first 13 characters
    fileName = fileName.substring(13);
    final String transferredDir = '/Users/miro/Downloads/transferred/';
    String mp3filePath = '$transferredDir$dirName\\$fileName.mp3';
    // final audioPlayer = ref.watch(audioPlayerProvider);
    // final mp3url = audioPlayer.audioSource.uri.toString();
    // extract filename from mp3 url
    // final mp3path = mp3url.split('/').last;
    // get path to mp3 file in app support directory
    // final appSupportDir = await getApplicationSupportDirectory();
    // final mp3filePath = '${appSupportDir.path}/$mp3path';
    //print(mp3filePath);

    final sb = StringBuffer();
    MskDBProvider mskDBProvider = MskDBProvider();
    String title = '';
    if (Platform.isMacOS) {
      title = extractSermonTitle(
          mp3filePath, language); //for Mac, use original code
    } else if (Platform.isWindows) {
      title =
          '–'; //for Windows skip extractSermonTitle(mp3filePath, language) because it does not work, reference to transferredDir does not exist on my system
    } else {
      title =
          '–'; //for other systems skip as reference to transferredDir likely will not exist
    }

    String broadcastDate = dirName.substring(0, 10);
    String preachedOn = fileName.substring(0, 10);
    String preachedAt = fileName.substring(11, 15);
    // format preachedAt to be 12:00
    print(preachedAt);
    // Convert 24 hour time to 12 hour format with AM/PM
    int hour = int.parse(preachedAt.substring(0, 2));
    int minute = int.parse(preachedAt.substring(2));
    // String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour > 12 ? hour - 12 : hour;
    hour = hour == 0 ? 12 : hour;
    preachedAt =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ';
    print(preachedAt);

    sb.write('<!DOCTYPE html><html><head><meta charset="UTF-8"></head>');
    sb.write('<body>');
    sb.write('<h2>Ewald Frank</h2>');
    sb.write('<h2>$preachedOn $preachedAt</h2>');
    sb.write('<h2>$broadcastDate</h2>');
    sb.write('<h2>$title</h2>');

    // for (final segment in segments) {
    // segments.asMap().forEach((index, segment) async {
    for (int index = 0; index < segments.asMap().length; index++) {
      TranscriptSegment segment = segments[index];
      sb.write('<p>');

      if (index > 1 &&
          segment.isBrRuss &&
          segments[index - 1].isBrRuss == false) {
        sb.write('<b>Bruder Russ</b><br>');
      }
      if (index == 0 && segment.isBrRuss) {
        sb.write('<b>Bruder Russ</b><br>');
      }

      if (index > 1 &&
          segment.isBrRuss == false &&
          segments[index - 1].isBrRuss) {
        sb.write('<b>Bruder Frank</b><br>');
      }

      if (segment.isScripture) {
        sb.write('<b><i>'); // Start bold and italic in HTML
      }

      if (segment.isSong) {
        sb.write(
            '<blockquote style="background-color:#eee;text-indent: 100px; text-align: center;"><i>'); // Start bold and italic in HTML
      }

      if (segment.isWBQuote) {
        sb.write(
            '<blockquote style="background-color:#eee;text-indent: 50px;"><b>'); // Start bold and italic in HTML
      }

      if (language == 'de') {
        // print("language: $language");
        // replace "" with " in text"
        sb.write(segment.text);
      } else {
        // print(segment.assignedScripture);
        if (segment.isScripture && segment.assignedScripture != null) {
          // sb.write("isscripture");
          // add error handling if no verse found
          try {
            // print("segment.assignedScripture1: ${segment.assignedScripture}");
            BibleVerse otherLanguage =
                await mskDBProvider.getVerseInOtherLanguage(
                    Place.fromBibleVerse(segment.assignedScripture!), language);
            // print("segment.assignedScripture2: $otherLanguage");
            if (ref.watch(settingsProvider).exportHtmlWithOriginalVerse) {
              sb.write("<u>${segment.text}</u> <br>");
            } else {
              sb.write(otherLanguage.content);
            }

            sb.write("(${otherLanguage.verse}) ${otherLanguage.content}");
          } catch (e) {
            // print("Error: $e");
            sb.write("Error in Other Language Bible Verse: $e");
          }
        } else {
          // print("not scripture && assignedScripture not null");
          if (segment.textSk != '') {
            sb.write(segment.textSk);
          } else {
            sb.write(segment.text);
          }
        }
      }

      if (segment.isWBQuote) {
        sb.write('</b></blockquote>'); // Start bold and italic in HTML
      }

      if (segment.isSong) {
        sb.write('</blockquote></i>');
      }

      if (segment.isScripture) {
        sb.write('</i></b>'); // End bold and italic in HTML
      }

      // if (segment.hasParagraphBreak) {
      sb.write('</p>'); // Paragraph break in HTML
      // add a small space between paragraphs for german language
      if (language == 'de') {
        sb.write('<p><span style="height: 10px;"></span></p>');
      }
      // } else {
      //   sb.write(' '); // Space between segments in the same paragraph
      // }
    }

    sb.write('</p></body></html>');

    final String htmlText = sb.toString().replaceAll('""', '"');
    // final htmlText = sb.toString();

    return htmlText;
  }

  Future<String> getDownloadsDir() async {
    try {
      // Get the user's home directory path.
      final directory = await getApplicationSupportDirectory();
      // final homeDirectoryPath = join(
      //     directory.path, '..', '..', '..', '..', '..', '..', '..', '..', '..');
      final parts = directory.path.split('/');

      String homeDirectoryPath = '';

      // Check if there are enough parts to extract
      if (parts.length >= 2) {
        // Join the first three parts with a slash
        homeDirectoryPath = '/' + parts.sublist(1, 3).join('/');
        print(homeDirectoryPath); // Outputs: /Users/miro/Library
      } else {
        print('Not enough parts to extract');
      }
      // Construct the path to the Downloads directory.
      final downloadsDirectoryPath = join(homeDirectoryPath, 'Downloads');
      final downloadsDirectory = Directory(downloadsDirectoryPath);
      print(downloadsDirectory);

      // Check if the Downloads directory exists, if not, throw an error.
      if (!await downloadsDirectory.exists()) {
        throw Exception('Downloads directory does not exist');
      }
      return downloadsDirectoryPath;
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }

  Future<void> exportToHtml(fileName, filePath,
      List<TranscriptSegment> segments, language, ref) async {
    // final ctp = ref.watch(currentTranscriptProvider);

    final htmlText = await generateHtml(segments, filePath, language, ref);

    // Show the file save dialog
    // final saveFileResultPath = await FilePicker.platform.saveFile(
    //   // lockParentWindow: true,
    //   // initialDirectory: filePath,
    //   fileName: '$fileName-$language.html',
    //   dialogTitle: 'Save the HTML file',
    //   // type: FileType.custom,
    //   // allowedExtensions: ['html'],
    // );

    String saveFileResultPath = await getDownloadsDir();

    if (saveFileResultPath != null) {
      // remove .wav.json from filename
      fileName = fileName.replaceAll('.wav.json', '');
      // replace deutsch with slovak or english or deutsch according to language parameter
      if (language == 'sk') {
        fileName = fileName.replaceAll('deutsch', 'slovak');
      } else if (language == 'en') {
        fileName = fileName.replaceAll('deutsch', 'english');
      }
      final file = File('$saveFileResultPath/$fileName.html');
      await file.writeAsString(htmlText);
    }
  }

  Future<void> exportToHtmlJs(
      fileName, filePath, List<TranscriptSegment> segments) async {
    // final ctp = ref.watch(currentTranscriptProvider);

    final htmlText = await generateHtmlJs(segments);

    // Show the file save dialog
    final saveFileResultPath = await FilePicker.platform.saveFile(
      initialDirectory: filePath,
      fileName: '$fileName-js.html',
      dialogTitle: 'Save the HTML file',
      type: FileType.custom,
      allowedExtensions: ['html'],
    );

    if (saveFileResultPath != null) {
      final file = File(saveFileResultPath);
      await file.writeAsString(htmlText);
    }
  }

  Future<void> exportToMarkdown(ref, List<TranscriptSegment> segments) async {
    final sb = StringBuffer();
    final ctp = ref.watch(currentTranscriptProvider);
    // final filePath = ref.read(currentTranscriptProvider).filePath;

    for (final segment in segments) {
      if (segment.isScripture) {
        sb.write('*_'); // Start bold and italic in Markdown
      }

      sb.write(segment.text);

      if (segment.isScripture) {
        sb.write('_*'); // End bold and italic in Markdown
      }

      if (segment.hasParagraphBreak) {
        sb.write('\n\n'); // Paragraph break in Markdown
      } else {
        sb.write(' '); // Space between segments in the same paragraph
      }
    }

    final markdownText = sb.toString();

    // Show the file save dialog
    final saveFileResultPath = await FilePicker.platform.saveFile(
      initialDirectory: ctp.filePath,
      dialogTitle: 'Save the Markdown file',
      fileName: '${ctp.fileName}.md',
      type: FileType.custom,
      allowedExtensions: ['md'],
    );

    if (saveFileResultPath != null) {
      final file = File(saveFileResultPath);
      await file.writeAsString(markdownText);
    }
  }
}

// import 'package:docx/docx.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:scriptus/models/transcript_segment.dart';

// class DocumentService {
//   Future<void> exportToWord(List<TranscriptSegment> segments) async {
//     final doc = Document();

//     // ... create the document ...

//     // Show the file save dialog
//     final file = await FilePicker.platform.saveFile(
//       dialogTitle: 'Save the Word document',
//       type: FileType.custom,
//       allowedExtensions: ['docx'],
//     );

//     if (file != null) {
//       await file.writeAsBytes(doc.save());
//     }
//   }
// }

// docx_template version
// import 'package:docx_template/docx_template.dart';

// void createWordDocument(List<TranscriptSegment> segments) async {
//   final docx = await DocxTemplate.fromBytes(await rootBundle.load("assets/template.docx"));

//   final content = Content();
//   for (var i = 0; i < segments.length; i++) {
//     final segment = segments[i];
//     content
//       ..add(TextContent("segment", segment.text));
//   }

//   final d = await docx.generate(content);
//   final file = File("path/to/your/file.docx");
//   await file.writeAsBytes(await d.save());
// }
