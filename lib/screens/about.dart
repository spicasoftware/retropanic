import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:retropanic/components/uiHelper.dart';

class About extends StatelessWidget{

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Expanded(
              flex: 5,
              child: Container(
                child: Image(
                  image: AssetImage('assets/images/spica_logo.png'),
                  fit: BoxFit.fill
                )
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: Text(
                'SPICA LABS',
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 40
                )
              )
            ),
            Spacer(),
            Expanded(
              flex: 1,
              child: Text(
                'Astrology + Design:',
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Text(
                  'Ada Pembroke',
                  style: TextStyle(
                    color: _textColor,
                    decoration: TextDecoration.underline
                  )
                ),
                onTap: () async {
                  if (await canLaunch("https://www.adapembroke.com/")) {
                    await launch("https://www.adapembroke.com/");
                  }
                }
              )
            ),
            Spacer(),
            Expanded(
              flex: 1,
              child: Text(
                'Code:',
                style: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Text(
                  'Shawn McMannis',
                  style: TextStyle(
                      color: _textColor,
                      decoration: TextDecoration.underline
                  )
                ),
                onTap: () async {
                  if (await canLaunch("https://github.com/skmcmannis")) {
                    await launch("https://github.com/skmcmannis");
                  }
                }
              )
            ),
            Spacer(),
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                  onTap: () async {
                    if (await canLaunch("https://discord.gg/VrxckpAujA")) {
                      await launch("https://discord.gg/VrxckpAujA");
                    }
                  },
                    child: Container(
                      child: Image(
                        image: AssetImage('assets/images/discord.png'),
                        fit: BoxFit.fill,
                      )
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      if (await canLaunch("https://instagram.com/spicalabs")) {
                        await launch("https://instagram.com/spicalabs");
                      }
                    },
                    child: Container(
                      child: Image(
                        image: AssetImage('assets/images/instagram.png'),
                        fit: BoxFit.fill,
                      )
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (await canLaunch("https://twitter.com/spicalabs")) {
                        await launch("https://twitter.com/spicalabs");
                      }
                    },
                    child: Container(
                      child: Image(
                        image: AssetImage('assets/images/twitter.png'),
                        fit: BoxFit.fill,
                      )
                    ),
                  ),
                ]
              )
            )
          ]
        )
      ),
    );
  }
}