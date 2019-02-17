import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';

class TimerValues {
  final TimerState timerState;
  final int time;
  final int interval;
  final bool vibrate;
  final bool speak;
  final double volume;
  final String language;

  TimerValues(
      {this.timerState,
      this.time,
      this.interval = 10,
      this.vibrate = false,
      this.speak = true,
      this.volume = 1.0,
      this.language = "en"});
}

enum TimerState { start, cancel, reset, setTime, updateValue }

class StopwatchWidget extends StatefulWidget {
  final Stream<TimerValues> timeStream;
  final String languageCode;
  final FlutterTts flutterTts;

  const StopwatchWidget(
      {Key key, this.timeStream, this.languageCode, this.flutterTts})
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
  String _language = "en";

  @override
  void initState() {
    super.initState();

    _setLanguage(widget.languageCode);

    widget.timeStream.listen((TimerValues item) {
      switch (item.timerState) {
        case TimerState.updateValue:
          _speak = item.speak;
          _interval = item.interval;
          _vibrate = item.vibrate;
          _volume = item.volume;
          _language = item.language;
          _setLanguage(_language);
          widget.flutterTts.setVolume(_volume);
          break;
        case TimerState.start:
          if (widget.languageCode != "other" && _speak) {
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
          if (widget.languageCode != "other" && _speak) {
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
          if (widget.languageCode != "other" && _speak) {
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
        if (widget.languageCode == "other") {
          widget.flutterTts.speak("$seconds");
        } else {
          widget.flutterTts.speak("$seconds $_ttsSecondPlur");
        }
      } else {
        if (widget.languageCode == "other") {
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

  void _setLanguage(String language) async {
    if (language == "da" &&
        await widget.flutterTts.isLanguageAvailable("da-DK")) {
      await widget.flutterTts.setLanguage("da-DK");
    } else {
      if (await widget.flutterTts.isLanguageAvailable("en-US")) {
        await widget.flutterTts.setLanguage("en-US");
      }
    }

    if (language == "da") {
      _ttsMinutePlur = "minutter";
      _ttsMinute = "minut";
      _ttsSecondPlur = "sekunder";
      _ttsStarted = "Stopur started";
      _ttsPaused = "Stopur på pause";
      _ttsReset = "Stopur nulstillet";
      _ttsAnd = "og";
    } else {
      _ttsMinutePlur = "minutes";
      _ttsMinute = "minute";
      _ttsSecondPlur = "seconds";
      _ttsStarted = "Stopwatch started";
      _ttsPaused = "Stopwatch paused";
      _ttsReset = "Stopwatch reset";
      _ttsAnd = "and";
    }
  }
}
