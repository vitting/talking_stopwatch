import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';
import 'package:talking_stopwatch/ui/stopwatch_timer_widget.dart';

TimerValues getTimeValues(TimerState state, int time, SettingsData settings) {
    return TimerValues(
        timerState: state,
        time: time,
        interval: settings.interval,
        speak: settings.speak,
        vibrate: settings.vibrateAtInterval,
        language: settings.language,
        volume: settings.volume);
  }

  void vibrateButton(SettingsData settings) {
    if (settings.vibrate) {
      SystemHelpers.vibrate30();
    }
  }