import'package:equran/models/Ayah.dart';
class AudioService{
String getAudioURLByVerse(int? surahNumber, int verseNumber) {
  int verseNum = 0;
  for (var i in quranText) {
    if (i['surah_number'] == surahNumber && i['verse_number'] == verseNumber) {
      verseNum = quranText.indexOf(i)+1;
        print("Versenumber");
        print(verseNum);
      break;
    }
    // https://everyayah.com/data/AbdulSamad_64kbps_QuranExplorer.Com/001001.mp3
  }
  return "https://cdn.islamic.network/quran/audio/128/ar.alafasy/$verseNum.mp3";
}
String getAudioURLByVerseNumber(int verseNumber) {
  return "https://cdn.islamic.network/quran/audio/128/ar.alafasy/$verseNumber.mp3";
}
}
