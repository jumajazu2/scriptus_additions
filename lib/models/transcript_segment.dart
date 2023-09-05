import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:scriptus/models/bible_verse.dart';
import 'package:scriptus/models/place.dart';

part 'transcript_segment.freezed.dart';
part 'transcript_segment.g.dart';

@freezed
// @JsonSerializable()
// @DataRepository([])
class TranscriptSegment //extends DataModel<TranscriptSegment>
    with
        _$TranscriptSegment {
  TranscriptSegment._();

  factory TranscriptSegment({
    int? id,
    int? transcriptDataId,
    // required final int seek,
    required final int start,
    required final int end,
    required final String startTime,
    @Default([]) final List<Place> places,
    @Default([]) final List<BibleVerse> foundScriptures,
    BibleVerse? assignedScripture,
    required final String endTime,
    @Default('') final String originalText,
    required final String text,
    @Default('') String textSk,
    @Default('') String textEn,
    @Default(false) final bool hasParagraphBreak,
    @Default(false) final bool isScripture,
    @Default(false) final bool isWBQuote,
    @Default(false) final bool isBrRuss,
    @Default(false) final bool isSong,
    // required final List<int> tokens,
    // required final double temperature,
    // required final double? avgLogprob,
    // required final double? compressionRatio,
    // required final double? noSpeechProb,
    // required BelongsTo<TranscriptData>? transcriptData,
  }) = _TranscriptSegment;

  factory TranscriptSegment.fromJson(Map<String, dynamic> json) =>
      _$TranscriptSegmentFromJson(json);

  TranscriptSegment updateText(String newText) {
    // Create a new segment with the updated text

    // final updatedSegment = TranscriptSegment(
    //   text: newText,
    //   start: start,
    //   startTime: startTime,
    //   end: end,
    //   endTime: endTime,
    //   isScripture: isScripture,
    //   // Add other properties as needed
    // );

    return copyWith(text: newText);
    // Return a new TranscriptSegment object with the new text
    // return TranscriptSegment(
    //   text: newText,
    //   start: start,
    //   startTime: startTime,
    //   end: end,
    //   endTime: endTime,
    //   isScripture: isScripture,
    // );
  }
}

// class Example with _$Example {
//   const factory Example([@Default(42) int value]) = _Example;
// }