import 'package:talking_stopwatch/helpers/db_helpers.dart';
import 'package:talking_stopwatch/helpers/db_sql_create.dart';

class SettingsData {
  String id;
  int interval;
  bool keepScreenOn;
  bool vibrate;
  bool speak;
  bool speakShort;
  bool vibrateAtInterval;
  bool showNotification;
  double volume;
  String language;

  SettingsData(
      {this.id,
      this.interval = 10,
      this.keepScreenOn = false,
      this.vibrate = true,
      this.speak = true,
      this.speakShort = false,
      this.vibrateAtInterval = false,
      this.showNotification = false,
      this.volume = 1.0,
      this.language = "en"});

  Future<int> save() {
    id = "settings";
    return DbHelpers.insert(DbSql.tableSettings, this.toMap());
  }

  factory SettingsData.fromMap(Map<String, dynamic> item) {
    return SettingsData(
        id: item["id"],
        interval: item["interval"],
        keepScreenOn: item["keepScreenOn"] == 1,
        vibrate: item["vibrate"] == 1,
        vibrateAtInterval: item["vibrateAtInterval"] == 1,
        speak: item["speak"] == 1,
        speakShort: item["speakShort"] == null ? false : item["speakShort"] == 1,
        showNotification: item["showNotification"] == null ? false : item["showNotification"] == 1,
        volume: item["volume"],
        language: item["language"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "interval": interval,
      "keepScreenOn": keepScreenOn,
      "vibrate": vibrate,
      "vibrateAtInterval": vibrateAtInterval,
      "speak": speak,
      "speakShort": speakShort,
      "volume": volume,
      "showNotification": showNotification,
      "language": language
    };
  }

  Future<int> updateInterval(int interval) async {
    this.interval = interval;
    return DbHelpers.updateInterval(id, interval);
  }

  Future<int> updateKeepScreenOn(bool keepScreenOn) async {
    this.keepScreenOn = keepScreenOn;
    return DbHelpers.updateKeepScreenOn(id, keepScreenOn);
  }

  Future<int> updateVibrate(bool vibrate) async {
    this.vibrate = vibrate;
    return DbHelpers.updateVibrate(id, vibrate);
  }

  Future<int> updateSpeak(bool speak) async {
    this.speak = speak;
    return DbHelpers.updateSpeak(id, speak);
  }

  Future<int> updateSpeakShort(bool speakShort) async {
    this.speakShort = speakShort;
    return DbHelpers.updateSpeakShort(id, speakShort);
  }

  Future<int> updateVibrateAtInterval(bool vibrateAtInterval) async {
    this.vibrateAtInterval = vibrateAtInterval;
    return DbHelpers.updateVibrateAtInterval(id, vibrateAtInterval);
  }

  Future<int> updateShowNotification(bool showNotification) async {
    this.showNotification = showNotification;
    return DbHelpers.updateShowNotification(id, showNotification);
  }

  Future<int> updateVolume(double volume) async {
    this.volume = volume;
    return DbHelpers.updateVolume(id, volume);
  }

  Future<int> updateLanguage(String language) async {
    this.language = language;
    return DbHelpers.updateLanguage(id, language);
  }

  static Future<SettingsData> getSettings(String languageCode) async {
    SettingsData settings;
    List<Map<String, dynamic>> data = await DbHelpers.query(DbSql.tableSettings,
        where: "id = ?", whereArgs: ["settings"]);
    if (data.length != 0) {
      settings = SettingsData.fromMap(data[0]);
    } else {
      settings = SettingsData(language: languageCode);
      await settings.save();
    }

    return settings;
  }
}
