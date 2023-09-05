import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Duration durationFromString(String timeString) {
  List<String> parts = timeString.split(':');
  int hours = int.parse(parts[0]);
  int minutes = int.parse(parts[1]);
  int seconds = int.parse(parts[2]);

  Duration duration =
      Duration(hours: hours, minutes: minutes, seconds: seconds);
  Duration diff = const Duration(seconds: 6);
  Duration res = duration - (duration < diff ? duration : diff);
  return res;
}
/// Formats the duration from seconds to a string representation.
///
/// The function takes an integer representing total seconds, converts it to a Duration,
/// and then formats it to a string in the format of HH:MM:SS.
///
/// The resulting string is used for displaying the duration in a human-readable format.
String formatDuration(int totalSeconds) {
  final duration = Duration(seconds: (totalSeconds / 100).ceil());
  return (duration.toString()).substring(0, 7);
  // final hours = duration.inHours;
  // final minutes = duration.inMinutes;
  // final seconds = totalSeconds % 60;

  // final hoursString = '$hours'.padLeft(2, '0');
  // final minutesString = '$minutes'.padLeft(2, '0');
  // final secondsString = '$seconds'.padLeft(2, '0');
  // return '$hoursString:$minutesString:$secondsString';
}
Future<String> loadAsset() async {
  return await rootBundle
      .loadString('assets/2023-03-18-1984-12-29-1000-Krefeld-english.csv');
}

Future<String> get _localPath async {
  final directory = await getDownloadsDirectory();
  return directory!.path;
}

Future<File> get localFile async {
  final path = await _localPath;
  return File('$path/flutter_export.txt');
}

Duration parseDuration(String timeStr) {
  final parts = timeStr.split(':').map(int.parse).toList();
  return Duration(hours: parts[0], minutes: parts[1], seconds: parts[2]);
}

String formatDurationForSplits(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
}

String calculateNewEndTime(
    String startTime, String endTime, double cursorPositionRatio) {
  final start = parseDuration(startTime);
  final end = parseDuration(endTime);
  final total = end - start;
  final newEnd = start + (total * cursorPositionRatio);
  return formatDurationForSplits(newEnd);
}

String calculateNewStartTime(
    String startTime, String endTime, double cursorPositionRatio) {
  final start = parseDuration(startTime);
  final end = parseDuration(endTime);
  final total = end - start;
  final newStart = start + (total * cursorPositionRatio);
  return formatDurationForSplits(newStart);
}

double cursorPositionRatio(cursorPosition, textLength) =>
    cursorPosition / textLength;

void copyToClipboard(String content) async {
  await FlutterClipboard.copy(content);
  print('Content copied to clipboard');
}
