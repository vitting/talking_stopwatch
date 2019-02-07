import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:intl/intl_standalone.dart';
import 'package:vibration/vibration.dart';

class SystemHelpers {
  static Future<String> getSystemLanguageCode() async {
    String value = "en";
    String systemLocale = await findSystemLocale();
    if (systemLocale != null) {
      List<String> locale = systemLocale.split("_");  
      if (locale.length != 0) {
        value = locale[0];
      }
    }
  
    return value;
  }

  static Future<void> setScreenOn() async {
    bool isScreenOn = await Screen.isKeptOn;
    if (isScreenOn == false) {
      Screen.keepOn(true);
    }
  }

  static Future<void> setScreenOff() async {
    bool isScreenOn = await Screen.isKeptOn;

    if (isScreenOn == true) {
      Screen.keepOn(false);
    }
  }

  static Future<Null> showNavigationButtons(bool show) {
    if (show) {
      return SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    } else {
      return SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    }
  }

  static Future<void> vibrate30() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(
        duration: 30
      );
    }
  }

  static Future<void> vibrate100() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(
        duration: 100
      );
    }
  }
}