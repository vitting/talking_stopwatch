import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talking_stopwatch/helpers/common_functions.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/ui/dialogs/exit_dialog.dart';
import 'package:talking_stopwatch/ui/dialogs/help_dialog.dart';
import 'package:talking_stopwatch/ui/shortcuts_icons/shortcut_help_widget.dart';
import 'package:talking_stopwatch/ui/shortcuts_icons/shortcut_interval_widget.dart';
import 'package:talking_stopwatch/ui/shortcuts_icons/shortcut_settings_widget.dart';
import 'package:talking_stopwatch/ui/shortcuts_icons/shortcut_speak_widget.dart';
import 'package:talking_stopwatch/ui/shortcuts_icons/shortcut_volume_widget.dart';
import 'package:talking_stopwatch/ui/stopwatch_button_widget.dart';
import 'package:talking_stopwatch/ui/stopwatch_timer_widget.dart';

class StopwatchMain extends StatefulWidget {
  static final String routename = "stopmatchmain";
  final String languageCode;
  final FlutterTts flutterTts;
  final SettingsData settings;

  const StopwatchMain(
      {Key key, this.languageCode = "en", this.flutterTts, this.settings})
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
  String _languageCode = "en";
  bool _showHelp = false;

  @override
  void initState() {
    super.initState();
    _languageCode = widget.languageCode;

    initSettings();
  }

  void initSettings() async {
    if (widget.settings.keepScreenOn) {
      SystemHelpers.setScreenOn();
    }

    if (widget.settings.language == "da" &&
        await widget.flutterTts.isLanguageAvailable("da-DK")) {
      widget.flutterTts.setLanguage("da-DK");
    } else {
      if (await widget.flutterTts.isLanguageAvailable("en-US")) {
        widget.flutterTts.setLanguage("en-US");
      } else {
        _languageCode = "other";
      }
    }

    await widget.flutterTts.setVolume(widget.settings.volume);
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
                      StopwatchWidget(
                        timeStream: _stopwatchController.stream,
                        languageCode: _languageCode,
                        flutterTts: widget.flutterTts,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      StopwatchButton(
                        buttonIndex: _buttonIndex,
                        onPressed: (StopwatchButtonAction action) {
                          _buttonAction(action);
                        },
                      ),
                    ],
                  ),
                ),
                ShortcutSpeak(
                  controller: _stopwatchController,
                  settings: widget.settings,
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
                    vibrateButton(widget.settings);

                    setState(() {
                      _showHelp = !_showHelp;
                    });
                  },
                ),
                _showHelp
                    ? HelpDialog(onTap: () {
                        vibrateButton(widget.settings);
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
        vibrateButton(widget.settings);
        _stopwatchController
            .add(getTimeValues(TimerState.start, null, widget.settings));
        setState(() {
          _buttonIndex = 1;
        });
        break;
      case StopwatchButtonAction.playLongPress:
        vibrateButton(widget.settings);
        _stopwatchController
            .add(getTimeValues(TimerState.reset, 0, widget.settings));
        break;
      case StopwatchButtonAction.pauseTap:
        vibrateButton(widget.settings);
        _stopwatchController
            .add(getTimeValues(TimerState.cancel, 0, widget.settings));
        setState(() {
          _buttonIndex = 0;
        });
        break;
      case StopwatchButtonAction.pauseLongPress:
        vibrateButton(widget.settings);
        _stopwatchController
            .add(getTimeValues(TimerState.reset, 0, widget.settings));
        _stopwatchController
            .add(getTimeValues(TimerState.start, null, widget.settings));
        break;
    }
  }

  Future<bool> _willPop(BuildContext context) async {
    vibrateButton(widget.settings);
    if (_showHelp) {
      setState(() {
        _showHelp = false;
      });
      return false;
    } else {
      return showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) =>
              ExitDialog(settings: widget.settings));
    }
  }
}
