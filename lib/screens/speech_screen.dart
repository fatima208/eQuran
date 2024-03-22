import 'package:flutter/material.dart';
import 'package:equran/common/lib/quran.dart';
import 'ayah_screen.dart';
import 'package:equran/constants/constants.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  int selectedSurahNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        title: Text(
          "Quran Pronunciation",
          style: TextStyle(
            color: themebackground.w,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: totalSurahCount,
                itemBuilder: (context, index) {
                  int surahNumber = index + 1;
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getSurahName(surahNumber),
                          style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                        ), // Display Surah name in English
                        Text(
                          getSurahNameArabic(surahNumber),
                          style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ), // Display Surah name in Arabic
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        selectedSurahNumber = surahNumber;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AyahScreen(selectedSurahNumber),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
