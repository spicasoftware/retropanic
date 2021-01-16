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
    var _nextChange = ffiNextChange();
    var _currTime = new DateTime.now();
    var _difference = _nextChange.difference(_currTime);

    print("TASK: $taskName");

    showOngoingNotification(_status, _nextChange);
    if (_difference >= const Duration(seconds: 30)) {
      await Future.delayed(_difference, () {});
      showScheduledNotification(_status, _nextChange);

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