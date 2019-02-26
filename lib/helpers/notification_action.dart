import 'package:flutter/services.dart';

class NotificationAction {
  MethodChannel _methodeChannel =
      const MethodChannel("talking.stopwatch.dk/notification");
  EventChannel _eventChannel =
      const EventChannel("talking.stopwatch.dk/stream");
  Stream<dynamic> _nofiticationEventStream;

  NotificationAction() {
    _methodeChannel = const MethodChannel("talking.stopwatch.dk/notification");
    _eventChannel = const EventChannel("talking.stopwatch.dk/stream");
  }

  /// buttonAction = play | pause
  Future<bool> show(String title, String body, String actionButtonToShow,
      [String buttonText = "",
      String button2Text = "",
      String button3Text = ""]) async {
    try {
      var result = await _methodeChannel.invokeMethod("showNotification", {
        "title": title,
        "body": body,
        "actionButtonToShow": actionButtonToShow,
        "buttonText": buttonText,
        "button2Text": button2Text,
        "button3Text": button3Text
      });

      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> cancel() async {
    try {
      var result = await _methodeChannel.invokeMethod("cancelNotification");
      return result;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<String> get nofiticationEventStream {
    _nofiticationEventStream ??= _eventChannel.receiveBroadcastStream();
    return _nofiticationEventStream
        .map<String>((dynamic value) => value.toString());
  }

  Future<bool> initialize() async {
    try {
      var result = await _methodeChannel.invokeMethod("initializeNotification");
      return result.toString().isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
