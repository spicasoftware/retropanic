import 'package:flutter/material.dart';
import 'package:swipe_gesture_recognizer/swipe_gesture_recognizer.dart';
import 'package:retropanic/screens/edCard2.dart';

class EdCard1Route extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SwipeGestureRecognizer(
          onSwipeUp: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EdCard2Route())
            );
          },
          onSwipeDown: () {
            Navigator.pop(context);
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image(
              image: AssetImage('assets/images/edCard1.png'),
              fit: BoxFit.fill
            )
          )
        )
      )
    );
  }
}