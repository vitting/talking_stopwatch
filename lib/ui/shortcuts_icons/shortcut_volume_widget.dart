import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:talking_stopwatch/helpers/common_functions.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/timer_values.dart';

class ShortcutVolume extends StatefulWidget {
  final SettingsData settings;
  final StreamController controller;

  const ShortcutVolume({Key key, this.settings, this.controller})
      : super(key: key);
  @override
  _ShortcutVolumeState createState() => _ShortcutVolumeState();
}

class _ShortcutVolumeState extends State<ShortcutVolume> {
  int _volumeIndex = 0;

  @override
  void initState() {
    _volumeIndex = widget.settings.volume == 1.0
        ? 2
        : widget.settings.volume == 0.5 ? 0 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 120,
      top: 40,
      child: IndexedStack(
        index: _volumeIndex,
        children: <Widget>[
          IconButton(
            tooltip: FlutterI18n.translate(context, "shortcutVolume.text1"),
            highlightColor: Colors.blue[800],
            iconSize: 30,
            icon: Icon(MdiIcons.volumeLow),
            color: Colors.white,
            onPressed: () async {
              vibrateButton(widget.settings.vibrate);
              await widget.settings.updateVolume(0.7);

              widget.controller.add(
                  getTimeValues(TimerState.updateValue, null, widget.settings));

              setState(() {
                _volumeIndex = 1;
              });
            },
          ),
          IconButton(
            tooltip: FlutterI18n.translate(context, "shortcutVolume.text1"),
            highlightColor: Colors.blue[800],
            iconSize: 30,
            icon: Icon(MdiIcons.volumeMedium),
            color: Colors.white,
            onPressed: () async {
              vibrateButton(widget.settings.vibrate);
              await widget.settings.updateVolume(1.0);

              widget.controller.add(
                  getTimeValues(TimerState.updateValue, null, widget.settings));

              setState(() {
                _volumeIndex = 2;
              });
            },
          ),
          IconButton(
            tooltip: FlutterI18n.translate(context, "shortcutVolume.text2"),
            highlightColor: Colors.blue[800],
            iconSize: 30,
            icon: Icon(MdiIcons.volumeHigh),
            color: Colors.white, /// TODO: Lav speak off ved at lave volume om til longpress og så samle to genveje i en
            onPressed: () async {
              vibrateButton(widget.settings.vibrate);
              await widget.settings.updateVolume(0.5);

              widget.controller.add(
                  getTimeValues(TimerState.updateValue, null, widget.settings));

              setState(() {
                _volumeIndex = 0;
              });
            },
          ),
        ],
      ),
    );
  }
}
