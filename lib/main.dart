import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talking_stopwatch/helpers/notification_action.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/ui/stopwatch_main.dart';

void main() async {
  final FlutterTts flutterTts = new FlutterTts();
  final NotificationAction notificationAction = new NotificationAction();

  String languageCode = await SystemHelpers.getSystemLanguageCode();
  if (languageCode != "da") {
    languageCode = "en";
  }

  SettingsData settings = await SettingsData.getSettings(languageCode);

  if (settings.keepScreenOn) {
    SystemHelpers.setScreenOn();
  }

  await notificationAction.initialize();
  
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StopwatchMain(
        flutterTts: flutterTts,
        settings: settings,
        notificationAction: notificationAction),
    localizationsDelegates: [
      FlutterI18nDelegate(false, settings.language),
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
  ));
}
