import 'package:flutter/material.dart';
import 'package:talking_stopwatch/helpers/common_functions.dart';

class SettingsSwitchRowWidget extends StatefulWidget {
  final bool value;
  final bool vibrate;
  final ValueChanged<bool> onChanged;
  final IconData icon;
  final String text;

  const SettingsSwitchRowWidget(
      {Key key,
      @required this.onChanged,
      @required this.value,
      @required this.icon,
      @required this.text,
      @required this.vibrate})
      : super(key: key);
  @override
  _SettingsSwitchRowWidgetState createState() =>
      _SettingsSwitchRowWidgetState();
}

class _SettingsSwitchRowWidgetState extends State<SettingsSwitchRowWidget> {
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();

    _switchValue = widget.value;
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
              child: Icon(widget.icon, color: Colors.white, size: 25),
            ),
            Text(widget.text,
                style: TextStyle(color: Colors.white, fontSize: 18))
          ],
        ),
        Row(
          children: <Widget>[
            Switch(
              value: _switchValue,
              inactiveTrackColor: Colors.grey[400],
              inactiveThumbColor: Colors.grey[700],
              activeColor: Colors.blue[800],
              activeTrackColor: Colors.blue[400],
              onChanged: (bool value) async {
                vibrateButton(widget.vibrate);
                if (widget.onChanged != null) {
                  widget.onChanged(value);
                }
                setState(() {
                  _switchValue = value;
                });
              },
            )
          ],
        )
      ],
    );
  }
}
