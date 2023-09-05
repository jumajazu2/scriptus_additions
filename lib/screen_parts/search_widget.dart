import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/models/settings_model.dart';
import 'package:scriptus/providers/search_provider.dart';
import 'package:scriptus/providers/settings_provider.dart';

class SearchWidget extends ConsumerWidget {
  /// Displays a search widget.
  /// It is used in the SegmentEditor widget.
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SettingsModel settings = ref.watch(settingsProvider);
    TextEditingController searchTec = TextEditingController();
    return settings.showSearch
        ? Row(
            children: [
              Container(
                width: 300,
                height: 40,
                color: Colors.grey[600],
                child: TextField(
                  style: const TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                      hintText: 'Search …',
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                  onChanged: (value) =>
                      ref.read(searchValueProvider.notifier).state = value,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(showSearch: !settings.showSearch));
                  searchTec.text = '';
                  ref.read(searchValueProvider.notifier).state = '';
                },
                // child: const Text('Clean All'),
                child: const Icon(Icons.search),
              ),
            ],
          )
        : MaterialButton(
            onPressed: () {
              ref.read(settingsProvider.notifier).updateSettings(
                  settings.copyWith(showSearch: !settings.showSearch));
              searchTec.text = '';
              ref.read(searchValueProvider.notifier).state = '';
            },
            // child: const Text('Clean All'),
            child: const Icon(Icons.search),
          );
  }
}

// Container(
//               width: 300,
//               height: 10,
//               color: Colors.grey[600],
//               child: TextField(
//                 style: const TextStyle(fontSize: 20),
//                 decoration: const InputDecoration(
//                     hintText: 'Search …',
//                     focusedBorder: InputBorder.none,
//                     contentPadding: EdgeInsets.fromLTRB(15, 5, 10, 0)),
//                 onChanged: (value) =>
//                     ref.read(searchValueProvider.notifier).state = value,
//               ),
//             ),
//           MaterialButton(
//             onPressed: () {
//               ref.read(settingsProvider.notifier).updateSettings(
//                   settings.copyWith(showSearch: !settings.showSearch));
//                   searchTec.text = '';
//             },
//             // child: const Text('Clean All'),
//             child: const Icon(Icons.search),
//           ),