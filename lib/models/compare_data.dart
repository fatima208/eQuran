import 'package:flutter/material.dart';

List<TextSpan> compareAndStyleStrings(String qari, String us) {
  int minLength = qari.length < us.length ? qari.length : us.length;
  List<TextSpan> styledText = [];

  for (int i = 0; i < minLength; i++) {
    if (qari[i] == us[i]) {
      styledText.add(TextSpan(text: us[i], style: TextStyle(color: Colors.black)));
    } else {
      styledText.add(TextSpan(text: us[i], style: TextStyle(color: Colors.red)));
    }
  }

  for (int i = minLength; i < us.length; i++) {
    styledText.add(TextSpan(text: us[i], style: TextStyle(color: Colors.red)));
  }

  return styledText;
}
