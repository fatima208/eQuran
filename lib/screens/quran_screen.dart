import 'package:flutter/material.dart';
import 'package:equran/constants/constants.dart';
import 'package:equran/screens/surah_detail.dart';

import '../models/sajda.dart';
import '../models/surah.dart';
import '../services/api_services.dart';
import '../widgets/sajda_custom_tile.dart';
import '../widgets/surah_custem_tile.dart';
import 'jus_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  ApiServices apiServices = ApiServices();
  String selectedSurahName = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Added
      initialIndex: 0,
      child: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themebackground.br,
            title: const Text(
              'Quran',
              style: TextStyle(
                color: themebackground.w,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Text(
                  'Surah',
                  style: TextStyle(
                      color: themebackground.w,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ), //index - 0
                Text(
                  'Sajda',
                  style: TextStyle(
                      color: themebackground.w,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ), //index - 1
                Text(
                  'Juz',
                  style: TextStyle(
                      color: themebackground.w,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ), // index - 2
              ],
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image:AssetImage('assets/back_image.png'),
                fit: BoxFit.cover),
              ),
            child:TabBarView(
            children: <Widget>[
              FutureBuilder(
                future: apiServices.getSurah(),
                builder: (BuildContext context, AsyncSnapshot<List<Surah>> snapshot) {
                  if (snapshot.hasData) {
                    List<Surah>? surah = snapshot.data;
                    return ListView.builder(
                      itemCount: surah!.length,
                      itemBuilder: (context, index) => SurahCustomListTile(

                        surah: surah[index],
                        context: context,
                        ontap: () {
                          setState(() {
                            Constants.surahIndex = (index + 1);
                            selectedSurahName = surah[index].englishName ?? '';
                            int selectedSurahNumber = index + 1;
                          });
                          Navigator.pushNamed(context, Surahdetail.id, arguments: selectedSurahName);
                        },
                      ),
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              FutureBuilder(
                future: apiServices.getSajda(),
                builder: (context, AsyncSnapshot<SajdaList> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'),);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.sajdaAyahs.length,
                    itemBuilder: (context, index) =>
                        SajdaCustomTile(snapshot.data!.sajdaAyahs[index], context),
                  );
                },
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            Constants.juzIndex = (index + 1);
                          });
                          Navigator.pushNamed(context, JuzScreen.id);
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.brown.withOpacity(0.5),
                          child: Center(
                            child: Text('${index + 1} ', style: const TextStyle(color: Colors.white, fontSize: 20),),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),),
        ),
      ),
      ),
    );
  }
}
