import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:talking_stopwatch/helpers/db_sql_create.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';

final String dbName = "talkingstopwatchsettings.db";
final int dbVersion = 2;

class DbHelpers {
  static final _lock = new Lock();
  static Database _db;

  static Future<Database> get db async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);

    // Sqflite.setDebugModeOn();

    if (_db == null || !_db.isOpen) {
      try {
        await Directory(databasesPath).create(recursive: true);
      } catch (error) {
        print("Create DB directory error: $error");
      }

      /// Avoid lock issues on Android
      await _lock.synchronized(() async {
        if (_db == null || !_db.isOpen) {
          print("******************Opening database**********************");
          _db = await openDatabase(path, version: dbVersion,
              onCreate: (Database db, int version) async {
            try {
              print("ONCREATE CREATION TABLES");
              await db.execute("${DbSql.createSettings}");
            } catch (error) {
              print("DB ONCREATE ERROR: $error");
            }
          }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
            print("ONUPGRADE: $oldVersion | $newVersion");
            if (oldVersion == 1 && newVersion == 2) {
              try {
                List<Map<String, dynamic>> data = await db.query(
                    DbSql.tableSettings,
                    where: "id = ?",
                    whereArgs: ["settings"]);
                await db.execute("${DbSql.dropSettings}");
                await db.execute("${DbSql.createSettings}");

                if (data.length != 0) {
                  SettingsData settings = SettingsData.fromMap(data[0]);
                  db.insert(DbSql.tableSettings, settings.toMap());
                }
              } catch (error) {
                print("DB ONUPGRADE ERROR: $error");
              }
            }
          }, onOpen: (Database db) async {
            try {
              print("ONOPEN");
            } catch (error) {
              print("DB ONOPEN ERROR: $error");
            }
          }, onDowngrade: (Database db, int oldVersion, int newVersion) {
            print("ONDOWNGRADE");
            // try {
            //   File f = File.fromUri(Uri.file(path));
            //   f.delete();
            // } catch (e) {
            //   print("FILE ERROR: $e");
            // }
          });
        }
      });
    }

    return _db;
  }

  static void close() {
    print("DB CLOSE");
    if (_db == null || _db.isOpen) {
      _db.close();
    }
  }

  static Future<int> insert(String table, Map<String, dynamic> item) async {
    Database dbCon = await db;
    return dbCon.insert(table, item);
  }

  static Future<List<Map<String, dynamic>>> query(String table,
      {bool distinct = false,
      int limit = -1,
      String orderBy,
      String where,
      List<dynamic> whereArgs}) async {
    Database dbCon = await db;
    return dbCon.query(table,
        columns: [],
        distinct: distinct,
        limit: limit,
        orderBy: orderBy,
        where: where,
        whereArgs: whereArgs);
  }

  static Future<int> updateInterval(String id, int interval) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableSettings} SET '${DbSql.colInterval}' = ? WHERE ${DbSql.colId} = ?",
        [interval, id]);
  }

  static Future<int> updateKeepScreenOn(String id, bool keepScreenOn) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableSettings} SET '${DbSql.colKeepScreenOn}' = ? WHERE ${DbSql.colId} = ?",
        [keepScreenOn, id]);
  }

  static Future<int> updateVibrate(String id, bool vibrate) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableSettings} SET '${DbSql.colVibrate}' = ? WHERE ${DbSql.colId} = ?",
        [vibrate, id]);
  }

  static Future<int> updateSpeak(String id, bool speak) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableSettings} SET '${DbSql.colSpeak}' = ? WHERE ${DbSql.colId} = ?",
        [speak, id]);
  }

  static Future<int> updateSpeakShort(String id, bool speakShort) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableSettings} SET '${DbSql.colSpeakShort}' = ? WHERE ${DbSql.colId} = ?",
        [speakShort, id]);
  }

  static Future<int> updateVibrateAtInterval(
      String id, bool vibrateAtInterval) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableSettings} SET '${DbSql.colVibrateAtInterval}' = ? WHERE ${DbSql.colId} = ?",
        [vibrateAtInterval, id]);
  }

  static Future<int> updateVolume(String id, double volume) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableSettings} SET '${DbSql.colVolume}' = ? WHERE ${DbSql.colId} = ?",
        [volume, id]);
  }

  static Future<int> updateLanguage(String id, String language) async {
    Database dbCon = await db;
    return dbCon.rawUpdate(
        "UPDATE ${DbSql.tableSettings} SET '${DbSql.colLanguage}' = ? WHERE ${DbSql.colId} = ?",
        [language, id]);
  }
}
