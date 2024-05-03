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
  TextEditingController _searchController = TextEditingController();

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: _searchController.text.isEmpty ? Icon(Icons.search) : Icon(Icons.clear),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: totalSurahCount,
                itemBuilder: (context, index) {
                  int surahNumber = index + 1;
                  String surahName = getSurahName(surahNumber);
                  String surahNameArabic = getSurahNameArabic(surahNumber);
                  // Filter surahs based on search query
                  if (_searchController.text.isNotEmpty &&
                      !surahName.toLowerCase().contains(_searchController.text.toLowerCase())) {
                    return SizedBox(); // Hide the ListTile if it doesn't match the search query
                  }
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          surahName,
                          style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          surahNameArabic,
                          style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
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
