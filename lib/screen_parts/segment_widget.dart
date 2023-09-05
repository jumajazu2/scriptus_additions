// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:scriptus/providers/sentence_providers.dart';

// class SegmentWidget extends ConsumerWidget {
//   const SegmentWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final sentenceState = ref.watch(sentenceProvider);
//     return Container(child: TextSpan(
//           style: TextStyle(
//             // decoration: TextDecoration.underline,
//             color: _hover.contains(a.start) ? Colors.blue : null,
//           ),
//           children: [
//             if (paragraphBreaks.contains(a.start))
//               TextSpan(
//                 style: const TextStyle(
//                     height: .8, color: Colors.blueGrey, fontSize: 15),
//                 text:
//                     "\n\n\n${formatDuration(a.start)} - ${formatDuration(a.end)} - ${a.start} - ${a.end}\n",
//               ),
//             // TextSpan(
//             //   style: TextStyle(
//             //       height: .8, color: Colors.blueGrey, fontSize: 15),
//             //   text: "\n\n${a.start} - ${a.end}\n",
//             // ),
//             TextSpan(
//               onEnter: (_) => setState(() => _hover.add(a.start)),
//               onExit: (_) => setState(() => _hover.remove(a.start)),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                   addParagraphBreak(a.start);
//                   // ref.read(sentenceProvider.notifier).state =
//                   //     value;

//                   // getGermanBibleReference(
//                   //     a.text.trim(), a.start);
//                 },
//               text: "${a.text.trim()} ",
//               // style: TextStyle(
//               //   fontWeight: FontWeight.normal,
//               // ),
//             )
//           ]);
//     });
//   }

