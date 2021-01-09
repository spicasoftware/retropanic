import 'package:flutter/material.dart';
import './screens/home.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: MainUI(title: 'RetroPanic'),
    );
  }
}

