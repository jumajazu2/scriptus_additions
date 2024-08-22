import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/extensions/meetings_button.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/settings_provider.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // final settings = ref.watch(settingsProvider);
    return IconButton(
      icon: const Icon(Icons.settings),
      // label: const Text('Settings'),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const LoadMeetingsButton(),
                Consumer(
                  builder: (context, ref, child) {
                    return Column(
                      children: [
                        const Text('Settings'),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show all assigned'),
                            const Spacer(),
                            Checkbox(
                                value:
                                    ref.watch(settingsProvider).showAssignedAll,
                                onChanged: (_) => ref
                                    .read(settingsProvider.notifier)
                                    .updateSettings(ref
                                        .watch(settingsProvider)
                                        .copyWith(
                                            showAssignedAll: !ref
                                                .watch(settingsProvider)
                                                .showAssignedAll))),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show one assigned'),
                            const Spacer(),
                            Checkbox(
                                value:
                                    ref.watch(settingsProvider).showAssignedOne,
                                onChanged: (_) => ref
                                    .read(settingsProvider.notifier)
                                    .updateSettings(ref
                                        .watch(settingsProvider)
                                        .copyWith(
                                            showAssignedOne: !ref
                                                .watch(settingsProvider)
                                                .showAssignedOne))),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show Found'),
                            const Spacer(),
                            Checkbox(
                                value: ref.watch(settingsProvider).showFound,
                                onChanged: (_) => ref
                                    .read(settingsProvider.notifier)
                                    .updateSettings(ref
                                        .watch(settingsProvider)
                                        .copyWith(
                                            showFound: !ref
                                                .watch(settingsProvider)
                                                .showFound))),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show From API'),
                            const Spacer(),
                            Checkbox(
                                value: ref
                                    .watch(settingsProvider)
                                    .showSavedFromApi,
                                onChanged: (_) => ref
                                    .read(settingsProvider.notifier)
                                    .updateSettings(ref
                                        .watch(settingsProvider)
                                        .copyWith(
                                            showSavedFromApi: !ref
                                                .watch(settingsProvider)
                                                .showSavedFromApi))),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show Object'),
                            const Spacer(),
                            Checkbox(
                                value: ref.watch(settingsProvider).showObject,
                                onChanged: (_) => ref
                                    .read(settingsProvider.notifier)
                                    .updateSettings(ref
                                        .watch(settingsProvider)
                                        .copyWith(
                                            showObject: !ref
                                                .watch(settingsProvider)
                                                .showObject))),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Show SLOVAK'),
                            const Spacer(),
                            Checkbox(
                                value: ref.watch(settingsProvider).showSlovak,
                                onChanged: (_) => ref
                                    .read(settingsProvider.notifier)
                                    .updateSettings(ref
                                        .watch(settingsProvider)
                                        .copyWith(
                                            showSlovak: !ref
                                                .watch(settingsProvider)
                                                .showSlovak))),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Export HTML with Original Verse Text'),
                            const Spacer(),
                            Checkbox(
                                value: ref
                                    .watch(settingsProvider)
                                    .exportHtmlWithOriginalVerse,
                                onChanged: (_) => ref
                                    .read(settingsProvider.notifier)
                                    .updateSettings(ref
                                        .watch(settingsProvider)
                                        .copyWith(
                                            exportHtmlWithOriginalVerse: !ref
                                                .watch(settingsProvider)
                                                .exportHtmlWithOriginalVerse))),
                          ],
                        ),
                      //   Row(
                      //     mainAxisSize: MainAxisSize.min,
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       const Text('Offset MP3 playback (s)'),
                      //       const Spacer(),
                      //       ExcludeSemantics(
                      //         child: Slider(
                      //           min: 0.0,
                      //           // activeColor: Colors.amberAccent,
                      //           // secondaryActiveColor: Colors.amberAccent,
                      //           max: 360.toDouble(),
                      //           divisions: 36,
                      //           value: 0,
                      //           onChanged: (value) => ref
                      //               .read(currentTranscriptProvider.notifier).setOffsetSeconds(int.parse(value.toString()),
                      // ),
                      // ),
                      // ),
                      //       // TextField(
                      //       //   minLines: 6,
                      //       //   maxLines: 6,
                      //       //   decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
                      //       //   strutStyle: const StrutStyle(
                      //       //     // fontSize: 18,
                      //       //     height: 1.4,
                      //       //   ),
                      //       //   textAlign: TextAlign.left,
                      //       //   cursorColor: Colors.red[900],
                      //       //   autofocus: true,
                      //       //   cursorWidth: 5,
                      //       //   controller: TextEditingController(
                      //       //       text: ref.watch(currentTranscriptProvider).offsetSeconds.toString()),
                      //       //     onChanged: (value) => ref
                      //       //         .read(currentTranscriptProvider.notifier).setOffsetSeconds(int.parse(value)),),
                      //     ],
                      //   ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
