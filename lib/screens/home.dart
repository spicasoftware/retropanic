import 'package:flutter/material.dart';
import 'dart:async';
import '../components/ffi.dart';
import '../components/notificationHelper.dart';
import '../main.dart';
import 'package:ephemeris/ephemeris.dart';

/////////// Hax? Just put the FFI stuff in here for now ?//////////////
// import 'dart:ffi'; // For FFI
// import 'dart:io'; // For Platform.isX
//
// final DynamicLibrary nativeAddLib = Platform.isAndroid
//     ? DynamicLibrary.open("libephemeris.so")
//     : DynamicLibrary.process();
//
// final int Function(int x, int y) nativeAdd =
// nativeAddLib
//     .lookup<NativeFunction<Int32 Function(Int32, Int32)>>("native_add")
//     .asFunction();
//
// final void Function() init =
// nativeAddLib
//     .lookup<NativeFunction<Void Function()>>("init")
//     .asFunction();
//////////////////////////////////////////////////////////////////////

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  bool _newStatus;
  bool _status = ffiTest();
  Timer _timer;
  var _currTime;
  var _nextNotification;

  //Initialize timer to call ffiTest every 15 seconds
  @override
  void initState() {
    init();
    _timer = Timer.periodic(Duration(seconds: 15), (Timer t) {
      setState(() {
        _newStatus = ffiTest();
        if (_newStatus != _status) {
          _status = _newStatus;
          _currTime = new DateTime.now();
          _nextNotification = _currTime.add(new Duration(seconds: 15));
          scheduleNotification(flutterLocalNotificationsPlugin, '0', '$_status', _nextNotification);
        }
        _counter++;
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
    final now = new DateTime.now();

    final pi = getPlanetInfo(SE_MERCURY, now.year, now.month, now.day, now.hour + now.minute/60);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Mercury position: ${pi.position.rightAsc}, ${pi.position.dec}, ${pi.position.distance}'),
            Text('Mercury speed: ${pi.speed.rightAsc}, ${pi.speed.dec}, ${pi.speed.distance}'),
            Text('PANIC?????: ${pi.speed.rightAsc < 0 ? 'YES PANIC' : 'NO DON\'T PANIC'}'),
            Text(
              'This many intervals have passed:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_status'
            )
          ],
        ),
      ),
      //floatingActionButton: FloatingActionButton(
        //onPressed: _incrementCounter,
        //tooltip: 'Increment',
        //child: Icon(Icons.add),
      ); // This trailing comma makes auto-formatting nicer for build methods.
    //);
  }
}