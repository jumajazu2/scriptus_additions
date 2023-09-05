import 'package:dio/dio.dart';
import 'dart:io';

class ApiService {
  /// NOT USED
  Dio dioConnection() {
    Dio dio = Dio();
    dio.options.baseUrl = "http://www.misia.sk:7989/";
    dio.options.connectTimeout = const Duration(minutes: 1); //5s
    dio.options.receiveTimeout = const Duration(minutes: 1);
    dio.options.headers = {
      HttpHeaders.userAgentHeader: 'dio',
      'common-header': 'xx'
    };

    return dio;
  }

  Dio get dio => dioConnection();
}
