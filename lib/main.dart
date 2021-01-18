import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:retropanic/components/ffi.dart';
import 'package:retropanic/components/notificationHelper.dart';
import 'package:workmanager/workmanager.dart';
import './app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

Future<void> _cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    var _status = ffiCurrentStatus();
    var _nextChange = ffiNextMercuryChange();
    var _currTime = new DateTime.now();
    var _difference = _nextChange.difference(_currTime);

    showOngoingNotification(_status, _nextChange);
    if (_difference.inHours <= 12) {
      await Future.delayed(_difference, () {});
      showScheduledNotification(_status);
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
  _cancelAllNotifications();

  //Cancel any existing tasks
  await Workmanager.cancelAll();

  runApp(MyApp());
}