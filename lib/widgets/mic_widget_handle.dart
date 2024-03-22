import 'package:flutter/material.dart';
import 'dart:io';
import 'package:equran/common/lib/quran.dart';
import 'package:equran/controllers/machine_handling.dart';
import 'package:path_provider/path_provider.dart';
import'package:permission_handler/permission_handler.dart';
import'package:equran/models/compare_data.dart';
import'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import'package:permission_handler/permission_handler.dart';
import 'package:equran/constants/constants.dart';
void handleMicButtonClick(BuildContext context, int surahNumber, int verseNumber,String? Path) async {
  await _requestPermissions();
  String audioUrl=getAudioURLByVerse(surahNumber, verseNumber);
  String Path1= await downloadFile(audioUrl);
  String Path2=Path!;
  String _flac= await convertAudioToFlac(Path1);
  String _flac1= await convertAudioToFlac(Path2);
  await Future.delayed(Duration(seconds: 10));
  Map<String, dynamic> output = await query("$_flac");
  Map<String, dynamic> output1 = await query("$_flac1");
  String qari = output['text'];
  String us=output1['text'];
  List<TextSpan> styledText = compareAndStyleStrings(qari, us);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Pronouncation',
        style: TextStyle(
            color: themebackground.br,
        ),),
        content: RichText(
          text: TextSpan(children: styledText),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Close',style: TextStyle(
              color: themebackground.br,
            ),),
          ),
        ],
      );
    },
  );
}

Future<void> _requestPermissions() async {
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }

  if (await Permission.manageExternalStorage.isDenied) {
    await Permission.manageExternalStorage.request();
  }
}
Future<String> downloadFile(String url) async {
  Dio dio = Dio();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String savePath = appDocDir.path + '/downloadedFile.mp3';

  // Check if the file already exists
  File existingFile = File(savePath);
  if (await existingFile.exists()) {
    // If it exists, delete the existing file
    await existingFile.delete();
  }

  // Download the file
  await dio.download(url, savePath);

  return savePath;
}

