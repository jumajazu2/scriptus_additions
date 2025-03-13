import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:http/http.dart' as http;
import 'package:scriptus/models/meeting.dart';
import 'package:scriptus/services/api_service.dart';

final meetingRepositoryProvider = Provider<MeetingRepository>((ref) {
  return MeetingRepository();
});

class MeetingRepository {
  // Future<List<Meeting>> fetchMeetings() async {
  //   print('fetchMeetings');
  //   // final response =
  //   //     await http.get(Uri.parse('http://www.misia.sk:7989/meetings'));

  //   Response response =
  //       await ApiService().dio.get('/meetings.json?offset=15100');

  //   if (response.statusCode == 200) {
  //     List<dynamic> body = jsonDecode(response.data);
  //     List<Meeting> meetings = body
  //         .map(
  //           (dynamic item) => Meeting.fromJson(item),
  //         )
  //         .toList();

  //     return meetings;
  //   } else {
  //     throw Exception('Failed to load meetings');
  //   }
  // }
  // load meeting by date from the api
  Future<Meeting> fetchMeetingByDate(DateTime date) async {
    Response response = await ApiService().dio.get(
        '/meetings/find_by_date.json',
        queryParameters: {'date': date.toString()});
    if (response.statusCode == 200) {
      print(response.data);
      var map = response.data[0];
      return Meeting.fromMap(map);
    } else {
      throw Exception('Failed to load meetings');
    }
  }

  Future<List<Meeting>> fetchMeetings() async {
    Response response = await ApiService().dio.get('/meetings.json');
    if (response.statusCode == 200) {
      // print(response.data);
      // final jsonData = json.decode(response.data);
      // var map = Map<String, dynamic>.from(jsonData);
      var map = response.data;
      List<Meeting> list =
          List.generate(map.length, (index) => Meeting.fromMap(map[index]));

      return list;
    } else {
      throw Exception('Failed to load meetings');
    }
  }
}
