import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scriptus/models/bible_verse.dart';
import 'package:scriptus/providers/current_doc_provider.dart';
import 'package:scriptus/services/mng_database_service.dart';
import 'package:tuple/tuple.dart';

enum ApiCallStatus {
  initial,
  loading,
  success,
  error,
}

final apiCallStatusProvider =
    StateNotifierProvider<ApiCallStatusNotifier, ApiCallStatus>((ref) {
  return ApiCallStatusNotifier();
});

class ApiCallStatusNotifier extends StateNotifier<ApiCallStatus> {
  ApiCallStatusNotifier() : super(ApiCallStatus.initial);
  void set(ApiCallStatus status) {
    state = status;
  }
}

class OpenAIService {
  Future<List<BibleVerse>> getGermanBibleReference(
      WidgetRef ref, String text, int index) async {
    final apiCallStatusNotifier = ref.read(apiCallStatusProvider.notifier);
    apiCallStatusNotifier.set(ApiCallStatus.loading);
    const apiKey = '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';
    const url = 'https://api.openai.com/v1/chat/completions';

    // final prompt =
    //     'USER: The assistant is a helpful and precise German Bible researcher. He uses Menge or Luther translation of Bible\n\nHuman: Find 3 verses in german Bible closest matching to following text: $text\nOutput format should be comma-separated values of "Bible Book Chapter:Verse"';

    var functions = [
      {
        "name": "get_bible_verses",
        "description":
            "Retrieve Bible verses text from the Bible based on book, chapter, start_verse_number, end_verse_number parameters",
        "parameters": {
          "type": "object",
          "properties": {
            "verses": {
              "type": "array",
              "items": {
                "book_short_name": {
                  "type": "string",
                  "description":
                      "German abbreviation of bible book name striclty from enum values.",
                  "enum": [
                    "1Mo",
                    "2Mo",
                    "3Mo",
                    "4Mo",
                    "5Mo",
                    "Jos",
                    "Ri",
                    "Rt",
                    "1Sam",
                    "2Sam",
                    "1Kö",
                    "2Kö",
                    "1Chr",
                    "2Chr",
                    "Esr",
                    "Neh",
                    "Est",
                    "Hi",
                    "Ps",
                    "Spr",
                    "Pred",
                    "Hl",
                    "Jes",
                    "Jer",
                    "Kla",
                    "Hes",
                    "Dan",
                    "Hos",
                    "Joe",
                    "Am",
                    "Ob",
                    "Jon",
                    "Mi",
                    "Nah",
                    "Hab",
                    "Zeph",
                    "Hag",
                    "Sach",
                    "Mal",
                    "Mt",
                    "Mk",
                    "Lk",
                    "Joh",
                    "Apg",
                    "Röm",
                    "1Kor",
                    "2Kor",
                    "Gal",
                    "Eph",
                    "Phil",
                    "Kol",
                    "1Th",
                    "2Th",
                    "1Tim",
                    "2Tim",
                    "Tit",
                    "Phlm",
                    "Hebr",
                    "Jak",
                    "1Pt",
                    "2Pt",
                    "1Jo",
                    "2Jo",
                    "3Jo",
                    "Jud",
                    "Offb"
                  ],
                },
                "chapter_number": {
                  "type": "string",
                  "description": "Chapter Number of bible book"
                },
                "start_verse_number": {
                  "type": "string",
                  "description": "Starting Verse Number"
                },
                "end_verse_number": {
                  "type": "string",
                  "description": "Ending Verse Number"
                },
              },
            },
          },
          "required": [
            "book_short_name",
            "chapter_number_number",
            "start_verse_number"
          ],
        },
      }
    ];

    //         "content":
    //             '''Find 3 verses in german Bible closest matching to following text. Output format must be strictly no other text, only comma and space separated values where each value is a bible verse reference strictly in this format: "Book ChapterNumber:VerseNumber".
    //             The text of the Bible verse must not be included in the response, only short bible reference strictly in this format: "Book ChapterNumber:VerseNumber" – without quotes.
    //             Include absolutely no other text in the response string, only comma-separated values of Bible references! Bible chapter and verse must be separated with colon character.
    //             Book name must be followed by a space character.
    //             Book name must use strictly only following short names: "1Mo","2Mo","3Mo","4Mo","5Mo","Jos","Ri","Rt","1Sam","2Sam","1Kö","2Kö","1Chr","2Chr","Esr","Neh","Est","Hi","Ps","Spr","Pred","Hl","Jes","Jer","Kla","Hes","Dan","Hos","Joe","Am","Ob","Jon","Mi","Nah","Hab","Zeph","Hag","Sach","Mal","Mt","Mk","Lk","Joh","Apg","Röm","1Kor","2Kor","Gal","Eph","Phil","Kol","1Th","2Th","1Tim","2Tim","Tit","Phlm","Hebr","Jak","1Pt","2Pt","1Jo","2Jo","3Jo","Jud","Offb"
    // The text: $text'''

    // "1.Mose","2.Mose","3.Mose","4.Mose","5.Mose","Jos","Rich","Ruth","1Sam","2Sam","1.Kön","2.Kön","1.Chr","2.Chr","Esra","Neh","Est","Hiob","Ps","Spr","Pred","Hld","Jes","Jer","Klgl","Hes","Dan","Hos","Joel","Am","Obd","Jona","Mich","Nah","Hab","Zeph","Hag","Sach","Mal","Mt","Mk","Lk","Joh","Apg","Röm","1.Kor","2.Kor","Gal","Eph","Phil","Kol","1.Thess","2.Thess","1.Tim","2.Tim","Tit","Phlm","Heb","Jak","1.Petr","2.Petr","1.Joh","2.Joh","3.Joh","Jud","Offb"
    final prompt = [
      {
        "role": "system",
        "content":
            "The assistant is a helpful and precise German Bible researcher. He uses Menge or Luther translation of Bible."
      },
      {
        "role": "user",
        "content":
            '''Find 5 passages in german Bible closest matching to following text.
            Book name must use strictly only following short names: 
            "1Mo","2Mo","3Mo","4Mo","5Mo","Jos","Ri","Rt","1Sam","2Sam","1Kö","2Kö","1Chr","2Chr","Esr","Neh","Est","Hi","Ps","Spr","Pred","Hl","Jes","Jer","Kla","Hes","Dan","Hos","Joe","Am","Ob","Jon","Mi","Nah","Hab","Zeph","Hag","Sach","Mal","Mt","Mk","Lk","Joh","Apg","Röm","1Kor","2Kor","Gal","Eph","Phil","Kol","1Th","2Th","1Tim","2Tim","Tit","Phlm","Hebr","Jak","1Pt","2Pt","1Jo","2Jo","3Jo","Jud","Offb"
    The text: $text'''
      }
    ];

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final data = {
      'model': 'gpt-4-1106-preview',
      'messages': prompt,
      'max_tokens': 400,
      'temperature': 0.0,
      'functions': functions,
      'top_p': 0.5,
      'frequency_penalty': 0,
      'presence_penalty': 0,
      'n': 1,
      'stop': null,
    };

    final dio = Dio();
    final response = await dio.post(url,
        data: jsonEncode(data), options: Options(headers: headers));
    // print('response.data');
    // print(response.data);
    // print(response.data.usage);
    final responseData =
        response.data['choices'][0]['message']['function_call']['arguments'];

    // final List verses =
    //     responseData['choices'][0]['message']['function_call']['arguments'];
    // print(responseData);
    final decoded = jsonDecode(responseData);
    final decodedVerses = decoded['verses'];
    print(decodedVerses);
    List<BibleVerse> verses = [];

    for (var i = 0; i < decodedVerses.length; i++) {
      String b = decodedVerses[i]['book'];
      b = replaceWithMap(b);

      final int c = int.parse(decodedVerses[i]['chapter'].toString());
      final int sv =
          int.parse(decodedVerses[i]['start_verse_number'].toString());
      final int ev = (decodedVerses[i]['end_verse_number']) != null
          ? int.parse(decodedVerses[i]['end_verse_number'].toString())
          : sv;

      final bool isOneVerse = sv == ev;

      // ak je start verse a end verse rovnake, pridam ho
      if (isOneVerse) {
        final Tuple3<String, int, int> t = Tuple3(b, c, sv);
        var v = await BibleDBProvider().getDEBibleVerseFromAPIReference(t);
        if (v != null) {
          verses.add(v);
        }
        print('ONE VERSE');
        print(verses);
      } else {
        // ak nie, pridam start verse a potom vsetky verses medzi nimi
        // final Tuple3<String, String, String> t = Tuple3(b, c, sv);
        // BibleVerse v = await DBProvider().getBibleVerseFromReference(t);
        // verses.add(v);

        //
        List<Tuple3> l = List<Tuple3>.generate(
          ev - sv + 1,
          (i) => Tuple3(b, c, sv + i),
        );

        print('MORE VERSES');
        print(l);
        for (var i = 0; i < l.length; i++) {
          var v2 =
              await BibleDBProvider().getDEBibleVerseFromAPIReference(l[i]);
          if (v2 != null) {
            verses.add(v2);
          }
        }
        // Tuple3<String, String, String> t = Tuple3(b, c, sv);
        // BibleVerse v = await DBProvider().getBibleVerseFromReference(t);
        // verses.add(v);
      }
      //    { choices: [{index: 0, message: {role: assistant, content: null,
      //    function_call: {name: get_bible_verses, arguments: {
      // "verses": [
      //   {
      //     "book": "Apg",
      //     "chapter": 26,
      //     "start_verse_number": 16,
      //     "end_verse_number": 16
      //   },

      // jsonDecode(response.data);
      // String completionText =
      //     responseData['choices'][0]['message']['content'].toString().trim();

      // print('completionText');
      // print(completionText);
      // completionText = completionText.replaceAll('"', '');
      // print(completionText);
      // final referenceParts = parseCompletionText2(completionText);
      // List<BibleVerse> verses = [];
      // // final referenceParts = completionText.split(':').last.trim().split(' ');
      // for (var i = 0; i < referenceParts.length; i++) {
      //   final book = referenceParts[i]['book'];
      //   final chapter = referenceParts[i]['chapter'];
      //   final verse = referenceParts[i]['verse'];
      //   print('book: $book, chapter: $chapter, verse: $verse');

      //   Tuple3<String, String, String> t = Tuple3(book!, chapter!, verse!);
      //   BibleVerse v = await DBProvider().getBibleVerseFromReference(t);
      //   verses.add(v);
      // }
      // // final book = referenceParts[0]['book'];
      // // final chapter = referenceParts[0]['chapter'];
      // // final verse = referenceParts[0]['verse'];
      // // setState(() {
      // //   returnedText = completionText;
      // //   foundBibleVerses = verses;
      // // });
      // return [];
    }
    // index ??= ref.watch(editedSegmentIndexProvider.notifier).state;
    ref
        .read(currentTranscriptProvider.notifier)
        .addFoundVersesToSegment(index ?? 0, verses);
    apiCallStatusNotifier.set(ApiCallStatus.success);

    return verses;
  }

  String replaceWithMap(String original) {
    final List<Map<String, String>> replacements = [
      {'1Joh': '1Jo'},
      {'2Joh': '2Jo'}
    ];
    String result = original;
    for (var replacement in replacements) {
      replacement.forEach((key, value) {
        result = result.replaceAll(key, value);
      });
    }
    return result;
  }

  List<String> parseMultipeBibleVerses(String verseRange) {
    final RegExp exp =
        RegExp(r'^([\w\s\.0-9\u00C0-\u017F]+)\s(\d+):(\d+)-(\d+)$');
    final Match? match = exp.firstMatch(verseRange);

    if (match != null) {
      final String book = match.group(1)!;
      final String chapter = match.group(2)!;
      final int startVerse = int.parse(match.group(3)!);
      final int endVerse = int.parse(match.group(4)!);

      return List<String>.generate(
        endVerse - startVerse + 1,
        (i) => '$book $chapter:${startVerse + i}',
      );
    } else {
      return [];
    }
  }

  List<Map<String, String>> parseCompletionText2(String text) {
    var result = <Map<String, String>>[];
    // text = text.replaceAll("Röm", "Rm");

    var items = text.split(', ');
    // RegExp exp = RegExp(r'^([\p{L}\s\.]+)\s(\d+):(\d+)$', unicode: true);

    print(items);
    List<String> finalItems = [];

    for (String item in items) {
      // print(item);
      if (item.contains('-')) {
        List<String> multiple = [];
        multiple = parseMultipeBibleVerses(item);

        if (multiple.isNotEmpty) {
          finalItems.addAll(multiple);
        }
      } else {
        finalItems.add(item);
      }
    }

    for (String item in finalItems) {
      // print(item);
      result.add(string2Map(item));
      // print(result);
      // return result;
    }
    // print(result);
    return result;
  }

  string2Map(String text) {
    RegExp exp = RegExp(r'^([\p{L}\s\.\d]+)\s(\d+):(\d+)$', unicode: true);
    Match? match = exp.firstMatch(text);
    print(match);

    if (match != null) {
      var book = match.group(1)!;
      var chapter = match.group(2)!;
      var verse = match.group(3)!;

      return {
        'book': book,
        'chapter': chapter,
        'verse': verse,
      };
    }
  }

  List<Map<String, String>> parseCompletionText(String text) {
    var result = <Map<String, String>>[];
    var lines = text.split('\n');
    var exp = RegExp(r'^\d+\.\s(.+)\s(\d+):(\d+)$');

    for (var line in lines) {
      var match = exp.firstMatch(line);

      if (match != null) {
        var book = match.group(1)!;
        var chapter = match.group(2)!;
        var verse = match.group(3)!;

        result.add({
          'book': book,
          'chapter': chapter,
          'verse': verse,
        });
      }
    }

    return result;
  }

  // void main() {
  //   String text =
  //       "1. 1. Thessalonicher 4:13\n2. Jeremiah 7:16\n3. Jeremiah 11:14";
  //   print(parseCompletionText(text));
  // }
}
