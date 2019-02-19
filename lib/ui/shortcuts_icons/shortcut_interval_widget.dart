import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:talking_stopwatch/helpers/common_functions.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/timer_values.dart';

class ShortcutInterval extends StatefulWidget {
  final SettingsData settings;
  final StreamController controller;

  const ShortcutInterval({Key key, this.settings, this.controller})
      : super(key: key);
  @override
  _ShortcutIntervalState createState() => _ShortcutIntervalState();
}

class _ShortcutIntervalState extends State<ShortcutInterval> {
  int _intervalIndex = 0;

  @override
  void initState() {
    _intervalIndex = widget.settings.interval == 10 ? 0 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 70,
      top: 40,
      child: IndexedStack(
        index: _intervalIndex,
        children: <Widget>[
          IconButton(
            tooltip: FlutterI18n.translate(context, "shortcutInterval.text1"),
            highlightColor: Colors.blue[800],
            iconSize: 30,
            icon: Container(
              width: 30,
              height: 30,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Center(
                  child: Text("10s",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))),
            ),
            color: Colors.white,
            onPressed: () async {
              vibrateButton(widget.settings.vibrate);
              await widget.settings.updateInterval(30);

              widget.controller.add(
                  getTimeValues(TimerState.updateValue));

              setState(() {
                _intervalIndex = 1;
              });
            },
          ),
          IconButton(
            tooltip: FlutterI18n.translate(context, "shortcutInterval.text2"),
            highlightColor: Colors.blue[800],
            iconSize: 30,
            icon: Container(
              width: 30,
              height: 30,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: Center(
                  child: Text("30s",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))),
            ),
            color: Colors.white,
            onPressed: () async {
              vibrateButton(widget.settings.vibrate);
              await widget.settings.updateInterval(10);
              widget.controller.add(
                  getTimeValues(TimerState.updateValue));

              setState(() {
                _intervalIndex = 0;
              });
            },
          ),
        ],
      ),
    );
  }
}
