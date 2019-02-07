import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talking_stopwatch/ui/stopwatch_timer_widget.dart';

class StopwatchMain extends StatefulWidget {
  static final String routename = "stopmatchmain";
  final String languageCode;
  final FlutterTts flutterTts;

  const StopwatchMain({Key key, this.languageCode = "en", this.flutterTts}) : super(key: key);

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
  }

  @override
  void dispose() {
    _stopwatchController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _willPop(context),
        child: Scaffold(
            backgroundColor: Colors.black,
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StopwatchWidget(
                    timeStream: _stopwatchController.stream,
                    languageCode: _languageCode,
                    flutterTts: widget.flutterTts,
                  ),
                  IndexedStack(
                    index: _buttonIndex,
                    children: <Widget>[
                      InkWell(
                        onLongPress: () {
                          _stopwatchController
                              .add(TimerValues(TimerState.reset, 0));
                        },
                        child: IconButton(
                          iconSize: 80,
                          color: Colors.white,
                          icon: Icon(Icons.play_circle_outline),
                          onPressed: () async {
                            _stopwatchController
                                .add(TimerValues(TimerState.start, null));

                            setState(() {
                              _buttonIndex = 1;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        iconSize: 80,
                        color: Colors.white,
                        icon: Icon(Icons.pause_circle_outline),
                        onPressed: () async {
                          _stopwatchController
                              .add(TimerValues(TimerState.cancel, 0));
                          setState(() {
                            _buttonIndex = 0;
                          });
                        },
                      ),
                    ],
                  )
                ],
              ),
            )));
  }

  Future<bool> _willPop(BuildContext context) async {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext dialogContext) => SimpleDialog(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("SOME TEXT"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.all(10),
                          shape: CircleBorder(),
                          onPressed: () {
                            Navigator.of(dialogContext).pop(true);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Ja"),
                          ),
                        ),
                        RaisedButton(
                          padding: EdgeInsets.all(10),
                          shape: CircleBorder(),
                          onPressed: () {
                            Navigator.of(dialogContext).pop(false);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Nej"),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ));
  }
}
