import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/ui/dialogs/exit_dialog.dart';
import 'package:talking_stopwatch/ui/dialogs/help_dialog.dart';
import 'package:talking_stopwatch/ui/dialogs/settings_dialog.dart';
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
  int _speakIndex = 0;
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

    print(await widget.flutterTts.isLanguageAvailable("en-US"));

    if (widget.settings.language == "da" &&
        await widget.flutterTts.isLanguageAvailable("da-DK")) {
      widget.flutterTts.setLanguage("da-DK");
      // print("Setting DA");
    } else {
      if (await widget.flutterTts.isLanguageAvailable("en-US")) {
        widget.flutterTts.setLanguage("en-US");
        // print("Setting EN");
      } else {
        _languageCode = "other";
        // print("Setting OTHER");
      }
    }

    await widget.flutterTts.setVolume(widget.settings.volume);

    _speakIndex = widget.settings.speak ? 0 : 1;
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      StopwatchWidget(
                        timeStream: _stopwatchController.stream,
                        languageCode: _languageCode,
                        flutterTts: widget.flutterTts,
                      ),
                      SizedBox(
                        height: 20,
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
                Positioned(
                  left: 20,
                  top: 40,
                  child: IndexedStack(
                    index: _speakIndex,
                    children: <Widget>[
                      IconButton(
                        iconSize: 30,
                        icon: Icon(MdiIcons.voice),
                        color: Colors.white,
                        onPressed: () async {
                          _vibrateButton();
                          await widget.settings.updateSpeak(false);
                          _stopwatchController.add(
                              _getTimeValues(TimerState.updateValue, null));

                          setState(() {
                            _speakIndex = 1;
                          });
                        },
                      ),
                      IconButton(
                        iconSize: 30,
                        icon: Icon(MdiIcons.voice),
                        color: Colors.white24,
                        onPressed: () async {
                          _vibrateButton();
                          await widget.settings.updateSpeak(true);
                          _stopwatchController.add(
                              _getTimeValues(TimerState.updateValue, null));

                          setState(() {
                            _speakIndex = 0;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 40,
                  child: IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.settings),
                    color: Colors.white,
                    onPressed: () async {
                      _vibrateButton();
                      await _showSettings(context);
                      await FlutterI18n.refresh(
                          context, widget.settings.language);
                      _stopwatchController
                          .add(_getTimeValues(TimerState.updateValue, null));
                      
                      setState(() {
                        _speakIndex = widget.settings.speak ? 0 : 1; 
                      });
                    },
                  ),
                ),
                Positioned(
                  right: 70,
                  top: 40,
                  child: IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.help),
                    color: Colors.white,
                    onPressed: () async {
                      _vibrateButton();

                      setState(() {
                        _showHelp = !_showHelp;
                      });
                    },
                  ),
                ),
                _showHelp
                    ? HelpDialog(onTap: () {
                        _vibrateButton();
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
        _vibrateButton();
        _stopwatchController.add(_getTimeValues(TimerState.start, null));
        setState(() {
          _buttonIndex = 1;
        });
        break;
      case StopwatchButtonAction.playLongPress:
        _vibrateButton();
        _stopwatchController.add(_getTimeValues(TimerState.reset, 0));
        break;
      case StopwatchButtonAction.pauseTap:
        _vibrateButton();
        _stopwatchController.add(_getTimeValues(TimerState.cancel, 0));
        setState(() {
          _buttonIndex = 0;
        });
        break;
      case StopwatchButtonAction.pauseLongPress:
        _vibrateButton();
        _stopwatchController.add(_getTimeValues(TimerState.reset, 0));
        _stopwatchController.add(_getTimeValues(TimerState.start, null));
        break;
    }
  }

  TimerValues _getTimeValues(TimerState state, int time) {
    return TimerValues(
        timerState: state,
        time: time,
        interval: widget.settings.interval,
        speak: widget.settings.speak,
        vibrate: widget.settings.vibrateAtInterval,
        language: widget.settings.language,
        volume: widget.settings.volume);
  }

  Future<void> _showSettings(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) =>
            SettingsDialog(settings: widget.settings));
  }

  Future<bool> _willPop(BuildContext context) async {
    _vibrateButton();
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

  void _vibrateButton() {
    if (widget.settings.vibrate) {
      SystemHelpers.vibrate30();
    }
  }
}
