import 'package:flutter/services.dart';

class NotificationAction {
  static const MethodChannel _methodeChannel =
      const MethodChannel("talking.stopwatch.dk/notification");
  static const EventChannel _eventChannel =
      const EventChannel("talking.stopwatch.dk/stream");

  static Stream<dynamic> _nofiticationEventStream;

  /// buttonAction = play | pause
  static Future<String> show(String title, String body, String actionButtonToShow, String buttonText, String button2Text) async {
    try {
      var result = await _methodeChannel.invokeMethod("showNotification", {
        "title":title,
        "body":body,
        "actionButtonToShow":actionButtonToShow,
        "buttonText":buttonText,
        "button2Text":button2Text
      });
      
      return result.toString();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String> cancel() async {
    try {
      var result = await _methodeChannel.invokeMethod("cancelNotification");
      return result.toString();
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Stream<String> get nofiticationEventStream {
    _nofiticationEventStream ??= _eventChannel.receiveBroadcastStream();
    return _nofiticationEventStream
        .map<String>((dynamic value) => value.toString());
  }

  static Future<bool> initialize() async {
    try {
      var result = await _methodeChannel.invokeMethod("initializeNotification");
      return result.toString().isNotEmpty;
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }
}
