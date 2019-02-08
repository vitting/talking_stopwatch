import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';
import 'package:talking_stopwatch/helpers/system_helpers.dart';

class ExitDialog extends StatelessWidget {
  final SettingsData settings;

  const ExitDialog({Key key, @required this.settings}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Text(
                FlutterI18n.translate(context, "exit.text1"),
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue[800],
                  padding: EdgeInsets.all(10),
                  shape: CircleBorder(),
                  onPressed: () {
                    _vibrateButton();
                    Navigator.of(context).pop(true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(FlutterI18n.translate(context, "exit.text2"),
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
                RaisedButton(
                  color: Colors.grey[700],
                  padding: EdgeInsets.all(10),
                  shape: CircleBorder(),
                  onPressed: () {
                    _vibrateButton();
                    Navigator.of(context).pop(false);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(FlutterI18n.translate(context, "exit.text3"),
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  void _vibrateButton() {
    if (settings.vibrate) {
      SystemHelpers.vibrate30();
    }
  }
}
