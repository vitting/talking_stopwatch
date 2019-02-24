import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talking_stopwatch/helpers/common_functions.dart';
import 'package:talking_stopwatch/helpers/notification_action.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/helpers/timer_values.dart';
import 'package:talking_stopwatch/ui/dialogs/exit_dialog.dart';
import 'package:talking_stopwatch/ui/dialogs/help_dialog.dart';
import 'package:talking_stopwatch/ui/shortcuts_icons/shortcut_help_widget.dart';
import 'package:talking_stopwatch/ui/shortcuts_icons/shortcut_interval_widget.dart';
import 'package:talking_stopwatch/ui/shortcuts_icons/shortcut_settings_widget.dart';
import 'package:talking_stopwatch/ui/shortcuts_icons/shortcut_volume_widget.dart';
import 'package:talking_stopwatch/ui/stopwatch_button_widget.dart';
import 'package:talking_stopwatch/ui/stopwatch_timer_widget.dart';

class StopwatchMain extends StatefulWidget {
  final FlutterTts flutterTts;
  final SettingsData settings;
  
  const StopwatchMain(
      {Key key, this.flutterTts, this.settings})
      : super(key: key);

  @override
  StopwatchMainState createState() {
    return new StopwatchMainState();
  }
}

class StopwatchMainState extends State<StopwatchMain> {
  final StreamController<TimerValues> _stopwatchController =
      StreamController<TimerValues>.broadcast();
  int _buttonIndex = 0;
  bool _showHelp = false;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // _initNotification();

    NotificationAction.nofiticationEventStream.listen((String value) {
      if (value == "SHIT DET VIRKER") {
        NotificationAction.show("Notification Title", (++_counter).toString(), "notplay");
      }
      print(value);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  @override
  void didUpdateWidget(StopwatchMain oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void dispose() {
    _stopwatchController.close();
    if (widget.settings.keepScreenOn) {
      SystemHelpers.setScreenOff();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _willPop(context),
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                  child: Text("Show"),
                  onPressed: () async {
                    try {

                      String result = await NotificationAction.show("Notification Title", (++_counter).toString(), "play");
                      bool result2 = await NotificationAction.initialize();

                      print(result);
                      print(result2);
                    } on PlatformException catch (e) {}

                    setState(() {});
                  },
                ),
                RaisedButton(
                  child: Text("Hide"),
                  onPressed: () async {
                    try {
                      String result = await NotificationAction.cancel();
                      
                      print(result);
                      
                    } on PlatformException catch (e) {}

                    setState(() {});
                  },
                ),
                      StopwatchWidget(
                        timeStream: _stopwatchController.stream,
                        settings: widget.settings,
                        flutterTts: widget.flutterTts,
                        flutterNotification: null,
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      StopwatchButton(
                        buttonIndex: _buttonIndex,
                        onPressed: (StopwatchButtonAction action) {
                          _buttonAction(action);
                        },
                      )
                    ],
                  ),
                ),
                ShortcutInterval(
                  controller: _stopwatchController,
                  settings: widget.settings,
                ),
                ShortcutVolume(
                  controller: _stopwatchController,
                  settings: widget.settings,
                ),
                ShortcutSettings(
                  controller: _stopwatchController,
                  settings: widget.settings,
                ),
                ShortcutHelp(
                  onPressed: () {
                    vibrateButton(widget.settings.vibrate);

                    setState(() {
                      _showHelp = !_showHelp;
                    });
                  },
                ),
                _showHelp
                    ? HelpDialog(onTap: () {
                        vibrateButton(widget.settings.vibrate);
                        setState(() {
                          _showHelp = false;
                        });
                      })
                    : Container(),
              ],
            )));
  }

  void _buttonAction(StopwatchButtonAction action) {
    switch (action) {
      case StopwatchButtonAction.playTap:
        vibrateButton(widget.settings.vibrate);
        _stopwatchController.add(getTimeValues(TimerState.start));
        setState(() {
          _buttonIndex = 1;
        });
        break;
      case StopwatchButtonAction.playLongPress:
        vibrateButton(widget.settings.vibrate);
        _stopwatchController.add(getTimeValues(TimerState.reset, 0));
        break;
      case StopwatchButtonAction.pauseTap:
        vibrateButton(widget.settings.vibrate);
        _stopwatchController.add(getTimeValues(TimerState.cancel, 0));
        setState(() {
          _buttonIndex = 0;
        });
        break;
      case StopwatchButtonAction.pauseLongPress:
        vibrateButton(widget.settings.vibrate);
        _stopwatchController.add(getTimeValues(TimerState.reset, 0));
        _stopwatchController.add(getTimeValues(TimerState.start));
        break;
    }
  }

  Future<bool> _willPop(BuildContext context) async {
    vibrateButton(widget.settings.vibrate);
    if (_showHelp) {
      setState(() {
        _showHelp = false;
      });
      return false;
    } else {
      bool exitApp = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) =>
              ExitDialog(settings: widget.settings));

      if (exitApp) {
        // widget.flutterNotification.cancel(0);
      }

      return exitApp;
    }
  }
}
