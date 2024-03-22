/// tafseer_id : 1
/// tafseer_name : "التفسير الميسر"
/// ayah_url : "/quran/1/1/"
/// ayah_number : 1
/// text : "سورة الفاتحة سميت هذه السورة بالفاتحة؛ لأنه يفتتح بها القرآن العظيم، وتسمى المثاني؛ لأنها تقرأ في كل ركعة، ولها أسماء أخر. أبتدئ قراءة القرآن باسم الله مستعينا به، (اللهِ) علم على الرب -تبارك وتعالى- المعبود بحق دون سواه، وهو أخص أسماء الله تعالى، ولا يسمى به غيره سبحانه. (الرَّحْمَنِ) ذي الرحمة العامة الذي وسعت رحمته جميع الخلق، (الرَّحِيمِ) بالمؤمنين، وهما اسمان من أسمائه تعالى، يتضمنان إثبات صفة الرحمة لله تعالى كما يليق بجلاله."
library;

class Tasfeer {
  Tasfeer({
      this.tafseerId,
      this.tafseerName,
      this.ayahUrl,
      this.ayahNumber,
      this.text,});

  Tasfeer.fromJson(dynamic json) {
    tafseerId = json['tafseer_id'];
    tafseerName = json['tafseer_name'];
    ayahUrl = json['ayah_url'];
    ayahNumber = json['ayah_number'];
    text = json['text'];
  }
  int? tafseerId;
  String? tafseerName;
  String? ayahUrl;
  int? ayahNumber;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tafseer_id'] = tafseerId;
    map['tafseer_name'] = tafseerName;
    map['ayah_url'] = ayahUrl;
    map['ayah_number'] = ayahNumber;
    map['text'] = text;
    return map;
  }

}