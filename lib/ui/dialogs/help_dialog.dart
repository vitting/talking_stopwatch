import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
              /// Settings
              Icon(Icons.settings, color: Colors.white, size: 20),
              SizedBox(height: 6),
              Text(FlutterI18n.translate(context, "help.text1"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center),
              SizedBox(height: 20),

              /// Interval
              Container(
                width: 20,
                height: 20,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Center(
                    child: Text("10s",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10))),
              ),
              SizedBox(height: 6),
              Text(FlutterI18n.translate(context, "help.text7"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center),
              SizedBox(height: 20),

              /// Volume and speak
              Icon(MdiIcons.volumeHigh, color: Colors.white, size: 20),
              SizedBox(height: 6),
              Text(FlutterI18n.translate(context, "help.text8"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center),
              SizedBox(height: 6),
              Text(FlutterI18n.translate(context, "help.text6"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center),
              SizedBox(height: 20),

              /// Start stopwatch
              Icon(MdiIcons.play, color: Colors.white, size: 20),
              SizedBox(height: 6),
              Text(FlutterI18n.translate(context, "help.text2"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center),
              SizedBox(height: 5),
              Text(FlutterI18n.translate(context, "help.text3"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center),
              SizedBox(height: 20),

              /// Pause stopwatch
              Icon(MdiIcons.pause, color: Colors.white, size: 20),
              SizedBox(height: 6),
              Text(FlutterI18n.translate(context, "help.text4"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center),
              SizedBox(height: 5),
              Text(FlutterI18n.translate(context, "help.text5"),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center),
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
