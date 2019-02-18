enum TimerState { start, cancel, reset, setTime, updateValue }

class TimerValues {
  final TimerState timerState;
  final int time;
  final int interval;
  final bool vibrate;
  final bool speak;
  final bool speakShort;
  final double volume;
  final String language;

  TimerValues(
      {this.timerState,
      this.time,
      this.interval = 10,
      this.vibrate = false,
      this.speak = true,
      this.speakShort = false,
      this.volume = 1.0,
      this.language = "en"});
}
