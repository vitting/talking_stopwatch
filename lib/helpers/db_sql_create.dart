class DbSql {
  static const String tableSettings = "settings";
  static const String colId = "id";
  static const String colLanguage = "language";
  static const String colVolume = "volume";
  static const String colInterval = "interval";
  static const String colVibrateAtInterval = "vibrateAtInterval";
  static const String colVibrate = "vibrate";
  static const String colSpeak = "speak";
  static const String colSpeakShort = "speakShort";
  static const String colKeepScreenOn = "keepScreenOn";
  static const String colShowNotification = "showNotification";
  static const String createSettings =
      "CREATE TABLE IF NOT EXISTS [$tableSettings] ([$colId] TEXT(50) PRIMARY KEY NOT NULL UNIQUE, [$colLanguage] TEXT(2) NOT NULL, [$colVolume] DOUBLE NOT NULL DEFAULT 0, [$colInterval] INTEGER NOT NULL DEFAULT 0, [$colKeepScreenOn] INTEGER NOT NULL DEFAULT 0, [$colVibrate] INTEGER NOT NULL DEFAULT 0, [$colVibrateAtInterval] INTEGER NOT NULL DEFAULT 0, [$colSpeak] INTEGER NOT NULL DEFAULT 0, [$colShowNotification] INTEGER NOT NULL DEFAULT 0, [$colSpeakShort] INTEGER NOT NULL DEFAULT 0);";
  static const String dropSettings = "DROP TABLE IF EXISTS $tableSettings;";
}
