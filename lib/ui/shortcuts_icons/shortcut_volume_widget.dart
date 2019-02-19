import 'dart:async';

import 'package:flutter/material.dart';
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
  int _prevVolumeIndex = 0;

  @override
  void initState() {
    _volumeIndex = widget.settings.volume == 1.0
        ? 2
        : widget.settings.volume == 0.5 ? 0 : 1;

    _prevVolumeIndex = _volumeIndex;

    if (!widget.settings.speak) {
      _volumeIndex = 3;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      top: 40,
      child: InkWell(
        enableFeedback: false,
        borderRadius: BorderRadius.circular(360),
        highlightColor: Colors.blue[800],
        splashColor: Colors.blue[800],
        onLongPress: () async {
          int index;
          vibrateButton(widget.settings.vibrate);

          if (_volumeIndex == 3) {
            index = _prevVolumeIndex;
            await widget.settings.updateSpeak(true);
          } else {
            index = 3;
            _prevVolumeIndex = _volumeIndex;
            await widget.settings.updateSpeak(false);
          }

          widget.controller.add(
              getTimeValues(TimerState.updateValue, null, widget.settings));

          setState(() {
            _volumeIndex = index;
          });
        },
        child: IndexedStack(
          index: _volumeIndex,
          children: <Widget>[
            IconButton(
              highlightColor: Colors.blue[800],
              splashColor: Colors.blue[800],
              iconSize: 30,
              icon: Icon(MdiIcons.volumeLow),
              color: Colors.white,
              onPressed: () async {
                if (_volumeIndex != 3) {
                  vibrateButton(widget.settings.vibrate);
                  await widget.settings.updateVolume(0.7);

                  widget.controller.add(getTimeValues(
                      TimerState.updateValue, null, widget.settings));

                  setState(() {
                    _volumeIndex = 1;
                    _prevVolumeIndex = 1;
                  });
                }
              },
            ),
            IconButton(
              highlightColor: Colors.blue[800],
              splashColor: Colors.blue[800],
              iconSize: 30,
              icon: Icon(MdiIcons.volumeMedium),
              color: Colors.white,
              onPressed: () async {
                if (_volumeIndex != 3) {
                  vibrateButton(widget.settings.vibrate);
                  await widget.settings.updateVolume(1.0);

                  widget.controller.add(getTimeValues(
                      TimerState.updateValue, null, widget.settings));

                  setState(() {
                    _volumeIndex = 2;
                    _prevVolumeIndex = 2;
                  });
                }
              },
            ),
            IconButton(
              highlightColor: Colors.blue[800],
              splashColor: Colors.blue[800],
              iconSize: 30,
              icon: Icon(MdiIcons.volumeHigh),
              color: Colors.white,
              onPressed: () async {
                if (_volumeIndex != 3) {
                  vibrateButton(widget.settings.vibrate);
                  await widget.settings.updateVolume(0.5);

                  widget.controller.add(getTimeValues(
                      TimerState.updateValue, null, widget.settings));

                  setState(() {
                    _volumeIndex = 0;
                    _prevVolumeIndex = 0;
                  });
                }
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Icon(MdiIcons.volumeOff, color: Colors.white, size: 30),
            )
          ],
        ),
      ),
    );
  }
}
