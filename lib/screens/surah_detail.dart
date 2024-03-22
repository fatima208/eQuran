import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:equran/constants/constants.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import '../models/translation.dart';
import '../services/api_services.dart';
import '../widgets/custom_translation.dart';
import 'package:equran/screens/quran_screen.dart';



AudioPlayer audioPlayer = AudioPlayer();
enum Translation { urdu,hindi,english, spanish }

class Surahdetail extends StatefulWidget {


  const Surahdetail({super.key});

  static const String id = 'surahDetail_screen';


  @override
  _SurahdetailState createState() => _SurahdetailState();
}

class _SurahdetailState extends State<Surahdetail> {

  final ApiServices _apiServices = ApiServices();
 // SolidController _controller = SolidController();
  Translation? _translation = Translation.english;


  @override
  Widget build(BuildContext context) {
    String selectedSurahName = ModalRoute.of(context)!.settings.arguments as String;
    print(_translation!.index);


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: themebackground.br,
          elevation: 0,
          title:Center(child:Text(
            selectedSurahName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),),

            leading: IconButton(
            onPressed: (){
      Navigator.pop(context);
      },
        icon: const Icon(Icons.arrow_back_ios , color: Colors.white,),),
      ),
        body: FutureBuilder(
          future: _apiServices.getTranslation(Constants.surahIndex!,_translation!.index),
          builder: (BuildContext context, AsyncSnapshot<SurahTranslationList> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.hasData){
              return Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  itemCount: snapshot.data!.translationList.length,
                  itemBuilder: (context,index){
                    return
                        TranslationTile(
                          index: index,
                          surahTranslation: snapshot.data!.translationList[index],
                        );

                  },
                ),
              );
            }
            else return const Center(child: Text('Translation Not found'),);
          },
        ),
        bottomSheet: SolidBottomSheet(
          headerBar: Container(
            color: themebackground.br,
            height: 50,
            child: const Center(
              child: Text("Swipe me!",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
          ),
          body: Container(
            color: Constants.kPrimary,
            height: 30,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Urdu'),
                      leading: Radio<Translation>(
                        value: Translation.urdu,
                        groupValue: _translation,
                        onChanged: (Translation? value) {
                          setState(() {
                            _translation = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Hindi'),
                      leading: Radio<Translation>(
                        value: Translation.hindi,
                        groupValue: _translation,
                        onChanged: (Translation? value) {
                          setState(() {
                            _translation = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('English'),
                      leading: Radio<Translation>(
                        value: Translation.english,
                        groupValue: _translation,
                        onChanged: (Translation? value) {
                          setState(() {
                            _translation = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Spanish'),
                      leading: Radio<Translation>(
                        value: Translation.spanish,
                        groupValue: _translation,
                        onChanged: (Translation? value) {
                          setState(() {
                            _translation = value;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
