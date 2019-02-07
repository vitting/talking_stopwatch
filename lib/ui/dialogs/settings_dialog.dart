import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';

class SettingsDialog extends StatefulWidget {
  final SettingsData settings;

  const SettingsDialog({Key key, this.settings}) : super(key: key);
  @override
  SettingsDialogState createState() {
    return new SettingsDialogState();
  }
}

class SettingsDialogState extends State<SettingsDialog> {
  int _intervalButtonSelected = 10;
  bool _keepScreenOn = false;
  bool _vibrate = true;
  bool _speak = true;
  bool _vibrateAtInterval = false;

  @override
  void initState() {
    super.initState();

    _intervalButtonSelected = widget.settings.interval;
    _keepScreenOn = widget.settings.keepScreenOn;
    _vibrate = widget.settings.vibrate;
    _speak = widget.settings.speak;
    _vibrateAtInterval = widget.settings.vibrateAtInterval;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(20),
      backgroundColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Indstillinger", style: TextStyle(color: Colors.white)),
          IconButton(
            color: Colors.white,
            iconSize: 30,
            icon: Icon(Icons.close),
            onPressed: () {
              _vibrateButton();
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      children: <Widget>[
        Column(
          children: <Widget>[
            _speakWidget(),
            SizedBox(height: 20),
            _speakIntervalWidget(),
            SizedBox(height: 20),
            _vibrateAtIntervalWidget(),
            SizedBox(height: 20),
            _keepScreenOnWidget(),
            SizedBox(height: 20),
            _vibrateWidget()
          ],
        )
      ],
    );
  }

  Widget _speakIntervalWidget() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(Icons.timer, color: Colors.white, size: 25),
                    ),
                    Text("Tale interval",
                        style: TextStyle(color: Colors.white, fontSize: 18))
                  ],
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      enableFeedback: false,
                      splashColor: Colors.black,
                      onTap: () async {
                        _vibrateButton();
                        await widget.settings.updateInterval(10);
                        setState(() {
                          _intervalButtonSelected = 10;
                        });
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            color: _intervalButtonSelected == 10
                                ? Colors.blue[800]
                                : Colors.grey[700],
                            shape: BoxShape.circle),
                        child: Center(
                            child: Text("10s",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white))),
                      ),
                    ),
                    SizedBox(width: 15),
                    InkWell(
                      enableFeedback: false,
                      splashColor: Colors.black,
                      onTap: () async {
                        _vibrateButton();
                        await widget.settings.updateInterval(30);
                        setState(() {
                          _intervalButtonSelected = 30;
                        });
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            color: _intervalButtonSelected == 30
                                ? Colors.blue[800]
                                : Colors.grey[700],
                            shape: BoxShape.circle),
                        child: Center(
                            child: Text("30s",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white))),
                      ),
                    )
                  ],
                )
              ],
            );
  }

  Widget _keepScreenOnWidget() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(FontAwesomeIcons.mobile, color: Colors.white, size: 25),
                    ),
                    Text("Sluk ikke skærmen",
                        style: TextStyle(color: Colors.white, fontSize: 18))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Switch(
                      value: _keepScreenOn,
                      inactiveTrackColor: Colors.grey[400],
                      inactiveThumbColor: Colors.grey[700],
                      activeColor: Colors.blue[800],
                      activeTrackColor: Colors.blue[400],
                      onChanged: (bool value) async {
                        _vibrateButton();
                        await widget.settings.updateKeepScreenOn(value);
                        if (value) {
                          SystemHelpers.setScreenOn();
                        } else {
                          SystemHelpers.setScreenOff();
                        }
                        setState(() {
                          _keepScreenOn = value;
                        });
                      },
                    )
                  ],
                )
              ],
            );
  }

  Widget _vibrateWidget() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(Icons.vibration, color: Colors.white, size: 25),
                    ),
                    Text("Vibrer",
                        style: TextStyle(color: Colors.white, fontSize: 18))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Switch(
                      value: _vibrate,
                      inactiveTrackColor: Colors.grey[400],
                      inactiveThumbColor: Colors.grey[700],
                      activeColor: Colors.blue[800],
                      activeTrackColor: Colors.blue[400],
                      onChanged: (bool value) async {
                        _vibrateButton();
                        await widget.settings.updateVibrate(value);
                        setState(() {
                          _vibrate = value;
                        });
                      },
                    )
                  ],
                )
              ],
            );
  }
  
  Widget _speakWidget() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(Icons.volume_up, color: Colors.white, size: 25),
                    ),
                    Text("Tale",
                        style: TextStyle(color: Colors.white, fontSize: 18))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Switch(
                      value: _speak,
                      inactiveTrackColor: Colors.grey[400],
                      inactiveThumbColor: Colors.grey[700],
                      activeColor: Colors.blue[800],
                      activeTrackColor: Colors.blue[400],
                      onChanged: (bool value) async {
                        _vibrateButton();
                        await widget.settings.updateSpeak(value);
                        setState(() {
                          _speak = value;
                        });
                      },
                    )
                  ],
                )
              ],
            );
  }

  Widget _vibrateAtIntervalWidget() {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(Icons.vibration, color: Colors.white, size: 25),
                    ),
                    Text("Vibrer ved interval",
                        style: TextStyle(color: Colors.white, fontSize: 18))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Switch(
                      value: _vibrateAtInterval,
                      inactiveTrackColor: Colors.grey[400],
                      inactiveThumbColor: Colors.grey[700],
                      activeColor: Colors.blue[800],
                      activeTrackColor: Colors.blue[400],
                      onChanged: (bool value) async {
                        _vibrateButton();
                        await widget.settings.updateVibrateAtInterval(value);
                        setState(() {
                          _vibrateAtInterval = value;
                        });
                      },
                    )
                  ],
                )
              ],
            );
  }

  void _vibrateButton() {
    if (widget.settings.vibrate)  {
      SystemHelpers.vibrate30();
    }
  }
}
