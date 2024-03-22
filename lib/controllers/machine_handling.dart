import 'dart:io';
import 'dart:convert';
import 'package:ffmpeg_kit_flutter/log.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/session.dart';
import 'package:ffmpeg_kit_flutter/statistics.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

final String apiUrl =
    "https://api-inference.huggingface.co/models/tarteel-ai/whisper-base-ar-quran";
final Map<String, String> headers = {
  "Authorization": "Bearer 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"
};

Future<Map<String, dynamic>> query(String filename) async {
  final File file = File(filename);
  final List<int> data = await file.readAsBytes();

  final http.Response response =
  await http.post(Uri.parse(apiUrl), headers: headers, body: data);

  //return json.decode(response.body);
  var data1 = utf8.decode(response.bodyBytes);

  return jsonDecode(data1);

  // Return an error status or throw an excepti
}


Future<String> convertAudioToFlac(String inputPath) async {
  // Output path for the FLAC file
  String outputPath = inputPath.replaceAll(RegExp(r'\.[a-zA-Z0-9]+$', caseSensitive: false), '.flac');

  // FFmpeg command for converting audio to FLAC
  String ffmpegCommand = '-y -i $inputPath -c:a flac $outputPath';

  // Execute FFmpeg command
  await FFmpegKit.executeAsync(ffmpegCommand, (Session session) async {
    // CALLED WHEN SESSION IS EXECUTED

    // Check the result of the conversion
    final returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
      print('Audio conversion to FLAC successful.');

    } else {
      // ERROR
      print('Audio conversion to FLAC failed.');
    }
  }, (Log log) {
    // CALLED WHEN SESSION PRINTS LOGS
    print(log.getMessage());
  }, (Statistics statistics) {
    // CALLED WHEN SESSION GENERATES STATISTICS
  });
  return outputPath;
}

