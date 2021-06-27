import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retropanic/components/localStorage.dart';
import 'package:retropanic/components/uiHelper.dart';
import 'package:retropanic/main.dart';

class Settings extends StatefulWidget {
  const Settings({ Key key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

  static bool _isDarkMode = isDarkMode();
  final Color _backgroundColor = mainUIBackgroundColor(_isDarkMode);
  final Color _textColor = mainUITextColor(_isDarkMode);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retropanic', style: TextStyle(
            color: _textColor
        )),
        iconTheme: IconThemeData(color: _textColor),
        backgroundColor: _backgroundColor,
      ),
      backgroundColor: _backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Notifications: ' + notificationStatus(notificationToggle), style: TextStyle(
                color: _textColor
              )
            ),
            Switch(
              value: notificationToggle,
              onChanged: (value) {
                setState(() {
                  notificationToggle = value;
                  save(value);
                });
              },
              activeTrackColor: _textColor,
              activeColor: Colors.white,
            ),
          ]
        )
      ),
    );
  }
}