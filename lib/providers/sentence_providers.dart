import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scriptus/models/transcript_segment.dart';

part 'sentence_providers.g.dart';

// a provider to hold current position of text as integer
// final StateProvider<int> textPositionProvider = StateProvider<int>((ref) => 0);

@riverpod
class EditedTextCursorPosition extends _$EditedTextCursorPosition {
  @override
  int build() {
    return 0;
  }

  void updateTextPosition(int newPosition) {
    print('updateTextPosition: $newPosition');
    state = newPosition;
  }
}

class TranscriptSegmentNotifier extends StateNotifier<TranscriptSegment> {
  TranscriptSegmentNotifier()
      : super(TranscriptSegment(
            end: 0,
            start: 0,
            text: '',
            hasParagraphBreak: false,
            isScripture: false,
            startTime: '',
            endTime: '',
            originalText: ''));

  void updateText(String newText) {
    print('updateText: $newText');
    state = state.updateText(newText);
  }

  void setSegment(TranscriptSegment newSegment) {
    print('setSegment: $newSegment');
    state = newSegment;
  }
}

final StateNotifierProvider<TranscriptSegmentNotifier, TranscriptSegment>
    sentenceProvider =
    StateNotifierProvider<TranscriptSegmentNotifier, TranscriptSegment>((ref) {
  return TranscriptSegmentNotifier();
  //  TranscriptSegment(
  //     end: 0,
  //     start: 0,
  //     text: '',
  //     hasParagraphBreak: false,
  //     isScripture: false,
  //     startTime: '',
  //     endTime: '');
});

void updateText(WidgetRef ref, String newText) {
  ref.read(sentenceProvider).updateText(newText);
}

final StateProvider<int?> editedSegmentIndexProvider =
    StateProvider<int?>((ref) => null);

// void updateText(int index, String newText) {
//   print('updateText: $index, $newText');
//   state = state.updateText(index, newText);
// }
