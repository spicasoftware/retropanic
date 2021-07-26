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
              'Licensed under the GNU General Public License:'
                '\nRetroPanic, a personal development application'
                '\nCopyright (C) 2021 Spica Labs\n'

                '\nThis program is free software: you can redistribute it and/or modify'
                ' it under the terms of the GNU General Public License as published by'
                ' the Free Software Foundation, version 3 of the License.\n'

                '\nThis program is distributed in the hope that it will be useful,'
                ' but WITHOUT ANY WARRANTY; without even the implied warranty of'
                ' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the'
                ' GNU General Public License for more details.\n'

                '\nYou should have received a copy of the GNU General Public License'
                ' along with this program.  If not, see <https://www.gnu.org/licenses/>.',
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