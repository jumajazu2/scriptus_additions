import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scriptus/models/transcript_data.dart';
import 'package:scriptus/models/transcript_segment.dart';

final transcriptRepositoryProvider = Provider<TranscriptRepository>((ref) {
  return TranscriptRepository();
});

class TranscriptRepository {
  final String baseUrl = 'http://www.misia.sk:7989';
  final Dio dio = Dio();

  final headers = {
    'Content-Type': 'application/json',
  };

  Future<int> saveTranscriptData(TranscriptData data) async {
    TranscriptData datas = data.copyWith(id: null);
    Map<String, dynamic> datasjson = datas.toJson();
    datasjson.remove("id");

    if (datasjson["segments"] != null) {
      datasjson["transcript_segments_attributes"] =
          (datasjson["segments"] as List).map((segment) {
        var segmentMap = (segment as TranscriptSegment).toJson();
        segmentMap.remove("transcriptDataId");
        segmentMap.remove("id");
        segmentMap.remove("assignedScripture");
        segmentMap.remove("places");
        segmentMap.remove("foundScriptures");
        return segmentMap;
      }).toList();
      datasjson.remove("segments"); // remove the old segments field
    }

    try {
      final response = await dio.post('$baseUrl/transcript_data',
          data: datasjson, options: Options(headers: headers));

      if (response.statusCode == 201) {
        print(response);
        return response.data;
      } else {
        throw Exception('Failed to save transcript data');
      }
    } catch (e) {
      throw Exception('Failed to save transcript data: $e');
    }
  }

  // Future<void> savePlace(Place place) async {
  //   try {
  //     final response = await dio.post(
  //       '$baseUrl/places',
  //       data: place.toJson(),
  //     );

  //     if (response.statusCode != 201) {
  //       throw Exception('Failed to save place');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to save place: $e');
  //   }
  // }

  // Future<void> addPlaceToSegment(TranscriptSegment segment, Place place) async {
  //   // Add the place to the segment
  //   segment.places.add(place);

  //   // Save the place to the API
  //   await savePlace(place);
  // }
}
