import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:retropanic/components/ffi.dart';
import 'package:retropanic/components/localStorage.dart';
import 'package:retropanic/components/notificationHelper.dart';
import 'package:workmanager/workmanager.dart';
import './app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

bool notificationToggle = true;

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    var _status = ffiCurrentStatus();
    var _nextChange = ffiNextMercuryChange();
    var _currTime = new DateTime.now();
    var _difference = _nextChange.difference(_currTime);
    var _timer = new Duration(minutes: 15);
    var _interval = new Duration(minutes: 2);

    showOngoingNotification(_status, _nextChange);

    if (_difference <= _timer) {
      await showScheduledNotification(!_status, _difference);
      await Future.delayed(_difference + _interval);
      showOngoingNotification(_status, _nextChange);
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);

  Workmanager.initialize(callbackDispatcher);

  //Cancel any existing notifications
  cancelAllNotifications();

  //Cancel any existing tasks
  await Workmanager.cancelAll();

  //Lock in Portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((value) => runApp(MyApp()));

  //Read notification toggle setting
  read();
}