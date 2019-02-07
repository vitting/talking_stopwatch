import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/ui/dialogs/exit_dialog.dart';
import 'package:talking_stopwatch/ui/dialogs/settings_dialog.dart';
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

  @override
  void initState() {
    super.initState();
    _languageCode = widget.languageCode;

    if (widget.settings.keepScreenOn) {
      SystemHelpers.setScreenOn();
    }
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
                        height: 40,
                      ),
                      IndexedStack(
                        index: _buttonIndex,
                        children: <Widget>[
                          InkWell(
                            enableFeedback: false,
                            onLongPress: () {
                              _vibrateButton();
                              _stopwatchController
                                  .add(TimerValues(
                                    timerState: TimerState.reset,
                                    time: 0,
                                    interval: widget.settings.interval,
                                    speak: widget.settings.speak,
                                    vibrate: widget.settings.vibrateAtInterval
                                  ));
                            },
                            child: IconButton(
                              splashColor: Colors.blue[800],
                              iconSize: 60,
                              color: Colors.white,
                              icon: Icon(FontAwesomeIcons.play),
                              onPressed: () async {
                                _vibrateButton();
                                _stopwatchController
                                    .add(TimerValues(
                                      timerState: TimerState.start,
                                    time: null,
                                    interval: widget.settings.interval,
                                    speak: widget.settings.speak,
                                    vibrate: widget.settings.vibrateAtInterval
                                    ));

                                setState(() {
                                  _buttonIndex = 1;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            iconSize: 60,
                            splashColor: Colors.blue[800],
                            color: Colors.white,
                            icon: Icon(FontAwesomeIcons.pause),
                            onPressed: () async {
                              _vibrateButton();
                              _stopwatchController
                                  .add(TimerValues(
                                    timerState: TimerState.cancel,
                                    time: 0,
                                    interval: widget.settings.interval,
                                    speak: widget.settings.speak,
                                    vibrate: widget.settings.vibrateAtInterval
                                  ));
                              setState(() {
                                _buttonIndex = 0;
                              });
                            },
                          ),
                        ],
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
                      _stopwatchController.add(TimerValues(
                                    timerState: TimerState.updateValue,
                                    time: null,
                                    interval: widget.settings.interval,
                                    speak: widget.settings.speak,
                                    vibrate: widget.settings.vibrateAtInterval
                                  ));
                    },
                  ),
                )
              ],
            )));
  }

  Future<void> _showSettings(BuildContext context) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext dialogContext) =>
            SettingsDialog(settings: widget.settings));
  }

  Future<bool> _willPop(BuildContext context) async {
    _vibrateButton();

    return showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => ExitDialog(settings: widget.settings));
  }

  void _vibrateButton() {
    if (widget.settings.vibrate)  {
      SystemHelpers.vibrate30();
    }
  }
}
