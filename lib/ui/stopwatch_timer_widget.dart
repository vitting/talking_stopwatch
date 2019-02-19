import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/helpers/timer_values.dart';

class StopwatchWidget extends StatefulWidget {
  final Stream<TimerValues> timeStream;
  final SettingsData settings;
  final FlutterTts flutterTts;

  const StopwatchWidget(
      {Key key,
      this.timeStream,
      this.flutterTts,
      this.settings})
      : super(key: key);
  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  Timer _timer;
  int _elapsedTimeSeconds = 0;
  int _elapsedTimeMinutes = 0;
  String _elapsedTimeSecondsFormatted = "00";
  String _elapsedTimeMinutesFormatted = "00";
  int _elapsedTime = 0;
  String _ttsMinutePlur = "minutes";
  String _ttsMinute = "minute";
  String _ttsSecondPlur = "seconds";
  String _ttsStarted = "Stopwatch started";
  String _ttsPaused = "Stopwatch paused";
  String _ttsReset = "Stopwatch reset";
  String _ttsAnd = "and";
  int _interval = 10;
  bool _vibrate = false;
  bool _speak = true;
  double _volume = 1.0;
  bool _speakShort = false;

  @override
  void initState() {
    super.initState();
    
    _setSettings(
        widget.settings.interval,
        widget.settings.vibrateAtInterval,
        widget.settings.speak,
        widget.settings.speakShort,
        widget.settings.volume,
        widget.settings.language);

    widget.timeStream.listen((TimerValues item) {
      switch (item.timerState) {
        case TimerState.updateValue:
          _setSettings(item.interval, item.vibrate, item.speak, item.speakShort,
              item.volume, item.language);
          break;
        case TimerState.start:
          if (_speak) {
            widget.flutterTts.speak(_ttsStarted);
          }

          if (_timer == null) {
            _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
              _elapsedTime += 1;
              formatTime(_speak, _vibrate);
            });
          }
          break;
        case TimerState.reset:
          if (_speak) {
            widget.flutterTts.speak(_ttsReset);
          }

          _timer?.cancel();
          _timer = null;
          _elapsedTimeMinutes = 0;
          _elapsedTimeSeconds = 0;
          _elapsedTime = 0;

          setState(() {
            _elapsedTimeSecondsFormatted = "00";
            _elapsedTimeMinutesFormatted = "00";
          });
          break;
        case TimerState.cancel:
          if (_speak) {
            widget.flutterTts.speak(_ttsPaused);
          }

          if (_timer != null && _timer.isActive) {
            _timer?.cancel();
            _timer = null;
          }
          break;
        case TimerState.setTime:
          break;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("$_elapsedTimeMinutesFormatted:$_elapsedTimeSecondsFormatted",
              style: TextStyle(color: Colors.white, fontSize: 80)),
        ],
      ),
    );
  }

  void formatTime(bool speak, bool vibrate) {
    setState(() {
      if (_elapsedTime > 59) {
        _elapsedTimeMinutes = (_elapsedTime / 60).floor();
        _elapsedTimeSeconds = (_elapsedTime % 60).floor();
        _elapsedTimeMinutesFormatted = _elapsedTimeMinutes < 10
            ? "0${_elapsedTimeMinutes.toString()}"
            : _elapsedTimeMinutes.toString();
        _elapsedTimeSecondsFormatted = _elapsedTimeSeconds < 10
            ? "0${_elapsedTimeSeconds.toString()}"
            : _elapsedTimeSeconds.toString();
      } else {
        _elapsedTimeSeconds = _elapsedTime;
        _elapsedTimeSecondsFormatted = _elapsedTimeSeconds < 10
            ? "0${_elapsedTimeSeconds.toString()}"
            : _elapsedTimeSeconds.toString();
      }
    });

    if (speak) {
      _speakTime(_elapsedTimeMinutes, _elapsedTimeSeconds, vibrate);
    }
  }

  void _speakTime(int minutes, int seconds, bool vibrate) async {
    if (seconds == 0 || seconds % _interval == 0) {
      if (vibrate) {
        SystemHelpers.vibrate100();
      }

      if (minutes == 0) {
        if (_speakShort) {
          widget.flutterTts.speak("$seconds");
        } else {
          widget.flutterTts.speak("$seconds $_ttsSecondPlur");
        }
      } else {
        if (_speakShort) {
          widget.flutterTts.speak("$minutes:$seconds");
        } else {
          if (minutes == 1) {
            if (seconds == 0) {
              widget.flutterTts.speak("$minutes $_ttsMinute");
            } else {
              widget.flutterTts.speak(
                  "$minutes $_ttsMinute $_ttsAnd $seconds $_ttsSecondPlur");
            }
          } else {
            if (seconds == 0) {
              widget.flutterTts.speak("$minutes $_ttsMinutePlur");
            } else {
              widget.flutterTts.speak(
                  "$minutes $_ttsMinutePlur $_ttsAnd $seconds $_ttsSecondPlur");
            }
          }
        }
      }
    }
  }

  void _setSettings(int interval, bool vibrate, bool speak, bool speakShort,
      double volume, String language) async {
    _interval = interval;
    _vibrate = vibrate;
    _speak = speak;
    _speakShort = speakShort;
    _volume = volume;
    await widget.flutterTts.setVolume(_volume);
    await _setLanguage(language);
  }

  Future<void> _setLanguage(String language) async {
    if (language == "da" &&
        await widget.flutterTts.isLanguageAvailable("da-DK")) {
      await widget.flutterTts.setLanguage("da-DK");
    } else {
      if (await widget.flutterTts.isLanguageAvailable("en-US")) {
        await widget.flutterTts.setLanguage("en-US");
      } else {
        _speakShort = true;
      }
    }

    _ttsMinutePlur = FlutterI18n.translate(context, "stopwatchWidget.text1");
    _ttsMinute = FlutterI18n.translate(context, "stopwatchWidget.text2");
    _ttsSecondPlur = FlutterI18n.translate(context, "stopwatchWidget.text3");
    _ttsStarted = FlutterI18n.translate(context, "stopwatchWidget.text4");
    _ttsPaused = FlutterI18n.translate(context, "stopwatchWidget.text5");
    _ttsReset = FlutterI18n.translate(context, "stopwatchWidget.text6");
    _ttsAnd = FlutterI18n.translate(context, "stopwatchWidget.text7");
  }
}
