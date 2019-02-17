import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:talking_stopwatch/helpers/common_functions.dart';
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
  String _languageButtonSelected = "en";
  bool _keepScreenOn = false;
  bool _vibrate = true;
  bool _vibrateAtInterval = false;

  @override
  void initState() {
    super.initState();

    _keepScreenOn = widget.settings.keepScreenOn;
    _vibrate = widget.settings.vibrate;
    _vibrateAtInterval = widget.settings.vibrateAtInterval;
    _languageButtonSelected = widget.settings.language;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.only(left: 10, right: 10, top: 20),
      backgroundColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(FlutterI18n.translate(context, "settings.text1"),
              style: TextStyle(color: Colors.white)),
          IconButton(
            color: Colors.white,
            iconSize: 30,
            icon: Icon(Icons.close),
            onPressed: () {
              vibrateButton(widget.settings);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      children: <Widget>[
        Column(
          children: <Widget>[
            _languageWidget(),
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

  Widget _languageWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(Icons.language, color: Colors.white, size: 25),
            ),
            Text(FlutterI18n.translate(context, "settings.text2"),
                style: TextStyle(color: Colors.white, fontSize: 18))
          ],
        ),
        Row(
          children: <Widget>[
            InkWell(
              enableFeedback: false,
              splashColor: Colors.black,
              onTap: () async {
                vibrateButton(widget.settings);
                await widget.settings.updateLanguage("da");
                setState(() {
                  _languageButtonSelected = "da";
                });
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    color: _languageButtonSelected == "da"
                        ? Colors.blue[800]
                        : Colors.grey[700],
                    shape: BoxShape.circle),
                child: Center(
                    child: Text("Dk",
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
                vibrateButton(widget.settings);
                await widget.settings.updateLanguage("en");
                setState(() {
                  _languageButtonSelected = "en";
                });
              },
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    color: _languageButtonSelected == "en"
                        ? Colors.blue[800]
                        : Colors.grey[700],
                    shape: BoxShape.circle),
                child: Center(
                    child: Text("En",
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
              child: Icon(MdiIcons.cellphoneScreenshot,
                  color: Colors.white, size: 25),
            ),
            Text(FlutterI18n.translate(context, "settings.text5"),
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
                vibrateButton(widget.settings);
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
            Text(FlutterI18n.translate(context, "settings.text6"),
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
                vibrateButton(widget.settings);
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
            Text(FlutterI18n.translate(context, "settings.text8"),
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
                vibrateButton(widget.settings);
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
}
