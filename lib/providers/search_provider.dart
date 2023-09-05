/// riverpod provider for search value
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'search_provider.g.dart';
// final searchValueProvider = StateNotifierProvider<SettingsProvider, SettingsModel>(
//   (ref) => SettingsProvider(),
// );

// @riverpod
// add riverpod generator for string search value
// String searchValue(SearchValueRef ref) => '';

final searchValueProvider = StateProvider<String>((ref) {
  return '';
});
// String example(ExampleRef ref) {
//   return 'foo';
// }
// class SearchValue extends StateNotifier<SettingsModel> {
//   SearchValueProvider() : super(const String '');

//   void updateSearchValue(String searchValue) {
//     state = searchValue;
//   }
// }

