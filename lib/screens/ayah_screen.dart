import 'dart:io';

import 'package:equran/constants/constants.dart';
import 'package:flutter/material.dart';
import "package:equran/common/lib/quran.dart";
import 'package:equran/widgets/mic_widget_handle.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/Ayah_Services.dart';
import 'package:equran/controllers/wav_file_handeller.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';


class AyahScreen extends StatefulWidget {
  final int surahNumber;

  AyahScreen(this.surahNumber);

  @override
  _AyahScreenState createState() => _AyahScreenState();
}

class _AyahScreenState extends State<AyahScreen> {
  int currentVerseNumber = 1;
  int verseCount = 0;
  final _AudioServices=AudioService();
  bool isAudioPlaying = false; // New state variable to track audio playing status
  late AudioPlayer player;
  //gjsgja
  late Record record;
  bool isRecording = false;
  String? audioPath;
  DirectoryHandler directoryHandler = DirectoryHandler();

  //init and Dispose
  @override
  void initState() {
    verseCount = getVerseCount(widget.surahNumber);
    player = AudioPlayer();
    record = Record();
    super.initState();
    player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          isAudioPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    player.dispose();
    record.dispose();
    super.dispose();
  }
  //requestPermission
  Future<void> _requestPermissions() async {
    if (await Permission.microphone.isDenied) {
      await Permission.microphone.request();
    }

    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }
  //start
  Future<void> Start() async {
    try {
      await _requestPermissions();

      // Get the recording directory
      String recordingDirectory = await directoryHandler.getRecordingDirectory();

      // Specify the desired filename within the recording folder
      String path = '$recordingDirectory/myRecording.wav';

      // Delete the existing file if it exists
      File existingFile = File(path);
      if (await existingFile.exists()) {
        await existingFile.delete();
      }

      // Start recording with the WAV encoder
      await record.start(path: path);

      setState(() {
        isRecording = true;
      });

    } catch (e) {
      print("Error Starting Recording: $e");
    }
  }
  //stop
  Future<void> Stop() async {
    try {
      String? path = await record.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
        print("After Closing : $audioPath");
        handleMicButtonClick(context, widget.surahNumber, currentVerseNumber,audioPath);
      });
    } catch (e) {
      print("Error: $e");
    }
  }
  //building
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.brown,
            elevation: 0,
            title: Text(getSurahName(widget.surahNumber),style: TextStyle(
              color: themebackground.w,fontWeight: FontWeight.bold,
            ),),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios , color: Colors.white,),)),
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/back_image.png'),
                  fit: BoxFit.cover,
                ),
              ),),
            Expanded(
              child: Center(child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.2),
                      border: Border.all(
                        width: 20,
                        color: Colors.transparent,
                      ), // Set your border color
                      image: const DecorationImage(
                        image: AssetImage('assets/borders.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SingleChildScrollView(

                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child:Text(
                          getVerse(widget.surahNumber, currentVerseNumber),
                          style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (currentVerseNumber > 1)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentVerseNumber--;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: themebackground.br, // Set the background color to red for stop button
                          ),
                          child: Icon(Icons.arrow_back, size: 35,
                            color: Constants.kPrimary,),
                        ),
                      SizedBox(width: 16),
                      if (currentVerseNumber < verseCount)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentVerseNumber++;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            primary: themebackground.br, // Set the background color to red for stop button
                          ),
                          child: Icon(Icons.arrow_forward , size: 35,
                            color: Constants.kPrimary,),
                        ),

                    ],
                  ),
                  isAudioPlaying
                      ? ElevatedButton(
                    onPressed: () async {
                      // Stop audio playback
                      await player.stop();
                      setState(() {
                        isAudioPlaying = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: themebackground.br, // Set the background color to red for stop button
                    ),
                    child: Icon(
                      Icons.stop,
                      size: 35,
                      color: Constants.kPrimary,
                    ),
                  )
                      : ElevatedButton(
                    onPressed: () async {
                      int? surahNumber = widget.surahNumber;
                      int verseNumber = currentVerseNumber;
                      String url = _AudioServices.getAudioURLByVerse(surahNumber, verseNumber);

                      // Play audio
                      await player.play(UrlSource(url));
                      setState(() {
                        isAudioPlaying = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: themebackground.br, // Set the background color to green for play button
                    ),
                    child: Icon(
                      Icons.volume_up,
                      size: 35,
                      color: Constants.kPrimary,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(isRecording==false){
                        Start();
                      }
                      else{
                        Stop();
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: themebackground.br, // Set the background color to green for play button
                    ),
                    child:Icon(
                      isRecording?Icons.stop:Icons.mic,
                      size: 35,
                      color: Constants.kPrimary,
                    ),
                  ),
                ],
              ),
              ),)
          ],
        )
    );
  }
}