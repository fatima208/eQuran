//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:equran/constants/constants.dart';
import 'package:equran/controllers/tasfeer_controller.dart';
import 'package:equran/models/tasfeer.dart.';
import 'package:equran/models/tasfeer_author.dart';
import 'package:equran/services/api_services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:equran/models/translation.dart';
import 'package:equran/services/Ayah_Services.dart';
import 'package:equran/screens/quran_screen.dart';
import 'package:equran/screens/surah_detail.dart';
import 'package:equran/models/surah.dart';


class TranslationTile extends StatelessWidget {
  final int index;
  final SurahTranslation surahTranslation;




  TranslationTile({super.key, required this.index,required this.surahTranslation});
    final _apiServices=ApiServices();
    final _tasfeerController=Get.put(TasfeerController());
    final _AudioServices=AudioService();
    final player=AudioPlayer();
    Surah _surah=Surah();

  @override
  void dispose() {
    // Dispose of the audio player when the widget is closed
    player.dispose();

  }

  @override
  Widget build(BuildContext context) {
    String selectedSurahName = ModalRoute.of(context)!.settings.arguments as String;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          color: themebackground.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              blurRadius: 1
            ),
          ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                     color: themebackground.brown,
                    //color: Color(0xffA5D2D6),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  ),
                  padding: const EdgeInsets.all(22),
                  width: double.infinity,
                ),
                Positioned(
                  top: 5,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black
                    ),
                    child: Text(surahTranslation.aya!,
                      style: const TextStyle(color: Colors.white,fontSize: 16),),
                  ),
                ),
                Positioned(
                  bottom:0.3,
                  right: 20,
                  child:ElevatedButton(
                    onPressed: () async {

                      int? surahNumber=Constants.surahIndex;//want to have selectSurahNumber here its another file
                      int verseNumber = int.parse(surahTranslation.aya!);
                      String url=_AudioServices.getAudioURLByVerse(surahNumber, verseNumber);
                       await player.play(UrlSource(url));

                    },
                    style: ElevatedButton.styleFrom(
                      primary: Constants.kPrimary, // Set the background color to brown
                    ),
                    child: Icon(
                      Icons.volume_up,
                      size: 35,
                      color: Colors.brown, // Set the icon color to white
                    ),
                  ),
                ),
                Positioned(
                  top:5,
                  left: 60,
                  child: InkWell(
                    onTap: (){
                      showModalBottomSheet(
                          context: context,
                          builder: (context){
                            return Container(
                              decoration: BoxDecoration(
                                color: Constants.kPrimary,
                              ),
                              child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: themebackground.br,
                                  ),
                                   child: const Padding(
                                    padding:EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),

                                       child:Text("Authors",
                                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: themebackground.w),),),
                                ),
                                FutureBuilder<List<TasfeerAuthor>>(
                                    future: _apiServices.getTasfeerAuthor(),
                                    builder: (context,snapshot){
                                      if(snapshot.connectionState==ConnectionState.waiting){
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if(snapshot.hasData){
                                        List<TasfeerAuthor>? authors=snapshot.data;
                                        _tasfeerController.name.value=authors?.first.name ?? '';
                                        Future.delayed(Duration.zero,(){
                                          _tasfeerController.index.value=1;
                                        });
                                        return SizedBox(
                                          width: double.infinity,
                                          child: Obx((){
                                            return DropdownButton<String>(
                                              value: _tasfeerController.name.value,
                                              icon: const Icon(Icons.keyboard_arrow_down),
                                              items: authors?.map<DropdownMenuItem<String>>((TasfeerAuthor item){
                                              return DropdownMenuItem<String>(
                                                value: item.name,
                                                child: Text(item.name!),
                                              );
                                              }).toList(),
                                              onChanged: (String? newValue){
                                                int? index= authors?.indexWhere((authors)=>authors.name==newValue);
                                                _tasfeerController.updateName(newValue?? '', (index!+1));
                                              },
                                            );
                                          }),


                                        );
                                      }
                                      return const Center(
                                        child: Text("Please Try Agian Later"),
                                      );
                                    }),
                                const SizedBox(height: 12,),

                                Expanded(
                                  child: Obx(() {
                                    return _tasfeerController.index.value == 0
                                        ? const SizedBox.shrink()
                                        : FutureBuilder<Tasfeer>(
                                      future: _apiServices.getTasfeer(_tasfeerController.index.value,Constants.surahIndex, surahTranslation.aya!),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.00),
                                            child: SingleChildScrollView(
                                              child: Text(snapshot.data!.text ?? 'Not Available'),
                                            ),
                                          );
                                        }
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return const Text('Please try again');
                                      },
                                    );

                                  }),
                                  
                                ),

                              ],
                            ), );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Constants.kPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text("Tasfeer",
                      style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  SizedBox(
                    width: double.infinity,
                    child: Text(surahTranslation.arabic_text!,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      surahTranslation.translation!,
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




