import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class ShortcutHelp extends StatelessWidget {
  final Function onPressed;

  const ShortcutHelp({Key key, @required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 70,
      top: 40,
      child: IconButton(
        tooltip: FlutterI18n.translate(context, "shortcutHelp.text1"),
        highlightColor: Colors.blue[800],
        iconSize: 30,
        icon: Icon(Icons.help),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}