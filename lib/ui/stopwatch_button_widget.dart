import 'package:flutter/material.dart';

enum StopwatchButtonAction { playLongPress, playTap, pauseTap, pauseLongPress }

class StopwatchButton extends StatelessWidget {
  final int buttonIndex;
  final ValueChanged<StopwatchButtonAction> onPressed;

  const StopwatchButton({Key key, this.buttonIndex = 0, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: buttonIndex,
      children: <Widget>[
        InkWell(
          enableFeedback: false,
          highlightColor: Colors.red,
          borderRadius: BorderRadius.circular(360),
          onLongPress: () {
            if (onPressed != null) {
              onPressed(StopwatchButtonAction.playLongPress);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.3),
              ),
            
            child: IconButton(
              splashColor: Colors.blue[800],
              iconSize: 100,
              color: Colors.white,
              icon: Icon(Icons.play_arrow),
              onPressed: () async {
                if (onPressed != null) {
                  onPressed(StopwatchButtonAction.playTap);
                }
              },
            ),
          ),
        ),
        InkWell(
          highlightColor: Colors.red,
          borderRadius: BorderRadius.circular(360),
          onLongPress: () {
            if (onPressed != null) {
              onPressed(StopwatchButtonAction.pauseLongPress);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.3),
              ),
            child: IconButton(
              iconSize: 100,
              splashColor: Colors.blue[800],
              color: Colors.white,
              icon: Icon(Icons.pause),
              onPressed: () async {
                if (onPressed != null) {
                  onPressed(StopwatchButtonAction.pauseTap);
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
