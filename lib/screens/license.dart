import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:retropanic/components/uiHelper.dart';

class License extends StatelessWidget{

  static bool _isDarkMode = isDarkMode();
  final Color _backgroundColor = mainUIBackgroundColor(_isDarkMode);
  final Color _textColor = mainUITextColor(_isDarkMode);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Retropanic', style: TextStyle(
            color: _textColor
        )),
        iconTheme: IconThemeData(color: _textColor),
        backgroundColor: _backgroundColor,
      ),
      backgroundColor: _backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Expanded(
            flex: 8,
            child: Text(
              'He is Risen!',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: _textColor,
              )
            )
          )
        ]
      )
    );
  }
}