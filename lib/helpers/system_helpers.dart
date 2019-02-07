import 'package:flutter/services.dart';
import 'package:screen/screen.dart';
import 'package:intl/intl_standalone.dart';

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
}