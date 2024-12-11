import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/models/bible_verse.dart';

//final foundVersesProvider = StateProvider<List<BibleVerse>>((ref) => []);

final variablemonitorProvider = StateProvider<int>((ref) => 0);

// class FoundVersesNotifier extends StateNotifier<List<BibleVerse>> {
//   FoundVersesNotifier() : super([]);

//   void callOpenAiApi(TranscriptSegment s) {
//     state = state.callOpenAiApi(s);
//   }

//   // void mergeWithPrevious(BibleVerse bv) {
//   //   state.add(bv);
//   // }
// }

// final StateNotifierProvider<FoundVersesNotifier, List<BibleVerse>>
//     foundVersesProvider =
//     StateNotifierProvider<FoundVersesNotifier, List<BibleVerse>>(
//   (ref) => FoundVersesNotifier(),
// );

// // final foundVersesProvider = StateProvider<List<BibleVerse>>((ref) => []);

// // final StateNotifierProvider<FoundVersesNotifier, List<BibleVerse>>
// //     foundVersesProvider =
// //     StateNotifierProvider<FoundVersesNotifier, List<BibleVerse>>(
// //   (ref) => FoundVersesNotifier(),
// // );

// // void getGermanBibleReference(WidgetRef ref, BibleVerse bv) {
// //   ref.read(foundVersesProvider.notifier).add(bv);
// // }
// // bv  = OpenAIService().getGermanBibleReference(
// //                                         s.text.trim(), s.start)
// // void mergeWithPrevious(WidgetRef ref, BibleVerse bv) {
// //   ref.read(currentTranscriptProvider.notifier).mergeWithPrevious(bv);
// // }

// Future<void> callOpenAiApi(WidgetRef ref, String text) async {
//   // Make the API call

//   final response = await OpenAIService().getGermanBibleReference(text);
//   // Add more verses as needed
//   // ]);

//   // Update the provider with the response
//   ref.read(foundVersesProvider.notifier).call = response;
// }


// void callOpenAiApi(WidgetRef ref, s) {
//   ref.read(foundVersesProvider.notifier).callOpenAiApi(s);
// }
