import 'package:scriptus/extensions/utilities.dart';
import 'package:scriptus/models/place.dart';

class TextGenerationService {
  String generateSegmentText(segment) {
    String segmentText = segment.text;
    List<Place> places = segment.places;
    String out = '';

    if (places.isEmpty) {
      return segmentText;
    }

    // sort places by referencePosition into a newPlaces array

    List<Place> sortedPlaces = List.from(places);
    sortedPlaces.removeWhere((p) => p.referencePosition == null);
    sortedPlaces
        .sort((a, b) => a.referencePosition!.compareTo(b.referencePosition!));
    print(places);
    print(sortedPlaces);

    if (sortedPlaces.isEmpty) {
      return segmentText;
    }

    for (var p in sortedPlaces) {
      out =
          '${segmentText.substring(0, p.referencePosition!)} [${p.bookName} ${p.chapterNumber}:${p.verseStartNumber}] ${segmentText.substring(p.referencePosition!)}';
    }
    out = out.replaceAll('  ', ' ');
    return out;
  }

  generateText(segments, paragraphBreaks) {
    String out = '';
    for (var s in segments) {
      print(paragraphBreaks);
      if (paragraphBreaks.contains(s.end)) {
        out = '''$out ${s.text}
        ''';
      } else {
        out = out + s.text;
      }
    }
    return out;
  }

  _save(segments, paragraphBreaks) async {
    // Future<File> writeCounter() async {
    final file = await localFile;
    final text = generateText(segments, paragraphBreaks);
    // Write the file
    return file.writeAsString(text);
    // }
  }
}
