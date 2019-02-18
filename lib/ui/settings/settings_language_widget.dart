import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:talking_stopwatch/helpers/common_functions.dart';
import 'package:talking_stopwatch/helpers/settings_data.dart';

class SettingsLanguageWidget extends StatefulWidget {
  final SettingsData settings;

  const SettingsLanguageWidget({Key key, this.settings}) : super(key: key);
  @override
  _SettingsLanguageWidgetState createState() => _SettingsLanguageWidgetState();
}

class _SettingsLanguageWidgetState extends State<SettingsLanguageWidget> {
  String _languageButtonSelected = "en";

  @override
  void initState() {
    _languageButtonSelected = widget.settings.language;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                vibrateButton(widget.settings.vibrate);
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
                vibrateButton(widget.settings.vibrate);
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
}
