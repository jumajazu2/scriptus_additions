import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scriptus/audio/audio_player.dart';
import 'package:scriptus/extensions/deepl_service.dart';
import 'package:scriptus/extensions/text_cleaner.dart';
import 'package:scriptus/extensions/utilities.dart';
import 'package:scriptus/models/bible_verse.dart';
import 'package:scriptus/models/meeting.dart';
import 'package:scriptus/models/place.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/meeting_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/repositories/places_repo.dart';
import 'package:scriptus/services/meeting_service.dart';
import 'package:scriptus/services/mng_database_service.dart';
import 'package:tuple/tuple.dart';
import 'transcript_segment.dart';
// import 'package:path/path.dart' as path;

part 'transcript_data.freezed.dart';
part 'transcript_data.g.dart';

@freezed
// @DataRepository([JsonApiAdapter])
class TranscriptData //extends DataModel<TranscriptData>
    with
        _$TranscriptData {
  TranscriptData._();

  factory TranscriptData({
    int? id,
    required final String text,
    required final String originalText,
    required final String fileName,
    required final String filePath,
    required final List<TranscriptSegment> segments,
    required final String language,
    required final String mp3Language,
    required final int meetingId,
    @Default(0) final int offsetSeconds,
    // required HasMany<TranscriptSegment> transcriptSegments,
  }) = _TranscriptData;

  factory TranscriptData.fromJson(Map<String, dynamic> json) =>
      _$TranscriptDataFromJson(json);

  Future<void> exportTranscriptToJson(WidgetRef ref) async {
    final transcriptData = ref.read(currentTranscriptProvider);
    final Map<String, dynamic> transcriptDataMap = transcriptData.toJson();
    final String transcriptDataJson = jsonEncode(transcriptDataMap);
    // String dirName = path.basename(path.dirname(filePath));

    // final file = File('${transcriptData.filePath}-tmp.json');

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
      print(homeDirectoryPath);
      print(downloadsDirectory);

      // Check if the Downloads directory exists, if not, throw an error.
      if (!await downloadsDirectory.exists()) {
        throw Exception('Downloads directory does not exist');
      }

      // Create a File object with the correct path and write the content to it.
      // final file = File(join(downloadsDirectory.path, fileName));
      // await file.writeAsString(content);
      print(transcriptData.fileName);
      final file = File(
          join(downloadsDirectory.path, '${transcriptData.fileName}-tmp.json'));
      await file.writeAsString(transcriptDataJson);
      print('File saved to ${file.path}');
    } catch (e) {
      print('Error saving file: $e');
    }

    // return transcriptDataJson;
  }

  /// Asynchronously loads a transcript from a JSON file.
  ///
  /// This method opens a file picker dialog to allow the user to select a JSON file.
  /// The JSON file is then parsed into a `TranscriptData` object, and the current
  /// transcript provider state is updated to this new object.
  ///
  /// If the `TranscriptData` object has a non-zero `meetingId`, the meeting with
  /// this ID is found and selected. The audio source for the audio player controller
  /// is then updated to the MP3 link of the selected meeting.
  ///
  /// If no file is selected in the file picker, an exception is thrown.
  ///
  /// @param ref A `WidgetRef` object.
  ///
  /// @throws An `Exception` if no file is selected.
  /// @throws A `RangeError` if the `meetingId` of the `TranscriptData` object is out of range.
  ///
  /// @return A `Future` that completes when the loading and parsing of the JSON file is done.
  Future<void> loadTranscriptFromJson(WidgetRef ref) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) {
      return;
    }

    File file = File(result.files.single.path!);
    final String transcriptDataJson = await file.readAsString();
    final Map<String, dynamic> transcriptDataMap =
        jsonDecode(transcriptDataJson);
    TranscriptData td = TranscriptData.fromJson(transcriptDataMap);
    ref.read(currentTranscriptProvider.notifier).state = td;

    final meetingsAsyncValue = ref.read(meetingsProvider);

    Meeting m;
    // Check if the data is available
    if (meetingsAsyncValue is AsyncData<List<Meeting>>) {
      List<Meeting> ms = meetingsAsyncValue.value;
      try {
        m = ms.firstWhere((element) => element.id == td.meetingId);
      } catch (e) {
        throw RangeError('Meeting ID not found');
      }
    } else {
      // Handle other states if necessary
      return;
    }

    // AsyncData<List<Meeting>> meetingData = ref.watch(meetingsProvider);
    // if (!meetingData.hasValue || td.meetingId == 0) {
    //   return;
    // }

    // List<Meeting> ms = meetingData.value;
    // try {
    //   m = ms.firstWhere((element) => element.id == td.meetingId);
    // } catch (e) {
    //   throw RangeError('Meeting ID not found');
    // }
    String lang = ref.watch(currentTranscriptProvider).mp3Language;

    ref.read(selectedMeetingProvider.notifier).setMeeting(m);
    ref.read(audioPlayerControllerProvider).setAudioSource(AudioSource.uri(
        Uri.parse(
            "${ref.watch(selectedMeetingProvider).mp3LinkBase}-$lang}.mp3")));
  }

  TranscriptData mergeWithPrevious(int index) {
    if (index <= 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    final currentSegment = segments[index];
    final previousSegment = segments[index - 1];

    final mergedSegment = previousSegment.copyWith(
      text: '${previousSegment.text} ${currentSegment.text}',
      originalText: '${previousSegment.originalText} ${currentSegment.text}',
      end: currentSegment.end,
      endTime: currentSegment.endTime,
    );
    // TranscriptSegment(
    //   // Merge the properties of the two segments
    //   text: previousSegment.text + ' ' + currentSegment.text,
    //   start: previousSegment.start,
    //   startTime: previousSegment.startTime,
    //   end: currentSegment.end,
    //   endTime: currentSegment.endTime,
    //   // Add other properties as needed
    // );

    // Create a new list with the merged segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments.removeAt(index);
    newSegments[index - 1] = mergedSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData mergeWithPreviousWithComma(int index) {
    if (index <= 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    final currentSegment = segments[index];
    final previousSegment = segments[index - 1];

    String newText = '';

    // if the first word in current segment is one of words in the list, don't capitalize it
    List<String> wordsToNotCapitalize = ['Gott', 'Jesus', 'Christus'];
    // get firsrt word of current segment
    String firstWord = currentSegment.text.split(' ')[0];
    // check if it's in the list
    if (wordsToNotCapitalize.contains(firstWord)) {
      newText =
          '${previousSegment.text.substring(0, previousSegment.text.length - 1)}, ${currentSegment.text}';
    } else {
      newText =
          '${previousSegment.text.substring(0, previousSegment.text.length - 1)}, ${currentSegment.text[0].toLowerCase() + currentSegment.text.substring(1)}';
    }

    final mergedSegment = previousSegment.copyWith(
      text: newText,
      originalText:
          '${previousSegment.originalText} ${currentSegment.originalText}',
      end: currentSegment.end,
      endTime: currentSegment.endTime,
    );

    // Create a new list with the merged segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments.removeAt(index);
    newSegments[index - 1] = mergedSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData addFoundVersesToSegment(int index, newVerses) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }
    final currentSegment = segments[index];

    // var allScriptures = currentSegment.foundScriptures;
    // allScriptures.addAll(newVerses);

    final newSegment = currentSegment.copyWith(
      foundScriptures: newVerses,
    );

    // Create a new list with the toggled segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = newSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData setAllWBQ() {
    final newSegments = segments.map((e) {
      return e.copyWith(isWBQuote: false);
    }).toList();

    return copyWith(segments: newSegments);
  }

  TranscriptData toggleIsScripture(int index) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // Create a new segment with the toggled isScripture attribute
    final segment = segments[index];
    final toggledSegment = segment.copyWith(
      isScripture: !segment.isScripture,
    );

    // Create a new list with the toggled segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = toggledSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData toggleIsBrRuss(int index) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // Create a new segment with the toggled isScripture attribute
    final segment = segments[index];
    final toggledSegment = segment.copyWith(
      isBrRuss: !segment.isBrRuss,
    );

    // Create a new list with the toggled segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = toggledSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData toggleIsSong(int index) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // Create a new segment with the toggled isScripture attribute
    final segment = segments[index];
    final toggledSegment = segment.copyWith(
      isSong: !segment.isSong,
    );

    // Create a new list with the toggled segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = toggledSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData toggleIsWBQuote(int index) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // Create a new segment with the toggled isScripture attribute
    final segment = segments[index];
    final toggledSegment = segment.copyWith(
      isWBQuote: !segment.isWBQuote,
    );

    // Create a new list with the toggled segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = toggledSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData setMeetingId(int meetingId) {
    // Return a new TranscriptData object with the new list
    return copyWith(meetingId: meetingId);
  }

  TranscriptData setOffsetSeconds(int o) {
    return copyWith(offsetSeconds: o);
  }

  TranscriptData assignBibleVerse(int index, BibleVerse bv) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }
    final segment = segments[index];
    final newSegment = segment.copyWith(assignedScripture: bv);

    // print('assignBibleVerse');
    // print(newSegment.assignedScripture!.bookAbb);

    // Create a new list with the toggled segment
    final newSegments = List<TranscriptSegment>.from(segments);

    // Return a new TranscriptData object with the new list
    newSegments[index] = newSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
    // return copyWith(places: newPlaces);
  }

  // /// load next verse from mng db and create new place object from it
  // void fillWithNextVerse(WidgetRef ref, BibleVerse verse) async {
  //   print('fillWithNextVerse');
  //   final Tuple3<String, int, int> nextVerseRef = Tuple3(verse.bookAbb.toString(),
  //       verse.bibleChapter ?? 0, (verse.verse ?? 0) + 1);

  //   BibleVerse? nextVerse =
  //       await DBProvider().getBibleVerseFromReference(nextVerseRef);
  //   if (nextVerse != null) {
  //     print('nextVerse: ${nextVerse.content}');
  //     addVerseNumberToStart(ref, nextVerse);
  //     final segmentIndex = ref.watch(editedSegmentIndexProvider);

  //     final newText = '(${nextVerse.verse}) ${nextVerse.content}';
  //     // );
  //     ref
  //         .read(currentTranscriptProvider.notifier)
  //         .updateText(segmentIndex!, newText);
  //     ref
  //         .read(currentTranscriptProvider.notifier)
  //         .toggleIsScripture(segmentIndex);

  //     final segment = ref.watch(sentenceProvider);
  //     Place newPlace = Place(
  //       bookName: (nextVerse.bookAbb ?? '').trim(),
  //       bookId: nextVerse.bookId ?? 0,
  //       chapterNumber: nextVerse.bibleChapter ?? 0,
  //       verseStartNumber: nextVerse.verse ?? 0,
  //       verseEndNumber: nextVerse.verse ?? 0,
  //       verseText: nextVerse.content,
  //       meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
  //       timePosition: segment.startTime,
  //     );

  //     ref.read(placeRepositoryProvider).savePlace(newPlace);
  //     ref
  //         .read(currentTranscriptProvider.notifier)
  //         .addPlace(segmentIndex, newPlace);
  //   }
  // }

  Future<TranscriptData> addNextVerse2SegmentPlaces(
      WidgetRef ref, int index, BibleVerse verse) async {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // load a segment to take current BibleVerse from
    final TranscriptSegment segment = segments[index];

    // load verse to load next one from
    // final BibleVerse? verse = segment.assignedScripture;

    // if (verse == null) {
    //   throw Exception('No verse assigned');
    // }

    // load next verse from mng db
    final Tuple3<String, int, int> nextVerseRef = Tuple3(
        verse.bookAbb.toString(),
        verse.bibleChapter ?? 0,
        (verse.verse ?? 0) + 1);

    BibleVerse? nextVerse =
        await BibleDBProvider().getDEBibleVerseFromAPIReference(nextVerseRef);

    // if next verse exists, proceed
    if (nextVerse != null) {
      // create text of next segment
      final newText = '(${nextVerse.verse}) ${nextVerse.content}';

      // prepare index of next segment
      // final newIndex = index + 1;

      // add nextVerse to places of current segment
      final newPlaces = List<Place>.from(segment.places);

      // prepare new place
      Place newPlace = Place(
        bookName: (nextVerse.bookAbb ?? '').trim(),
        bookId: nextVerse.bookId ?? 0,
        chapterNumber: nextVerse.bibleChapter ?? 0,
        verseStartNumber: nextVerse.verse ?? 0,
        verseEndNumber: nextVerse.verse ?? 0,
        verseText: nextVerse.content,
        meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
        timePosition: segment.startTime,
      );

      newPlaces.add(newPlace);

      // create new segment with new text and assigned verse

      //  replace segment with a new esgment with a new places
      final TranscriptSegment nextSegment = segments[index];
      final newSegment = nextSegment.copyWith(places: newPlaces);
      // print('replaceNextSegmentTextWithNextVerse');
      // print(newSegment.assignedScripture!.bookAbb);

      // Create a new list with the toggled segment
      final newSegments = List<TranscriptSegment>.from(segments);

      // Return a new TranscriptData object with the new list
      newSegments[index] = newSegment;

      // ref.read(placeRepositoryProvider).savePlace(newPlace);
      ref.read(sentenceProvider.notifier).state = newSegment;
      return copyWith(segments: newSegments);

      // update sentenceProvider with new segment
    }
    throw Exception('No next verse found');
  }

  Future<TranscriptData> replaceNextSegmentTextWithNextVerse(
      WidgetRef ref, int index) async {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // load a segment to take current BibleVerse from
    final TranscriptSegment segment = segments[index];

    // load verse to load next one from
    final BibleVerse? verse = segment.assignedScripture;

    if (verse == null) {
      throw Exception('No verse assigned');
    }

    // load next verse from mng db
    final Tuple3<String, int, int> nextVerseRef = Tuple3(
        verse.bookAbb.toString(),
        verse.bibleChapter ?? 0,
        (verse.verse ?? 0) + 1);

    BibleVerse? nextVerse =
        await BibleDBProvider().getDEBibleVerseFromAPIReference(nextVerseRef);

    // if next verse exists, proceed
    if (nextVerse != null) {
      // create text of next segment
      final newText = '(${nextVerse.verse}) ${nextVerse.content}';

      // prepare index of next segment
      final newIndex = index + 1;

      // load next segment
      final TranscriptSegment nextSegment = segments[newIndex];

      // prepare new place
      Place newPlace = Place(
        bookName: (nextVerse.bookAbb ?? '').trim(),
        bookId: nextVerse.bookId ?? 0,
        chapterNumber: nextVerse.bibleChapter ?? 0,
        verseStartNumber: nextVerse.verse ?? 0,
        verseEndNumber: nextVerse.verse ?? 0,
        verseText: nextVerse.content,
        meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
        timePosition: segment.startTime,
      );

      final newPlaces = List<Place>.from(segment.places);
      newPlaces.add(newPlace);

      // create new segment with new text and assigned verse
      final newSegment = nextSegment.copyWith(
          assignedScripture: nextVerse,
          text: newText,
          isScripture: true,
          places: newPlaces);
      print('replaceNextSegmentTextWithNextVerse');
      print(newSegment.assignedScripture!.bookAbb);

      // Create a new list with the toggled segment
      final newSegments = List<TranscriptSegment>.from(segments);

      // Return a new TranscriptData object with the new list
      newSegments[newIndex] = newSegment;

      // Return a new TranscriptData object with the new list
      // update text of next segment with new text
      // ref
      //     .read(currentTranscriptProvider.notifier)
      //     .updateText(newIndex, newText);

      // // toggle isScripture of next segment
      // ref.read(currentTranscriptProvider.notifier).toggleIsScripture(newIndex);

      // final segment = ref.watch(sentenceProvider);

      ref.read(placeRepositoryProvider).savePlace(newPlace);
      // ref.read(currentTranscriptProvider.notifier).addPlace(newIndex, newPlace);
      // ref
      //     .read(currentTranscriptProvider.notifier)
      //     .assignBibleVerse(segmentIndex, verse);

      return copyWith(segments: newSegments);
    }
    throw Exception('No next verse found');

    // final newText = '(${verse.verse}) ${verse.content}';
    // );
    // ref
    //     .read(currentTranscriptProvider.notifier)
    //     .updateText(segmentIndex!, newText);
    // ref
    //     .read(currentTranscriptProvider.notifier)
    //     .toggleIsScripture(segmentIndex);

    // final segment = ref.watch(sentenceProvider);
    // Place newPlace = Place(
    //   bookName: (verse.bookAbb ?? '').trim(),
    //   bookId: verse.bookId ?? 0,
    //   segmentId: 0,
    //   chapterNumber: verse.bibleChapter ?? 0,
    //   verseStartNumber: verse.verse ?? 0,
    //   verseEndNumber: verse.verse ?? 0,
    //   verseText: verse.content,
    //   meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
    //   timePosition: segment.startTime,
    // );

    // ref.read(placeRepositoryProvider).savePlace(newPlace);
    // ref
    //     .read(currentTranscriptProvider.notifier)
    //     .addPlace(segmentIndex, newPlace);
    // ref
    //     .read(currentTranscriptProvider.notifier)
    //     .assignBibleVerse(segmentIndex, verse);
    // return copyWith(segments: newSegments);

    // ref.read(placeRepositoryProvider).createPlace(place: Place(
    //   name: verse.content,
    //   type: 'scripture',
    //   reference: '${verse.bookAbb} ${verse.bibleChapter}:${verse.verse}',))
  }

  TranscriptData addPlace(int index, Place place) {
    // if (index < 0 || index >= segments.length) {
    //   throw RangeError('Index out of range');
    // }
    final segment = segments[index];
    final newPlaces = List<Place>.from(segment.places);
    newPlaces.add(place);
    final newSegment = segment.copyWith(places: newPlaces);

    // Create a new list with the toggled segment
    final newSegments = List<TranscriptSegment>.from(segments);

    // Return a new TranscriptData object with the new list
    newSegments[index] = newSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
    // return copyWith(places: newPlaces);
  }

  TranscriptData cleanAllSegments(WidgetRef ref) {
    // set DeepLCallStatusProvider enum to loading
    // ref.read(deepLCallStatusPProvider.notifier).state = DeepLCallStatus.loading;

    // update all segments with translations
    final newSegments = List<TranscriptSegment>.from(segments);

    // loop through all segments
    for (TranscriptSegment segment in newSegments) {
      // translate segment
      String cleanedDe = TextCleaner().cleanText(segment.text,
          language: ref.watch(currentTranscriptProvider).language);
      String cleanedSk =
          TextCleaner().cleanText(segment.textSk, language: 'sk');

      // create new segment with translated text
      final newSegment = segment.copyWith(text: cleanedDe, textSk: cleanedSk);

      // update segment in list
      newSegments[newSegments.indexOf(segment)] = newSegment;

      //wait 1 second
      // await Future.delayed(const Duration(seconds: 1));
    }
    // ref.read(deepLCallStatusPProvider.notifier).state = DeepLCallStatus.success;

    return copyWith(segments: newSegments);
  }

  Future<TranscriptData> translateAllSegments(
      WidgetRef ref, String targetLanguage) async {
    if (segments.isEmpty) {
      throw RangeError('Index out of range');
    }

    // set DeepLCallStatusProvider enum to loading
    ref.read(deepLCallStatusPProvider.notifier).state = DeepLCallStatus.loading;

    // update all segments with translations
    final newSegments = List<TranscriptSegment>.from(segments);

    // loop through all segments
    for (TranscriptSegment segment in newSegments) {
      // translate segment
      String translated = await TranslatioServices()
          .translateText(segment.text, targetLanguage);

      // create new segment with translated text
      final newSegment = segment.copyWith(textSk: translated);

      // update segment in list
      newSegments[newSegments.indexOf(segment)] = newSegment;

      //wait 1 second
      await Future.delayed(const Duration(seconds: 1));
    }
    ref.read(deepLCallStatusPProvider.notifier).state = DeepLCallStatus.success;

    return copyWith(segments: newSegments);
  }

  Future<TranscriptData> translateSegment(
      int index, String targetLanguage) async {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // Create a new segment with the toggled isScripture attribute
    final segment = segments[index];

    String translated =
        await TranslatioServices().translateText(segment.text, targetLanguage);

    final updatedSegment = segment.copyWith(textSk: translated);

    // Create a new list with the toggled segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = updatedSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData toggleHasParagraphBreak(int index) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // Create a new segment with the toggled isScripture attribute
    final segment = segments[index];
    final toggledSegment =
        segment.copyWith(hasParagraphBreak: !segment.hasParagraphBreak);

    // Create a new list with the toggled segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = toggledSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData restoreText(int index) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // Create a new segment with the updated text
    final segment = segments[index];
    final updatedSegment = segment.copyWith(text: segment.originalText);

    // Create a new list with the updated segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = updatedSegment;
    // print('updateText2: $index, ${newSegments[index]}');

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData saveId(int tdid) {
    return copyWith(id: tdid);
  }

  TranscriptData updateText(int index, String newText) {
    // print('updateText2: $index, $newText');
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // Create a new segment with the updated text
    final segment = segments[index];
    final updatedSegment = segment.copyWith(text: newText);

    // Create a new list with the updated segment
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = updatedSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData splitSegment(int index, int splitIndex) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }

    // Create two new segments from the original segment
    final segment = segments[index];
    double cursorPositionR =
        cursorPositionRatio(splitIndex, segment.text.length);
    String net = calculateNewEndTime(
        segment.startTime, segment.endTime, cursorPositionR);
    String nst = calculateNewStartTime(
        segment.startTime, segment.endTime, cursorPositionR);
    final firstSegment = TranscriptSegment(
      text: segment.text.substring(0, splitIndex).trim(),
      originalText: segment.originalText,
      start: segment.start,
      startTime: segment.startTime,
      end: segment.end,
      endTime: net,
      assignedScripture: segment.assignedScripture,
      foundScriptures: segment.foundScriptures,
      isBrRuss: segment.isBrRuss,
      isSong: segment.isSong,
      isWBQuote: segment.isWBQuote,
      places: segment.places,
      textEn: segment.textEn,
      textSk: segment.textSk,
      transcriptDataId: segment.transcriptDataId,
      isScripture: segment.isScripture,
      hasParagraphBreak: segment.hasParagraphBreak,
    );
    final secondSegment = TranscriptSegment(
      text: segment.text.substring(splitIndex).trim(),
      originalText: segment.originalText,
      start: segment.start,
      startTime: nst,
      end: segment.end,
      endTime: segment.endTime,
      assignedScripture: segment.assignedScripture,
      foundScriptures: segment.foundScriptures,
      isBrRuss: segment.isBrRuss,
      isSong: segment.isSong,
      isWBQuote: segment.isWBQuote,
      places: segment.places,
      textEn: segment.textEn,
      textSk: segment.textSk,
      transcriptDataId: segment.transcriptDataId,
      isScripture: segment.isScripture,
      hasParagraphBreak: segment.hasParagraphBreak,
    );

    // Create a new list with the two new segments
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments.removeAt(index);
    newSegments.insert(index, secondSegment);
    newSegments.insert(index, firstSegment);

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData splitCurrentSegmentAsQuote(int index, int splitIndex) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Segment Index out of range');
    }
    final segment = segments[index];
    if (splitIndex < 0 || splitIndex >= segment.text.length) {
      throw RangeError('Split Index out of range');
    }
    // Create two new segments from the original segment
    String newFirstText = segment.text.substring(0, splitIndex).trim();
    newFirstText = newFirstText.substring(0, newFirstText.length).trim();
    // remove last character if it's a comma
    if (newFirstText[newFirstText.length - 1] == ',') {
      newFirstText = newFirstText.substring(0, newFirstText.length - 1);
    }
    newFirstText = '$newFirstText:';

    double cursorPositionR =
        cursorPositionRatio(splitIndex, segment.text.length);
    String net = calculateNewEndTime(
        segment.startTime, segment.endTime, cursorPositionR);
    String nst = calculateNewStartTime(
        segment.startTime, segment.endTime, cursorPositionR);
    final firstSegment = segment.copyWith(
      text: newFirstText,
      endTime: net,
    );
    String secondText = segment.text.substring(splitIndex).trim();
    secondText = secondText[0].toUpperCase() + secondText.substring(1);
    final secondSegment = segment.copyWith(
      text: secondText,
      startTime: nst,
    );

    // Create a new list with the two new segments
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments.removeAt(index);
    newSegments.insert(index, secondSegment);
    newSegments.insert(index, firstSegment);

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData splitCurrentSegmentAsSentence(int index, int splitIndex) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }
    // Create two new segments from the original segment
    final segment = segments[index];
    String newFirstText = segment.text.substring(0, splitIndex).trim();

    // if last character is , then remove it
    if (newFirstText[newFirstText.length - 1] == ',') {
      newFirstText = newFirstText.substring(0, newFirstText.length - 1);
    }
    newFirstText = '$newFirstText.';
    // substring(0, newFirstText.length - 1)

    double cursorPositionR =
        cursorPositionRatio(splitIndex, segment.text.length);
    String net = calculateNewEndTime(
        segment.startTime, segment.endTime, cursorPositionR);
    String nst = calculateNewStartTime(
        segment.startTime, segment.endTime, cursorPositionR);
    final firstSegment = segment.copyWith(
      text: newFirstText,
      endTime: net,
    );
    String newSecondText = segment.text.substring(splitIndex).trim();
    newSecondText = newSecondText[0].toUpperCase() + newSecondText.substring(1);

    final secondSegment = segment.copyWith(
      text: newSecondText,
      startTime: nst,
    );

    // Create a new list with the two new segments
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments.removeAt(index);
    newSegments.insert(index, secondSegment);
    newSegments.insert(index, firstSegment);

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData connectWithComma(int index, int splitIndex) {
    if (index < 0 || index >= segments.length) {
      throw RangeError('Index out of range');
    }
    // Create two new segments from the original segment
    final segment = segments[index];

    // get first part of string
    String newFirstText = segment.text.substring(0, splitIndex).trim();

    // replace last char with comma
    // newFirstText = '${newFirstText.substring(0, newFirstText.length - 1)},';

    // if last character is a dot, replace with comma
    if (newFirstText[newFirstText.length - 1] == '.') {
      newFirstText = '${newFirstText.substring(0, newFirstText.length - 1)},';
    }
    // else {
    //   newFirstText = '${newFirstText},';
    // }

    // get second part of string
    String newSecondText = segment.text.substring(splitIndex).trim();

    // make first character lowercase
    newSecondText = newSecondText[0].toLowerCase() + newSecondText.substring(1);

    // connect texts together
    String connectedText = '$newFirstText $newSecondText';

    final updatedSegment = segment.copyWith(
      text: connectedText,
    );

    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[index] = updatedSegment;

    // Return a new TranscriptData object with the new list
    return copyWith(segments: newSegments);
  }

  TranscriptData deletePlace(WidgetRef ref, int segmentIndex, int placeIndex) {
    print('deletePlace: $segmentIndex, $placeIndex');
    final segment = segments[segmentIndex];
    final newPlaces = List<Place>.from(segment.places);
    newPlaces.removeAt(placeIndex);

    final newSegment = segment.copyWith(places: newPlaces);
    final newSegments = List<TranscriptSegment>.from(segments);
    newSegments[segmentIndex] = newSegment;
    ref.read(sentenceProvider.notifier).setSegment(newSegments[segmentIndex]);

    return copyWith(segments: newSegments);
  }
}
