import 'package:country_flags/country_flags.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:scriptus/audio/audio_player.dart';
import 'package:scriptus/extensions/deepl_service.dart';
import 'package:scriptus/extensions/document_service.dart';
import 'package:scriptus/extensions/file_services.dart';
import 'package:scriptus/models/meeting.dart';
import 'package:scriptus/models/transcript_data.dart';
import 'package:scriptus/models/transcript_segment.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/providers/meeting_provider.dart';
import 'package:scriptus/providers/sentence_providers.dart';
import 'package:scriptus/providers/settings_provider.dart';
import 'package:scriptus/providers/variable_monitor.dart';
import 'package:scriptus/repositories/transcript_data_repo.dart';
import 'package:scriptus/screen_parts/assigned_places.dart';
import 'package:scriptus/screen_parts/found_scriptures.dart';
import 'package:scriptus/screen_parts/saved_verses.dart';
import 'package:scriptus/screen_parts/search_widget.dart';
import 'package:scriptus/screen_parts/settings/settigns_dialog.dart';
import 'package:scriptus/services/kjv_from_db.dart';
import 'package:scriptus/services/meeting_service.dart';
import 'package:scriptus/services/show_context.dart';
import 'package:scriptus/services/load_from_DB.dart';

import 'screen_parts/object_viewer.dart';
import 'screen_parts/segment_table.dart';
import 'main.dart';

//global variables init for fuzzy search and Bible context display
List<String> searchReturn = []; //initialise object to return search results
List<TextSpan> spanResults = [];
Map<String, dynamic> data = {}; //initialise object to load kjv json
var clicks =
    0; //initialize variable for variableMonitorProvider to update the result widget
List<dynamic> fromAPItoKJV = [
  "Nothing retrieved yet..."
]; //init variable to store all results from kjv_from_db
List<dynamic> contextFromDB = [
  "Nothing loaded yet..."
]; //init variable to load Bible context from DB
String workingLanguage =
    ""; //init variable to hold language for language-specific selections (search, context)
String language = "";
List<Map<String, dynamic>>?
    searchScopeDB; //initialise map to store Bible from DB for fuzzy searches

var filteredSegmentsShortcuts; //pass filtered segments for use in shortcuts
var passTec; //for shortcuts, pass "tec"

TextSpan _buildTextSpan(String sentence) {
  List<String> parse = sentence.split('@@@');
  String sentenceParsed = parse[0];
  //var boldWordsParsed = parse[1];

  List<TextSpan> spans = [];
  var boldWordsParsed = parse[1].split(', ').map((e) => e.trim()).toList();
  print("Found words as input of _buildTextSpan: $boldWordsParsed");
  print(boldWordsParsed.length);

  sentenceParsed.split(" ").forEach((word) {
    String wordNoPunctuation = word.replaceAll(RegExp(r'[.,;:?!"\-\!]'), '');
    bool isBold = boldWordsParsed
        .map((e) => e.toLowerCase())
        .contains(wordNoPunctuation.toLowerCase());
    spans.add(TextSpan(
      text: "$word ",
      style:
          TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
    ));
  });
  print("Output of _buildTextSpan: $spans");
  return TextSpan(children: spans, style: TextStyle(fontSize: 16));
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.title});
  //var init = loadFromDB(); // at startup, load Bible for working language to |Map for fuzzy search
  final String title;
  //var init = main();
//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends ConsumerState<HomePage> {
  // var _json = [];
  // Map<String, dynamic> _json = {};
  // var _hover = [];
  // var list = [];
  // var _csv = [];
  // List<TranscriptSegment> segments = [];
  // List<int> paragraphBreaks = [];
  // String input = '';
  // List paragraphs = List.generate(136, (index) => index * 10000);
  // String fileName = '';
  // String filePath = '';
  // String returnedText = '';
  // List<BibleVerse> foundBibleVerses = [];
  // bool isParagraphBreak(TranscriptSegment segment) {
  //   return paragraphs.any((n) => segment.start < n && segment.end > n);
  // }
  // q.QuillController _controller = q.QuillController.basic();
  // final FocusNode _focusNode = FocusNode();

  // @override
  // void initState() {
  //   sc = ScrollController();
  //   super.initState();
  // }
  // void exportJson() async {
  // List<List<dynamic>> csvData = [
  //   ['start', 'end', 'text'],
  //   // header row
  //   ...segments.map((obj) => [obj.start, obj.end, obj.text]),
  //   // data rows
  // ];

  // String csv = const ListToCsvConverter().convert(csvData);

  // final directoryPath = await FilePicker.platform.getDirectoryPath();
  // if (directoryPath == null) {
  //   print('No directory selected');
  //   return;
  // }

  // final filePath = path.join(directoryPath, 'myFile.csv');
  // // specify the file path where you want to save the CSV file

  // final file = File(filePath);
  // await file.writeAsString(csv);

  // print('CSV file saved at $filePath');
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingsAsyncValue = ref.watch(meetingsProvider);
    final selectedMeeting = ref.watch(selectedMeetingProvider);
    final TranscriptData selectedTranscript =
        ref.watch(currentTranscriptProvider);
    final selectedTranscriptNotifier =
        ref.read(currentTranscriptProvider.notifier);
    final deepLCallStatusProvider = ref.watch(deepLCallStatusPProvider);
    final settings = ref.watch(settingsProvider);
    final sentenceState = ref.watch(sentenceProvider);
    var clicks = ref.watch(variablemonitorProvider);

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            meetingsAsyncValue.when(
              data: (meetings) {
                return SizedBox(
                  width: 240,
                  child: DropdownSearch<Meeting>(
                      selectedItem: selectedMeeting,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          // labelText: "Menu mode",
                          hintText: "Select Meeting",
                        ),
                      ),

                      // compareFn: (i, s) => i.properDate == s.properDate,
                      items: meetings,
                      itemAsString: (Meeting u) => u
                          .miroDate, // adjust this to display the property you want
                      popupProps: const PopupProps.menu(
                        isFilterOnline: true,
                        // showSelectedItems: true,
                        showSearchBox: true,

                        // showSelectedItems: true,
                        // disabledItemFn: (String s) => s.startsWith('I'),
                      ),
                      onChanged: (s) {
                        selectedTranscriptNotifier.setMeetingId(s?.id ?? 1);
                        ref
                            .read(selectedMeetingProvider.notifier)
                            .setMeeting(s!);
                        print(s);
                        if (s.mp3Link != '') {
                          print(s.mp3Link);
                          ref.read(audioPlayerProvider).stop();
                          // ref.read(audioPlayerProvider).dispose();
                          String mp3Link =
                              "${ref.watch(selectedMeetingProvider).mp3LinkBase}-${ref.watch(currentTranscriptProvider).mp3Language}.mp3";
                          print(mp3Link);
                          ref.read(audioPlayerProvider).setUrl(mp3Link);
                          // ref.read(audioPlayerProvider).load();
                          // ref
                          //     .read(audioPlayerControllerProvider)
                          //     .setAudioSource(AudioSource.uri(
                          // Uri.parse(selectedMeeting.mp3Link)));
                          ref.read(audioPlayerProvider).play();
                        }
                        // mainRepoProviderL.selectSermon(s!);
                      }),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              width: 230,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedTranscript.fileName,
                      style: const TextStyle(
                          fontSize: 13, overflow: TextOverflow.ellipsis)),
                  const SizedBox(height: 5),
                  if (selectedMeeting.id != null)
                    Text(selectedMeeting.miroDate,
                        style: const TextStyle(fontSize: 13)),
                  const SizedBox(),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            if (selectedTranscript.id != null)
              Container(
                margin: const EdgeInsets.only(left: 10),
                width: 40,
                child: Column(
                  children: [
                    Text(selectedTranscript.id.toString(),
                        style: const TextStyle(
                            fontSize: 13, overflow: TextOverflow.ellipsis)),
                    Text(selectedMeeting.id.toString(),
                        style: const TextStyle(
                            fontSize: 13, overflow: TextOverflow.ellipsis)),
                    Text(
                        ref
                            .watch(currentTranscriptProvider)
                            .meetingId
                            .toString(),
                        style: const TextStyle(
                            fontSize: 13, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            const SizedBox(
              width: 20,
            ),
            // Text("${segments.length}s-${paragraphBreaks.length}p"),
          ],
        ),
        // title: Text('Scriptor  ${sc.position.pixels}'),
        actions: [
          // MaterialButton(
          //   onPressed: () => clearTemporaryDirectory(),
          //   child: const Text('list tmp files'),
          // ),
          // MaterialButton(
          //   onPressed: () => _importCSV(),
          //   child: const Text('Open CSV'),
          // ),
          // MaterialButton(
          //   onPressed: () => importJson(),
          //   child: const Text('Open JSON'),
          // ),
          // MaterialButton(
          //   onPressed: () => importJson2(),
          //   child: const Text('Open JSON 2'),
          // ),
          // MaterialButton(
          //   onPressed: () => setAllWBQ(),
          //   child: const Text('Set WB'),
          // ),
          // if settingsprovider.showSearch is true, show search textfield
          const SearchWidget(),
          // const Center(child: Text('SK')),
          // Checkbox(
          //     visualDensity: VisualDensity.compact,
          //     checkColor: Colors.black,
          //     activeColor: Colors.white,
          //     value: settings.showSlovak,
          //     onChanged: ((value) => ref
          //         .read(settingsProvider.notifier)
          //         .updateSettings(
          //             settings.copyWith(showSlovak: !settings.showSlovak)))),
          // const SizedBox(
          //   width: 10,
          // ),
          Tooltip(
            message: 'Clean text',
            waitDuration: const Duration(seconds: 1),
            child: MaterialButton(
              onPressed: () => selectedTranscriptNotifier.cleanAllSegments(ref),
              // child: const Text('Clean All'),
              child: const Icon(Icons.cleaning_services),
            ),
          ),
          Tooltip(
            message: 'Translate All Segments to SK',
            waitDuration: const Duration(seconds: 1),
            child: MaterialButton(
              onPressed: () =>
                  selectedTranscriptNotifier.translateAllSegments(ref),
              child: Row(
                children: [
                  deepLCallStatusProvider == DeepLCallStatus.loading
                      ? Container(
                          margin: const EdgeInsets.only(right: 15),
                          height: 10,
                          width: 10,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Container(),
                  // const Text('Translate All SK'),
                  const Icon(Icons.language),
                ],
              ),
            ),
          ),
          // Tooltip(
          //     message: 'Open JSON',
          //     waitDuration: const Duration(seconds: 1),
          //     child: MaterialButton(
          //     onPressed: () => DocumentService().importJson(),
          //     // child: const Text('Open JSON …'),
          //     child: const Icon(Icons.folder_open_sharp),
          //   ),
          // ),
          // Tooltip(
          //     message: 'Open JSON 0',
          //     waitDuration: const Duration(seconds: 1),
          //     child: MaterialButton(
          //     onPressed: () => DocumentService().importJson(),
          //     // child: const Text('Open JSON …'),
          //     child: const Icon(Icons.folder_open_sharp),
          //   ),
          // ),
          Tooltip(
            message: 'Open JSON',
            waitDuration: const Duration(seconds: 1),
            child: MaterialButton(
              onPressed: () => DocumentService().importJson3(ref),
              // child: const Text('Open JSON …'),
              child: const Icon(Icons.folder_open_sharp),
            ),
          ),

          Tooltip(
            message: 'Open JSON 11Labs',
            waitDuration: const Duration(seconds: 1),
            child: MaterialButton(
              onPressed: () => DocumentService().importJson11Labs(ref),
              // child: const Text('Open JSON …'),
              child: const Icon(Icons.folder_open_outlined),
            ),
          ),
          // const SizedBox(
          //   width: 10,
          // ),

          // MaterialButton(
          //   onPressed: () => _jsonToDelta(),
          //   child: const Text('Open JSON 2 Delta'),
          // ),
          // MaterialButton(
          //   onPressed: () => exportCsv(),
          //   child: const Text('Save CSV'),
          // ),
          // MaterialButton(
          //   onPressed: () => DocumentService().exportToMarkdown(
          //       ref, selectedTranscript.segments),
          //   child: const Text('Export MD'),
          // ),
          Tooltip(
            message: 'Save DE To HTML',
            waitDuration: const Duration(seconds: 1),
            child: MaterialButton(
              onPressed: () {
                DocumentService().exportToHtml(
                    selectedTranscript.fileName,
                    selectedTranscript.filePath,
                    selectedTranscript.segments,
                    'de',
                    ref);
              },
              // child: const Text('HTML DE …'),
              child: CountryFlag.fromCountryCode(
                'DE',
                height: 20,
                width: 32,
                shape: Rectangle(),
              ),
            ),
          ),
          Tooltip(
            message: 'Save EN To HTML',
            waitDuration: const Duration(seconds: 1),
            child: MaterialButton(
              onPressed: () {
                DocumentService().exportToHtml(
                    selectedTranscript.fileName,
                    selectedTranscript.filePath,
                    selectedTranscript.segments,
                    'en',
                    ref);
              },
              child: CountryFlag.fromCountryCode(
                'GB',
                height: 20,
                width: 32,
                shape: Rectangle(),
              ),
              // child: const Text('HTML SK …'),
            ),
          ),
          Tooltip(
            message: 'Save SK To HTML',
            waitDuration: const Duration(seconds: 1),
            child: MaterialButton(
              onPressed: () {
                DocumentService().exportToHtml(
                    selectedTranscript.fileName,
                    selectedTranscript.filePath,
                    selectedTranscript.segments,
                    'sk',
                    ref);
              },
              child: CountryFlag.fromCountryCode(
                'SK',
                height: 20,
                width: 32,
                shape: Rectangle(),
              ),
              // child: const Text('HTML SK …'),
            ),
          ),
          Tooltip(
            message: 'Save To JS HTML',
            waitDuration: const Duration(seconds: 1),
            child: MaterialButton(
              onPressed: () {
                DocumentService().exportToHtmlJs(
                  selectedTranscript.fileName,
                  selectedTranscript.filePath,
                  selectedTranscript.segments,
                );
              },
              child: const Text('JS …'),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // MaterialButton(
          //   onPressed: () {
          //     var ctp = selectedTranscript;
          //     DocumentService().copyToClipboardHtml(ctp.segments);
          //   },
          //   child: const Icon(Icons.copy),
          //   //  Text('Export HTML …'),
          // ),
          // MaterialButton(
          //   onPressed: () => _save(),
          //   child: const Text('Save TXT'),
          // ),
          // MaterialButton(
          //   onPressed: () => exportJson(),
          //   child: const Text('Save JSON'),
          // ),
          Consumer(
              builder: (context, ref, child) => Tooltip(
                    message: 'Save finnished sermon to API',
                    waitDuration: const Duration(seconds: 1),
                    child: MaterialButton(
                      color: Colors.lightGreen,
                      hoverColor: Colors.green,
                      onPressed: () async {
                        int id = await ref
                            .read(transcriptRepositoryProvider)
                            .saveTranscriptData(selectedTranscript);
                        selectedTranscriptNotifier.saveId(id);
                      },
                      child: const Text('API'),
                    ),
                  )),
          // Consumer(
          //     builder: (context, ref, child) => MaterialButton(
          //           color: Colors.lightGreen,
          //           onPressed: () => {
          //             print(selectedMeeting.mp3Link),
          //             ref.read(audioPlayerControllerProvider).setAudioSource(
          //                 AudioSource.uri(Uri.parse(
          //                     selectedMeeting.mp3Link))),
          //           },
          //           child: const Text('Load Audio'),
          //         )),
          const SizedBox(width: 10),
          Consumer(
              builder: (context, ref, child) => Tooltip(
                    message: 'Save sermon to JSON for later use',
                    waitDuration: const Duration(seconds: 1),
                    child: MaterialButton(
                      hoverColor: Colors.green,
                      focusColor: Colors.lightGreen,
                      color: Colors.lightGreen,
                      onPressed: () =>
                          selectedTranscript.exportTranscriptToJson(ref),
                      child: const Icon(Icons.save),
                      // Text('Save'),
                    ),
                  )),
          const SizedBox(width: 10),
          Consumer(
              builder: (context, ref, child) => Tooltip(
                    message: 'Open JSON file',
                    waitDuration: const Duration(seconds: 1),
                    child: MaterialButton(
                      color: Colors.lightGreen,
                      hoverColor: Colors.green,
                      onPressed: () =>
                          selectedTranscript.loadTranscriptFromJson(ref),
                      child: const Icon(Icons.folder_open_sharp),
                      // child: const Text('Open'),
                    ),
                  )),

          // const LoadMeetingsButton(),
          const SizedBox(width: 10),
          const SettingsDialog(),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: SegmentTable()
              // RichText(
              //   text: TextSpan(
              //     style: TextStyle(
              //       color: Colors.white54,
              //       fontSize: 22,
              //       fontFamily: GoogleFonts.robotoSlab().fontFamily,
              //       fontWeight: FontWeight.w100,
              //       // fontFeatures: [FontFeature.superscripts()],
              //       // package: ,
              //       // wordSpacing: 22,
              //       // textBaseline: TextBaseline.starteographic,
              //       // fontStyle: FontStyle.italic,
              //       // fontVariations: ,
              //       height: 2,
              //     ),
              //     children: [
              //       // for (var a in _csv) TextSpan(text: a[2].toString()),
              //       // for (var a in segments)
              //       for (var a in td.segments)
              //         TextSpan(
              //             style: TextStyle(
              //               // decoration: TextDecoration.underline,
              //               color:
              //                   _hover.contains(a.start) ? Colors.blue : null,
              //             ),
              //             children: [
              //               if (paragraphBreaks.contains(a.start))
              //                 TextSpan(
              //                   style: const TextStyle(
              //                       height: .8,
              //                       color: Colors.blueGrey,
              //                       fontSize: 15),
              //                   text:
              //                       "\n\n\n${formatDuration(a.start)} - ${formatDuration(a.end)} - ${a.start} - ${a.end}\n",
              //                 ),
              //               // TextSpan(
              //               //   style: TextStyle(
              //               //       height: .8, color: Colors.blueGrey, fontSize: 15),
              //               //   text: "\n\n${a.start} - ${a.end}\n",
              //               // ),
              //               TextSpan(
              //                 onEnter: (_) =>
              //                     setState(() => _hover.add(a.start)),
              //                 onExit: (_) =>
              //                     setState(() => _hover.remove(a.start)),
              //                 recognizer: TapGestureRecognizer()
              //                   ..onTap = () {
              //                     addParagraphBreak(a.start);
              //                     ref.read(sentenceProvider.notifier).update(
              //                         (state) => TranscriptSegment(
              //                             start: a.start,
              //                             end: a.end,
              //                             text: a.text));

              //                     // getGermanBibleReference(
              //                     //     a.text.trim(), a.start);
              //                   },
              //                 text: "${a.text.trim()} ",
              //                 // style: TextStyle(
              //                 //   fontWeight: FontWeight.normal,
              //                 // ),
              //               )
              //             ]),
              //       // leading: IconButton(
              //       //   icon: Icon(
              //       //     Icons.star,
              //       //     color: paragraphBreaks.contains(a[1])
              //       //         ? Colors.amber
              //       //         : Colors.red,
              //       //   ),
              //       //   onPressed: () => addParagraphBreak(a[1]),
              //       // ),
              //       // subtitle: Text(
              //       //   "${a[0]} - ${a[1]}",
              //       // ),
              //       // style: Theme.of(context).textTheme.bodyMedium,
              //     ],
              //   ),
              // ),
              ),
          Container(
            color: Colors.black87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (settings.showObject)
                  ObjectAttributesTable(
                    attributesMap: sentenceState.toJson(),
                  ),
                if (selectedMeeting.mp3Link != '')
                  Container(
                    width: 400,
                    height: 70,
                    color: Colors.black,
                    child: const AudioPlayerWidget(),
                  ),
                // // Container(
                // //   padding: const EdgeInsets.all(12),
                // //   width: 400,
                // //   height: 480,
                // //   color: Colors.blueGrey,
                // //   child: EditSentence(),
                // // ),
                // // meetingsAsyncValue.when(
                // //   data: (meetings) {
                // //     return SizedBox(
                // //       width: 200,
                // //       height: 500,
                // //       child: ListView.builder(
                // //           shrinkWrap: true,
                // //           itemCount: meetings.length,
                // //           itemBuilder: (context, index) {
                // //             return ListTile(
                // //               title: Text(meetings[index].properDate),
                // //               onTap: () {
                // //                 ref
                // //                     .read(currentTranscriptProvider.notifier)
                // //                     .setMeetingId(meetings[index].id ?? 1);
                // //                 // mainRepoProviderL.selectSermon(s!);
                // //                 Navigator.pop(context);
                // //               },
                // //             );
                // //             // compareFn: (i, s) => i.properDate == s.properDate,
                // //           }),
                // //     );
                // //   },
                // //   loading: () => CircularProgressIndicator(),
                // //   error: (err, stack) => Text('Error: $err'),
                // // ),
                // const SizedBox(
                //   height: 10,
                // ),
                if (settings.showFound)
                  const Expanded(
                    /// Segment Places found through OpenAI API
                    child: FoundScriptures(),
                  ),
                if (settings.showKJV)
                  SelectableText.rich(TextSpan(
                      text: "Search Results:", // Additional static text
                      style: TextStyle(fontSize: 15, color: Colors.red))),
                //if (settings.showFound) SelectableText(kjvInput),
                if (settings.showKJV)
                  Container(
                    height: 250,
                    width: 400, // Define the height/width for the Container
                    padding: EdgeInsets.symmetric(
                        vertical: 12.0), // Add padding around the ListView
                    decoration: BoxDecoration(
                      // Background color
                      border: Border.all(
                          color: Colors.blue, width: 2), // Border styling
                    ),
                    child: ListView.builder(
                        itemCount:
                            searchReturn.length, // Number of items in the list
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: SelectableText.rich(_buildTextSpan(
                                searchReturn[index])), // Display each item
                            trailing: (searchReturn[index].length > 20 &&
                                    !searchReturn[index].contains("***"))
                                // Conditional check
                                ? GestureDetector(
                                    onTap: () {
                                      print('Leading icon tapped!');
                                      contextFromDB = [];

                                      if (searchReturn[index].length > 20) {
                                        var init = contextByID(
                                            searchReturn[index],
                                            12,
                                            ref); //scope for context, -X verses/+X verses
                                        print(
                                            'Item clicked through leading icon: ${searchReturn[index]}');
                                      }
                                    },
                                    child: Tooltip(
                                      message:
                                          'Press Arrow to Show Context for Scripture', // Tooltip message
                                      child: Icon(Icons.arrow_right),
                                    ))
                                : null,
                            // If condition is false, no leading widget,
                          );
                        }),
                    /*style: TextStyle(
                            fontSize: 20, // Set the desired font size here
                            color:
                                Colors.white, // Optional: Customize text color
                            //fontWeight: FontWeight
                           */ //    .bold, // Optional: Customize font weight),
                  ),
                if (settings.showKJV) //display fromAPItoKJV results
                  Container(
                    height: 250,
                    width: 400, // Define the height/width for the Container
                    padding: EdgeInsets.symmetric(
                        vertical: 12.0), // Add padding around the ListView
                    decoration: BoxDecoration(
                      // Background color
                      border: Border.all(
                          color: Colors.blue, width: 2), // Border styling
                    ),
                    child: ListView.builder(
                        itemCount:
                            fromAPItoKJV.length, // Number of items in the list
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: SelectableText(
                                fromAPItoKJV[index]), // Display each item
                            trailing: fromAPItoKJV[index].length > 20
                                ? GestureDetector(
                                    //leading: Icon(Icons.star),
                                    onTap: () {
                                      print('Leading icon tapped!');
                                      contextFromDB = [];

                                      if (fromAPItoKJV[index].length > 20) {
                                        var init = contextByID(
                                            fromAPItoKJV[index],
                                            12,
                                            ref); //scope for context, -X verses/+X verses
                                        print(
                                            'Item clicked: ${fromAPItoKJV[index]}');
                                      }
                                    },
                                    child: Tooltip(
                                      message:
                                          'Press Arrow to Show Context for Scripture', // Tooltip message
                                      child: Icon(Icons.arrow_right),
                                    ))
                                : null,
                          );
                        }),
                    /*style: TextStyle(
                            fontSize: 20, // Set the desired font size here
                            color:
                                Colors.white, // Optional: Customize text color
                            //fontWeight: FontWeight
                           */ //    .bold, // Optional: Customize font weight),
                  ),
/*Experimental part to add FutureBuilder to show results from kjv_from_db.dart
                if (settings.showKJV)
                  Container(
                    height: 200,
                    width: 400, // Define the height/width for the Container
                    padding:
                        EdgeInsets.all(10), // Add padding around the ListView
                    decoration: BoxDecoration(
                      // Background color
                      border: Border.all(
                          color: Colors.blue, width: 2), // Border styling
                    ),
                    child: FutureBuilder<List<String>>(
        future = getKJVVerseById(1, 1, 1, 1), // Fetching the list asynchronously
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          // Handle the different states of the Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error handling
          } else if (snapshot.hasData) {
            // If the Future has data, show the list
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]), // Display each item
                );
              },
            );
          } else {
            return Center(child: Text('No data available')); // In case there's no data
          }
        },
      ),
//end of experimental part
*/
                const SizedBox(
                  height: 10,
                ),
                Text(" "),
                // Text(selectedTranscript.meetingId.toString()),
                // Text(settings.showSavedFromApi.toString()),
                if (selectedTranscript.meetingId > 0 &&
                    settings.showSavedFromApi)
                  const Expanded(
                    /// API places
                    child: SavedVerses(),
                  ),
                if (settings.showAssignedAll)
                  const SizedBox(
                    height: 200,

                    /// Segment Places
                    child: AssignedPlaces(),
                  ),
              ],
            ),
          ),
          if (settings.showContext)
            Container(
              color:
                  const Color.fromARGB(255, 62, 81, 90), // Set background color
              child: SizedBox(
                width: 300, // Set fixed width

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowContext(), //Display Bible Context - Scriptures before and after a selected Scripture
                  ],
                ),
              ),
            )
        ],
      ),
      // ),
    );
  }
}
