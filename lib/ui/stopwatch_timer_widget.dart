import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TimerValues {
  final TimerState timerState;
  final int time;

  TimerValues(this.timerState, this.time);
}

enum TimerState { start, cancel, reset, setTime }

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
  String _ttsReset = "Stopwatch resetted";
  String _ttsAnd = "and";

  @override
  void initState() {
    super.initState();

    if (widget.languageCode == "da") {
      _ttsMinutePlur = "minutter";
      _ttsMinute = "minut";
      _ttsSecondPlur = "sekunder";
      _ttsStarted = "Stopur started";
      _ttsPaused = "Stopur på pause";
      _ttsReset = "Stopur nulstillet";
      _ttsAnd = "og";
    }

    widget.timeStream.listen((TimerValues item) {
      switch (item.timerState) {
        case TimerState.start:
          widget.flutterTts.speak(_ttsStarted);

          if (_timer == null) {
            _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
              _elapsedTime += 1;
              formatTime(true);
            });
          }
          break;
        case TimerState.reset:
          widget.flutterTts.speak(_ttsReset);
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
          widget.flutterTts.speak(_ttsPaused);
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
              style: TextStyle(color: Colors.white, fontSize: 60)),
        ],
      ),
    );
  }

  void formatTime(bool speak) {
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
      _speakTime(_elapsedTimeMinutes, _elapsedTimeSeconds);
    }
  }

  void _speakTime(int minutes, int seconds) async {
    if (seconds == 0 || seconds % 10 == 0) {
      if (minutes == 0) {
        widget.flutterTts.speak("$seconds $_ttsSecondPlur");
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
