import 'package:shared_preferences/shared_preferences.dart';

class SettingsData {
  static SharedPreferences preferences;

  int interval;
  bool keepScreenOn;
  bool vibrate;
  bool speak;
  bool vibrateAtInterval;

  SettingsData(
      {this.interval = 10,
      this.keepScreenOn = false,
      this.vibrate = true,
      this.speak = true,
      this.vibrateAtInterval = false});

  Future<bool> updateInterval(int interval) async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }

    this.interval = interval;
    return preferences.setInt("talking_interval", interval);
  }

  Future<bool> updateKeepScreenOn(bool keepScreenOn) async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }

    this.keepScreenOn = keepScreenOn;
    return preferences.setBool("talking_keepscreenon", keepScreenOn);
  }

  Future<bool> updateVibrate(bool vibrate) async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }

    this.vibrate = vibrate;
    return preferences.setBool("talking_vibrate", vibrate);
  }

  Future<bool> updateSpeak(bool speak) async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }

    this.speak = speak;
    return preferences.setBool("talking_speak", speak);
  }

  Future<bool> updateVibrateAtInterval(bool vibrateAtInterval) async {
    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }

    this.vibrateAtInterval = vibrateAtInterval;
    return preferences.setBool("talking_vibrateAtInterval", vibrateAtInterval);
  }

  static Future<SettingsData> getSettings() async {
    int interval = 10;
    bool keepScreenOn = false;
    bool vibrate = true;
    bool speak = true;
    bool vibrateAtInterval = false;

    if (preferences == null) {
      preferences = await SharedPreferences.getInstance();
    }

    try {
      interval = preferences.getInt("talking_interval");
    } catch (e) {
      await preferences.setInt("talking_interval", interval);
    }

    try {
      keepScreenOn = preferences.getBool("talking_keepscreenon");

      if (keepScreenOn == null) {
        keepScreenOn = false;
        await preferences.setBool("talking_keepscreenon", keepScreenOn);
      }
    } catch (e) {
      await preferences.setBool("talking_keepscreenon", keepScreenOn);
    }

    try {
      vibrate = preferences.getBool("talking_vibrate");
      if (vibrate == null) {
        vibrate = true;
        await preferences.setBool("talking_vibrate", vibrate);
      }
    } catch (e) {
      await preferences.setBool("talking_vibrate", vibrate);
    }

    try {
      speak = preferences.getBool("talking_speak");
      if (speak == null) {
        speak = true;
        await preferences.setBool("talking_speak", speak);
      }
    } catch (e) {
      await preferences.setBool("talking_speak", speak);
    }

    try {
      vibrateAtInterval = preferences.getBool("talking_vibrateAtInterval");
      if (vibrateAtInterval == null) {
        vibrateAtInterval = false;
        await preferences.setBool(
            "talking_vibrateAtInterval", vibrateAtInterval);
      }
    } catch (e) {
      await preferences.setBool("talking_vibrateAtInterval", vibrateAtInterval);
    }

    return SettingsData(
        interval: interval,
        keepScreenOn: keepScreenOn,
        vibrate: vibrate,
        speak: speak,
        vibrateAtInterval: vibrateAtInterval);
  }
}
