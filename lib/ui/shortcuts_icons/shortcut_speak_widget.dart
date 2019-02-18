import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:talking_stopwatch/helpers/common_functions.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/timer_values.dart';

class ShortcutSpeak extends StatefulWidget {
  final SettingsData settings;
  final StreamController controller;

  const ShortcutSpeak({Key key, this.settings, this.controller})
      : super(key: key);
  @override
  _ShortcutSpeakState createState() => _ShortcutSpeakState();
}

class _ShortcutSpeakState extends State<ShortcutSpeak> {
  int _speakIndex = 0;

  @override
  void initState() {
    _speakIndex = widget.settings.speak ? 0 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      top: 40,
      child: IndexedStack(
        index: _speakIndex,
        children: <Widget>[
          IconButton(
            tooltip: FlutterI18n.translate(context, "shortcutSpeak.text1"),
            highlightColor: Colors.blue[800],
            iconSize: 30,
            icon: Icon(MdiIcons.voice),
            color: Colors.white,
            onPressed: () async {
              vibrateButton(widget.settings.vibrate);
              await widget.settings.updateSpeak(false);
              widget.controller.add(
                  getTimeValues(TimerState.updateValue, null, widget.settings));

              setState(() {
                _speakIndex = 1;
              });
            },
          ),
          IconButton(
            tooltip: FlutterI18n.translate(context, "shortcutSpeak.text2"),
            highlightColor: Colors.blue[800],
            iconSize: 30,
            icon: Icon(MdiIcons.voice),
            color: Colors.white24,
            onPressed: () async {
              vibrateButton(widget.settings.vibrate);
              await widget.settings.updateSpeak(true);
              widget.controller.add(
                  getTimeValues(TimerState.updateValue, null, widget.settings));

              setState(() {
                _speakIndex = 0;
              });
            },
          )
        ],
      ),
    );
  }
}
