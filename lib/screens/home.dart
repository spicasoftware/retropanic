import 'package:flutter/material.dart';
import 'dart:async';
import 'package:workmanager/workmanager.dart';
import 'package:retropanic/components/uiHelper.dart';
import 'package:retropanic/components/ffi.dart';


class MainUI extends StatefulWidget {
  MainUI({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainUIState createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  bool _newStatus;
  static bool _status = ffiCurrentStatus();
  Timer _timer;
  int nextCheck = 15;
  String _uIText = mainUIText(_status);
  Color _textColor = mainUITextColor(_status);
  Color _backgroundColor = mainUIBackgroundColor(_status);

  //Initialize timer to call ffiTest every 15 seconds
  @override
  void initState() {
    ffiInit();
    Workmanager.registerPeriodicTask("1", "Retropanic ongoing notification", frequency: Duration(minutes: 15));

    _timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      setState(() {
        print('state: ');
        _newStatus = ffiCurrentStatus();

        if (_newStatus != _status) {
          _status = _newStatus;

          _uIText = mainUIText(_status);
          _textColor = mainUITextColor(_status);
          _backgroundColor = mainUIBackgroundColor(_status);
        }

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                '$_uIText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}