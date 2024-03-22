import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DirectoryHandler {
  Future<String> getRecordingDirectory() async {
    Directory externalDir;

    if (Platform.isAndroid) {
      externalDir = Directory("/storage/emulated/0");
    } else {
      externalDir = await getApplicationDocumentsDirectory();
    }

    Directory customFolder = Directory('${externalDir.path}/E-Quran');
    await customFolder.create(recursive: true);

    return customFolder.path;
  }
}
