import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:http/http.dart' as http;
import 'package:scriptus/models/bible_verse.dart';
import 'dart:convert';
import 'package:scriptus/models/place.dart';
import 'package:scriptus/services/api_service.dart';
import 'package:scriptus/services/msk_db_service.dart';

// create place repository provider
final placeRepositoryProvider = Provider<PlaceRepository>((ref) {
  return PlaceRepository();
});

class PlaceRepository {
  final Dio _dio = ApiService().dio;

  // final http.Client _client;
  // PlaceRepository({http.Client? client}) : _client = client ?? http.Client();
  // Dio dioConnection() {
  //   Dio dio = Dio();
  //   dio.options.baseUrl = _baseUrl;
  //   dio.options.connectTimeout = const Duration(seconds: 60); //5s
  //   dio.options.receiveTimeout = const Duration(seconds: 60);
  //   // dio.options.headers = {
  //   //   HttpHeaders.userAgentHeader: 'dio',
  //   //   'common-header': 'xx'
  //   // };
  //   return dio;
  // }
  // Dio get dio => dioConnection();

  Future<List<Place>> getPlaces() async {
    final response = await _dio.get('/places');

    if (response.statusCode == 200) {
      final data = json.decode(response.data);

      if (data is List) {
        return data.map((item) => Place.fromJson(item)).toList();
      } else {
        throw const FormatException('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load places: ${response.statusCode}');
    }
  }

  Future<Place> createPlace(Place place) async {
    final response = await _dio.post(
      '/places',
      data: place,
    );

    if (response.statusCode == 201) {
      return Place.fromJson(json.decode(response.data));
    } else {
      throw Exception('Failed to create place: ${response.statusCode}');
    }
  }

  Future savePlace(Place place) async {
    print('savePlace');
    Map m = place.toMap();
    m['createdAt'] = DateTime.now().toString();
    m['createdBy'] = 1;
    m['language'] = 'de';
    print(m);
    // String j = jsonEncode(m);
    // print(j);

    // var n = MskDBProvider().getGermanBookid(place);
    // m['bookId'] = n;

    try {
      await _dio.post(
        '/places',
        data: m,
      );
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }

    /// SAVE slovak version
    MskDBProvider mskDBProvider = MskDBProvider();

    BibleVerse slovak =
        await mskDBProvider.getVerseInOtherLanguage(place, 'sk');
    print('slovak');
    print(slovak);
    Place slovakPlace = Place(
      language: 'sk',
      meetingId: place.meetingId,
      timePosition: place.timePosition,
      bookId: slovak.bookId ?? 0,
      chapterNumber: slovak.bibleChapter ?? 0,
      bookName: slovak.bookAbb ?? '',
      verseStartNumber: slovak.verse ?? 0,
      verseEndNumber: slovak.verse ?? 0,
      verseStartId: slovak.id,
      verseEndId: slovak.id,
      verseText: slovak.content,
      createdAt: DateTime.now(),
      createdBy: 1,
      isReference: place.isReference,
      referencePosition: place.referencePosition,
      keepWithPrevious: place.keepWithPrevious,
      note: place.note,
      segmentId: place.segmentId,
      sermonId: place.sermonId,
      transcriptDataId: place.transcriptDataId,
    );
    print(slovakPlace);
    Map ms = slovakPlace.toMap();
    ms['createdAt'] = DateTime.now().toString();
    ms['createdBy'] = 1;
    print(ms);
    // String js = jsonEncode(m);
    // print(js);

    try {
      await _dio.post(
        '/places',
        data: ms,
      );
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }
    // var response = await dio.post(
    //   '/places',
    //   data: j,
    // );
  }

  // Future<void> savePlaceToApi(Place place) async {
  //   try {
  //     final response = await _dio.post(
  //       '/places',
  //       data: place.toJson(),
  //     );

  //     if (response.statusCode != 201) {
  //       throw Exception('Failed to save place');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to save place: $e');
  //   }
  // }

  Future<Place> updatePlace(Place place) async {
    final response = await _dio.put(
      '/places/${place.id}',
      data: place,
    );

    if (response.statusCode == 200) {
      return Place.fromJson(json.decode(response.data));
    } else {
      throw Exception('Failed to update place: ${response.statusCode}');
    }
  }

  Future<void> deletePlace(int id) async {
    final response = await _dio.delete(
      '/places/$id',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete place: ${response.statusCode}');
    }
  }

  void dispose() {
    _dio.close();
  }
}
