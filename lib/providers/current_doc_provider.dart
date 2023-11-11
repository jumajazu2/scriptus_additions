import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/extensions/text_cleaner.dart';
import 'package:scriptus/models/bible_verse.dart';
import 'package:scriptus/models/place.dart';
import 'package:scriptus/models/transcript_data.dart';
import 'package:scriptus/models/transcript_segment.dart';
import 'package:scriptus/providers/meeting_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/repositories/places_repo.dart';

final StateNotifierProvider<TranscriptDataNotifier, TranscriptData>
    currentTranscriptProvider =
    StateNotifierProvider<TranscriptDataNotifier, TranscriptData>(
  (ref) => TranscriptDataNotifier(),
);

class TranscriptDataNotifier extends StateNotifier<TranscriptData> {
  TranscriptDataNotifier()
      : super(TranscriptData(
            originalText: '',
            text: '',
            segments: [],
            language: 'de',
            filePath: '',
            fileName: '',
            meetingId: 0));

  void addFoundVersesToSegment(int index, List<BibleVerse> verses) {
    state = state.addFoundVersesToSegment(index, verses);
  }

  void mergeWithPrevious(int index) {
    state = state.mergeWithPrevious(index);
  }

  void mergeWithPreviousWithComma(int index) {
    state = state.mergeWithPreviousWithComma(index);
  }

  void setAllWBQ() {
    state = state.setAllWBQ();
  }

  void toggleIsScripture(int index) {
    state = state.toggleIsScripture(index);
  }

  void toggleIsWBQuote(int index) {
    state = state.toggleIsWBQuote(index);
  }

  void toggleIsBrRuss(int index) {
    state = state.toggleIsBrRuss(index);
  }

  void toggleIsSong(int index) {
    state = state.toggleIsSong(index);
  }

  void toggleHasParagraphBreak(int index) {
    state = state.toggleHasParagraphBreak(index);
  }

  void translateSegment(int index) async {
    state = await state.translateSegment(index, 'sk');
  }

  void translateAllSegments(
    WidgetRef ref,
  ) async {
    state = await state.translateAllSegments(ref, 'sk');
  }

  void cleanAllSegments(
    WidgetRef ref,
  ) {
    state = state.cleanAllSegments(ref);
  }

  void updateText(int index, String newText) {
    state = state.updateText(index, newText);
  }

  void saveId(int id) {
    state = state.saveId(id);
  }

  void cleanText(int index, String oldText) {
    var newText = TextCleaner().cleanText(oldText);
    state = state.updateText(index, newText);
  }

  void restoreText(int index) {
    state = state.restoreText(index);
  }

  void replaceNextSegmentTextWithNextVerse(WidgetRef ref, int index) async {
    state = await state.replaceNextSegmentTextWithNextVerse(ref, index);
  }

  void addNextVerse2SegmentPlaces(
      WidgetRef ref, int index, BibleVerse verse) async {
    state = await state.addNextVerse2SegmentPlaces(ref, index, verse);
  }

  void splitSegment(int index, int splitIndex) {
    state = state.splitSegment(index, splitIndex);
  }

  void splitCurrentSegmentAsQuote(int index, int splitIndex) {
    state = state.splitCurrentSegmentAsQuote(index, splitIndex);
  }

  void splitCurrentSegmentAsSentence(int index, int splitIndex) {
    state = state.splitCurrentSegmentAsSentence(index, splitIndex);
  }

  void connectWithComma(int index, int splitIndex) {
    state = state.connectWithComma(index, splitIndex);
  }

  void addPlace(int index, Place place) {
    state = state.addPlace(index, place);
  }

  void assignBibleVerse(int index, BibleVerse verse) {
    state = state.assignBibleVerse(index, verse);
  }

  void setMeetingId(int meetingId) {
    state = state.setMeetingId(meetingId);
  }

  void deletePlace(WidgetRef ref, int segmentIndex, int placeIndex) {
    state = state.deletePlace(ref, segmentIndex, placeIndex);
  }
}

void addVerseNumberToStart(WidgetRef ref, BibleVerse verse) {
  final segmentIndex = ref.watch(editedSegmentIndexProvider);
  final segmentText = ref.watch(sentenceProvider).text;
  final newText = '(${verse.verse}) $segmentText';
  // final currentTranscript = ref.read(currentTranscriptProvider);
  // print(segmentIndex);
  // print(verse.content);
  // final newSegment = currentTranscript.segments[segmentIndex].copyWith(
  //   text: '"${verse.verse}"',
  // );
  ref
      .read(currentTranscriptProvider.notifier)
      .updateText(segmentIndex!, newText);
  ref.read(currentTranscriptProvider.notifier).toggleIsScripture(segmentIndex);

  final segment = ref.watch(sentenceProvider);
  Place newPlace = Place(
    createdAt: DateTime.now(),
    language: 'de',
    segmentId: ref.watch(sentenceProvider).id ?? 0,
    transcriptDataId: ref.watch(currentTranscriptProvider).id,
    createdBy: 1,
    bookName: (verse.bookAbb ?? '').trim(),
    bookId: verse.bookId ?? 0,
    chapterNumber: verse.bibleChapter ?? 0,
    verseStartNumber: verse.verse ?? 0,
    verseEndNumber: verse.verse ?? 0,
    verseText: verse.content,
    meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
    timePosition: segment.startTime,
  );

  ref.read(currentTranscriptProvider.notifier).addPlace(segmentIndex, newPlace);
  ref.read(placeRepositoryProvider).savePlace(newPlace);
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

void replaceSegmentTextWithVerse(WidgetRef ref, BibleVerse verse) {
  final segmentIndex = ref.watch(editedSegmentIndexProvider);
  // final currentTranscript = ref.read(currentTranscriptProvider);
  // print(segmentIndex);
  // print(verse.content);
  // final newSegment = currentTranscript.segments[segmentIndex].copyWith(
  //   text: '"${verse.verse}"',
  final newText = '(${verse.verse}) ${verse.content}';
  // );
  ref
      .read(currentTranscriptProvider.notifier)
      .updateText(segmentIndex!, newText);
  ref.read(currentTranscriptProvider.notifier).toggleIsScripture(segmentIndex);

  final segment = ref.watch(sentenceProvider);
  Place newPlace = Place(
    bookName: (verse.bookAbb ?? '').trim(),
    bookId: verse.bookId ?? 0,
    segmentId: 0,
    chapterNumber: verse.bibleChapter ?? 0,
    verseStartNumber: verse.verse ?? 0,
    verseEndNumber: verse.verse ?? 0,
    verseText: verse.content,
    meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
    timePosition: segment.startTime,
  );

  ref.read(placeRepositoryProvider).savePlace(newPlace);
  ref.read(currentTranscriptProvider.notifier).addPlace(segmentIndex, newPlace);
  ref
      .read(currentTranscriptProvider.notifier)
      .assignBibleVerse(segmentIndex, verse);
  ref.read(sentenceProvider.notifier).state = segment.copyWith(
    text: newText,
  );

  // ref.read(placeRepositoryProvider).createPlace(place: Place(
  //   name: verse.content,
  //   type: 'scripture',
  //   reference: '${verse.bookAbb} ${verse.bibleChapter}:${verse.verse}',))
}

void assignVerseToSegment(WidgetRef ref, BibleVerse verse) {
  final segmentIndex = ref.watch(editedSegmentIndexProvider);
  final segment = ref.watch(sentenceProvider);
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
  // ref.read(currentTranscriptProvider.notifier).addPlace(segmentIndex, newPlace);
  if (segmentIndex != null) {
    ref
        .read(currentTranscriptProvider.notifier)
        .assignBibleVerse(segmentIndex, verse);
    assignVerseToSegmentPlaces(ref, verse);
  }

  // ref.read(placeRepositoryProvider).createPlace(place: Place(
  //   name: verse.content,
  //   type: 'scripture',
  //   reference: '${verse.bookAbb} ${verse.bibleChapter}:${verse.verse}',))
}

void assignVerseToSegmentPlaces(WidgetRef ref, BibleVerse verse) {
  final segmentIndex = ref.watch(editedSegmentIndexProvider);
  if (segmentIndex == null) {
    return;
  }
  final segment = ref.watch(sentenceProvider);
  Place newPlace = Place(
    bookName: (verse.bookAbb ?? '').trim(),
    bookId: verse.bookId ?? 0,
    segmentId: 0,
    chapterNumber: verse.bibleChapter ?? 0,
    verseStartNumber: verse.verse ?? 0,
    verseEndNumber: verse.verse ?? 0,
    verseText: verse.content,
    meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
    timePosition: segment.startTime,
  );
  if (segment.places.contains(newPlace)) {
    return;
  }
  ref.read(placeRepositoryProvider).savePlace(newPlace);
  ref.read(currentTranscriptProvider.notifier).addPlace(segmentIndex, newPlace);
  ref
      .read(currentTranscriptProvider.notifier)
      .assignBibleVerse(segmentIndex, verse);

  // ref.read(placeRepositoryProvider).createPlace(place: Place(
  //   name: verse.content,
  //   type: 'scripture',
  //   reference: '${verse.bookAbb} ${verse.bibleChapter}:${verse.verse}',))
}

void saveId(WidgetRef ref, int id) {
  ref.read(currentTranscriptProvider.notifier).saveId(id);
}

void insertReferenceToSavedPosition(
    WidgetRef ref, BibleVerse verse, int cursorPosition) {
  final segmentIndex = ref.watch(editedSegmentIndexProvider);
  final segment = ref.watch(sentenceProvider);
  final segmentText = segment.text;

  // Add empty brackets
  // String currentText = verse.content;
  String newText =
      '${segmentText.substring(0, cursorPosition)} [${verse.bookAbb} ${verse.bibleChapter}:${verse.verse}] ${segmentText.substring(cursorPosition)}';

  // final newText =
  //     '$segmentText [${verse.bookAbb} ${verse.bibleChapter}:${verse.verse}]';
  // final currentTranscript = ref.read(currentTranscriptProvider);
  // print(segmentIndex);
  // print(verse.content);
  // final newSegment = currentTranscript.segments[segmentIndex].copyWith(
  //   text: '"${verse.verse}"',
  // );

  ref
      .read(currentTranscriptProvider.notifier)
      .updateText(segmentIndex!, newText);
  Place newPlace = Place(
      bookName: (verse.bookAbb ?? '').trim(),
      bookId: verse.bookId ?? 0,
      chapterNumber: verse.bibleChapter ?? 0,
      verseStartNumber: verse.verse ?? 0,
      verseEndNumber: verse.verse ?? 0,
      verseText: verse.content,
      meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
      timePosition: segment.startTime,
      referencePosition: cursorPosition,
      isReference: true);
  ref.read(currentTranscriptProvider.notifier).addPlace(segmentIndex, newPlace);
  ref.read(sentenceProvider.notifier).state = segment.copyWith(
    text: newText,
  );
  ref.read(placeRepositoryProvider).savePlace(newPlace);

  // ref
  //     .read(currentTranscriptProvider.notifier)
  //     .toggleIsScripture(segmentIndex);
}

void addReferenceToEndOfText(WidgetRef ref, BibleVerse verse) {
  final segmentIndex = ref.watch(editedSegmentIndexProvider);
  final segment = ref.watch(sentenceProvider);
  final segmentText = segment.text;
  final newText =
      '$segmentText [${verse.bookAbb} ${verse.bibleChapter}:${verse.verse}]';
  // final currentTranscript = ref.read(currentTranscriptProvider);
  // print(segmentIndex);
  // print(verse.content);
  // final newSegment = currentTranscript.segments[segmentIndex].copyWith(
  //   text: '"${verse.verse}"',
  // );

  ref
      .read(currentTranscriptProvider.notifier)
      .updateText(segmentIndex!, newText);
  Place newPlace = Place(
    bookName: (verse.bookAbb ?? '').trim(),
    bookId: verse.bookId ?? 0,
    chapterNumber: verse.bibleChapter ?? 0,
    verseStartNumber: verse.verse ?? 0,
    verseEndNumber: verse.verse ?? 0,
    verseText: verse.content,
    meetingId: ref.watch(selectedMeetingProvider).id ?? 0,
    timePosition: segment.startTime,
  );
  ref.read(currentTranscriptProvider.notifier).addPlace(segmentIndex, newPlace);
  ref.read(sentenceProvider.notifier).state = segment.copyWith(
    text: newText,
  );
  ref.read(placeRepositoryProvider).savePlace(newPlace);

  // ref
  //     .read(currentTranscriptProvider.notifier)
  //     .toggleIsScripture(segmentIndex);
}

void mergeWithPrevious(WidgetRef ref, int index) {
  ref.read(currentTranscriptProvider.notifier).mergeWithPrevious(index);
  TranscriptSegment ts =
      ref.watch(currentTranscriptProvider).segments[index - 1];
  ref.read(sentenceProvider.notifier).state = ts;
}

void mergeWithPreviousWithComma(WidgetRef ref, int index) {
  ref
      .read(currentTranscriptProvider.notifier)
      .mergeWithPreviousWithComma(index);
  TranscriptSegment ts =
      ref.watch(currentTranscriptProvider).segments[index - 1];
  ref.read(sentenceProvider.notifier).state = ts;
}

void addFoundVersesToSegment(
    WidgetRef ref, int index, List<BibleVerse> verses) {
  ref
      .read(currentTranscriptProvider.notifier)
      .addFoundVersesToSegment(index, verses);
}

void toggleIsScripture(WidgetRef ref, int index) {
  ref.read(currentTranscriptProvider.notifier).toggleIsScripture(index);
}

void cleanText(WidgetRef ref, int index, String oldText) {
  ref.read(currentTranscriptProvider.notifier).cleanText(index, oldText);
}

void toggleHasParagraphBreak(WidgetRef ref, int index) {
  ref.read(currentTranscriptProvider.notifier).toggleHasParagraphBreak(index);
}

void updateText(WidgetRef ref, int index, String newText) {
  ref.read(currentTranscriptProvider.notifier).updateText(index, newText);
}

void splitSegment(WidgetRef ref, int index, int splitIndex) {
  ref.read(currentTranscriptProvider.notifier).splitSegment(index, splitIndex);
}

void addNextVerse2SegmentPlaces(WidgetRef ref, int index, BibleVerse verse) {
  ref
      .read(currentTranscriptProvider.notifier)
      .addNextVerse2SegmentPlaces(ref, index, verse);
}
