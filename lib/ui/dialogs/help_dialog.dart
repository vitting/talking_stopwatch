import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpDialog extends StatelessWidget {
  final Function onTap;

  const HelpDialog({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
        child: Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.settings, color: Colors.white, size: 30),
              SizedBox(height: 10),
              Text(FlutterI18n.translate(context, "help.text1"),
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 25),
              Icon(FontAwesomeIcons.play, color: Colors.white, size: 25),
              SizedBox(height: 10),
              Text(FlutterI18n.translate(context, "help.text2"),
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 5),
              Text(FlutterI18n.translate(context, "help.text3"),
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(height: 25),
              Icon(FontAwesomeIcons.pause, color: Colors.white, size: 25),
              SizedBox(height: 10),
              Text(FlutterI18n.translate(context, "help.text4"),
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.blue[800].withAlpha(240),
              borderRadius: BorderRadius.circular(4)),
        ),
      ),
    ));
  }
}
