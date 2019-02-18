import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/helpers/timer_values.dart';

TimerValues getTimeValues(TimerState state, int time, SettingsData settings) {
    return TimerValues(
        timerState: state,
        time: time,
        interval: settings.interval,
        speak: settings.speak,
        speakShort: settings.speakShort,
        vibrate: settings.vibrateAtInterval,
        language: settings.language,
        volume: settings.volume);
  }

  void vibrateButton(bool vibrate) {
    if (vibrate) {
      SystemHelpers.vibrate30();
    }
  }