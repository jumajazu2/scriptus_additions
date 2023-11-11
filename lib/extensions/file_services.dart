import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> listCacheFiles() async {
  final tempDir =
      await getTemporaryDirectory(); // Use `path_provider` to find temp directory

  // List all files in the temp directory
  List<FileSystemEntity> files = tempDir.listSync();

  // Filter audio files or other cache files used by just_audio
  // This example uses a hypothetical extension '.audioCache', replace with actual ones
  List<FileSystemEntity> audioFiles = files.where((file) {
    return file.path.endsWith('.mp3') || file.path.endsWith('.wav');
  }).toList();

  // Print or handle the audio files
  for (FileSystemEntity file in files) {
    print(file.path);
    // You can delete or manage the files here
  }
}

void deleteTemporaryFile(String filePath) {
  final file = File(filePath);

  if (file.existsSync()) {
    file.deleteSync();
    print('File deleted: $filePath');
  } else {
    print('File not found: $filePath');
  }
}

void clearTemporaryDirectory() {
  final tempDir = Directory.systemTemp;

  // Be very careful with this operation - you're deleting files!
  // Ensure these are indeed files you want to delete to avoid data loss
  tempDir.listSync().forEach((FileSystemEntity entity) {
    print(entity.path);
    // if (entity is File) {
    //   entity.deleteSync();
    // }
  });
}
