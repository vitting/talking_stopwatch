import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/ui/stopwatch_main.dart';

void main() async {
  final FlutterTts flutterTts = new FlutterTts();
  String languageCode = await SystemHelpers.getSystemLanguageCode();
  SettingsData settings = await SettingsData.getSettings();

  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StopwatchMain(
        languageCode: languageCode, flutterTts: flutterTts, settings: settings),
    localizationsDelegates: [
      FlutterI18nDelegate(false, settings.language),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
  ));
}
