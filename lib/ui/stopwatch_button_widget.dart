import 'package:flutter/material.dart';

enum StopwatchButtonAction { playLongPress, playTap, pauseTap }

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
          onLongPress: () {
            if (onPressed != null) {
              onPressed(StopwatchButtonAction.playLongPress);
            }
          },
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
        IconButton(
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
      ],
    );
  }
}
