import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/ui/stopwatch_main.dart';

void main() async {
  final FlutterTts flutterTts = new FlutterTts();
  String languageCode = await SystemHelpers.getSystemLanguageCode();
  
  if (languageCode == "da" && await flutterTts.isLanguageAvailable("da-DK")) {
    await flutterTts.setLanguage("da-DK");
  } else {
    await flutterTts.setLanguage("en-US");
  }

  return runApp(
  
  MaterialApp(
    home: StopwatchMain(languageCode: languageCode, flutterTts: flutterTts),
  )
);
}