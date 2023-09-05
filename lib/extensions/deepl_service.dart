import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deepl_service.g.dart';

enum DeepLCallStatus {
  /// Enum representing the status of a DeepL call.
  ///
  /// Attributes:
  /// initial: Represents the initial status of the call.
  /// loading: Represents the loading status of the call.
  /// success: Represents the success status of the call.
  /// error: Represents the error status of the call.
  initial,
  loading,
  success,
  error,
}

// create riverpod provider for translation service status with default enum value off
// @riverpod
// final deepLCallStatusProvider = StateProvider<DeepLCallStatus>((ref) {
//   return DeepLCallStatus.initial;
// });

@riverpod
class DeepLCallStatusP extends _$DeepLCallStatusP {
  @override
  DeepLCallStatus build() {
    return DeepLCallStatus.initial;
  }

  // Add methods to mutate the state
}

class TranslatioServices {
  // This is a class for handling translation services.

  // Attributes:
  //     apiKey (str): The API key for the translation service.
  //     apiUrl (str): The URL of the translation service.
  //     dio (Dio): An instance of the Dio class for making HTTP requests.

  // Methods:
  //     translateText(textToTranslate, targetLanguage): Translates a given text into a specified language.
  final String apiKey = 'c171b756-19c8-3ace-85f6-4e5bd9ea4397:fx';
  final String apiUrl = 'https://api-free.deepl.com/v2/translate';
  Dio dio = Dio();

  Future<String> translateText(
      String textToTranslate, String targetLanguage) async {
    FormData formData = FormData.fromMap({
      'auth_key': apiKey,
      'text': textToTranslate,
      'source_lang': 'DE',
      'target_lang': targetLanguage,
    });

    final response = await dio.post(apiUrl, data: formData);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.toString());
      if (jsonResponse != null &&
          jsonResponse['translations'] != null &&
          jsonResponse['translations'].length > 0) {
        return jsonResponse['translations'][0]['text'];
      }
    } else {
      throw Exception('Failed to load translation');
    }
    return 'error';
  }
}

// POST /v2/translate HTTP/2
// Host: api-free.deepl.com
// Authorization: DeepL-Auth-Key [yourAuthKey] 
// User-Agent: YourApp/1.2.3
// Content-Length: 45
// Content-Type: application/json

// {"text":["Hello, world!"],"target_lang":"DE"}
// EXAMPLE RESPONSE
// {
//   "translations": [
//     {
//       "detected_source_language": "EN",
//       "text": "Hallo, Welt!"
//     }
//   ]
// }