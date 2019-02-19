enum TimerState { start, cancel, reset, setTime, updateValue }

class TimerValues {
  final TimerState timerState;
  final int time;
  
  TimerValues(
      {this.timerState,
      this.time
      });
}
