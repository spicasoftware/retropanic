import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:retropanic/screens/edCard5.dart';
import 'package:retropanic/screens/home.dart';

class EdCard4Route extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SwipeGestureRecognizer(
          onSwipeUp: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EdCard5Route())
            );
          },
          onSwipeDown: () {
            Navigator.pop(context);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .95,
                width: MediaQuery.of(context).size.width,
                child: Image(
                  image: AssetImage('assets/images/edCard4.png'),
                  fit: BoxFit.fill
                )
              ),
              Container(
                height: MediaQuery.of(context).size.height * .05,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment(0.4, 0.0),
                        child: IconButton(
                          icon: Image.asset('assets/images/returnToTop.png'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainUI())
                            );
                          }
                        )
                      )
                    ),
                    Expanded(
                      child: Text(
                        '(4/6)',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white
                        )
                      ),
                    )
                  ]
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}