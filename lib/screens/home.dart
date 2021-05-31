import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';
import 'package:retropanic/screens/about.dart';
import 'package:retropanic/screens/license.dart';
import 'package:retropanic/components/uiHelper.dart';
import 'package:retropanic/components/ffi.dart';
import 'package:retropanic/screens/edCard1.dart';


class MainUI extends StatefulWidget {
  MainUI({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainUIState createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  static bool _status = ffiCurrentStatus();
  static bool _isDarkMode = isDarkMode();
  Timer _timer;
  String _statusText = statusText(_status);
  String _statusSubText = statusSubText(_status);
  int _countdown = ffiNextMercuryChange().millisecondsSinceEpoch + 1000 * 30;
  Color _textColor = mainUITextColor(_isDarkMode);
  Color _backgroundColor = mainUIBackgroundColor(_isDarkMode);
  String _uiIcon = mainUIIcon(_status, _isDarkMode);
  String _sign = ffiMercurySign();
  int _degree = ffiMercurySignDegree();

  //Initialize timer to periodically update state
  @override
  void initState() {
    super.initState();

    ffiInit();
    Workmanager.registerPeriodicTask(
        "1", "Retropanic ongoing notification", frequency: Duration(minutes: 15));

    setState(() {
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        setState(() {
          _status = ffiCurrentStatus();
          _countdown = ffiNextMercuryChange().millisecondsSinceEpoch + 1000 * 30;
          _isDarkMode = isDarkMode();
          _uiIcon = mainUIIcon(_status, _isDarkMode);
          _statusText = statusText(_status);
          _statusSubText = statusSubText(_status);
          _textColor = mainUITextColor(_isDarkMode);
          _backgroundColor = mainUIBackgroundColor(_isDarkMode);
          _sign = ffiMercurySign();
          _degree = ffiMercurySignDegree();
        });
      });
    });
  }

    @override
    void dispose() {
      _timer?.cancel();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: _backgroundColor
          ),
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Retropanic', style: TextStyle(
                    color: _textColor
                  )),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                  )
                ),
                ListTile(
                  title: Text('About', style: TextStyle(
                    color: _textColor
                  )),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) => About()
                    ));
                  }
                ),
                ListTile(
                  title: Text('Rate Us!', style: TextStyle(
                    color: _textColor
                  )),
                  onTap: () async {
                    if (await canLaunch("http://www.google.com")) {
                      await launch("http://www.google.com");
                    }
                  }
                ),
                ListTile(
                  title: Text('License', style: TextStyle(
                    color: _textColor
                  )),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) => License()
                    ));
                  }
                )
              ]
            ),
          ),
        ),
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title: Text('Retropanic', style: TextStyle(
            color: _textColor
          )),
          iconTheme: IconThemeData(color: _textColor),
          backgroundColor: _backgroundColor,
        ),
        body: Center(
          child: SwipeGestureRecognizer(
            onSwipeUp: () {
              if(_status) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EdCard1Route())
                );
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Expanded(
                  flex: 24,
                  child: Image(
                    image: AssetImage(_uiIcon)
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 8,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      'MERCURY',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bebasNeue(
                        textStyle: TextStyle(
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      _statusText,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bebasNeue(
                          textStyle: TextStyle(
                            color: _textColor,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child:
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        '$_degree\u00B0 $_sign',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: _textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                ),
                Spacer(
                  flex: 3
                ),
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: CountdownTimer(
                      endTime: _countdown,
                      widgetBuilder: (_, CurrentRemainingTime time) {
                        if (time.days == null && time.hours == null && time.min == null) {
                          return Text(
                            '$_statusSubText\nLess than 1 minute',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else if (time.days == null && time.hours == null && time.min != null) {
                          return Text(
                            '$_statusSubText\n${time.min} minutes',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else if (time.days == null && time.hours != null && time.min == null) {
                          return Text(
                            '$_statusSubText\n${time.hours} hours',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else if (time.days != null && time.hours == null && time.min == null) {
                          return Text(
                            '$_statusSubText\n${time.days} days',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else if (time.days != null && time.hours != null && time.min == null) {
                          return Text(
                            '$_statusSubText\n${time.days} days, ${time.hours} hours',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else if (time.days != null && time.hours == null && time.min != null) {
                          return Text(
                            '$_statusSubText\n${time.days} days, ${time.min} minutes',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        } else if (time.days == null && time.hours != null && time.min != null) {
                          return Text(
                            '$_statusSubText\n${time.hours} hours, ${time.min} minutes',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: _textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return Text(
                          '$_statusSubText\n${time.days} days, ${time.hours} hours, ${time.min} minutes',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: _textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    )
                  )
                ),
                Spacer()
              ]
            ),
          ),
        ),
      );
    }
}