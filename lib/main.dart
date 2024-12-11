// import 'package:csv/csv_settings_autodetection.dart';
// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as q;
// import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:scriptus/home_page.dart';
// import 'package:scriptus/models/bible_verse.dart';
// import 'package:scriptus/models/transcript_segment.dart';
// import 'package:path/path.dart' as path;
// import 'package:scriptus/screen_parts/edit_sentence.dart';
// import 'package:tuple/tuple.dart';

// import 'services/mng_database_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scriptus',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        useMaterial3: true, colorSchemeSeed: Colors.green[700],

        brightness: Brightness.dark,
        // primaryColor: Colors.white,
      ),
      home: const HomePage(title: 'Scriptus'),
    );
  }
}
