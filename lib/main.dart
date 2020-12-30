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

    var _status;
    var _nextChange;

    //Cancel any previous scheduled notifications
    _cancelAllNotifications();

    //Generate a notification every minute
    while(true) {
      print("Registering notification");
      _status = ffiCurrentStatus();
      _nextChange = ffiNextChange();
      showOngoingNotification(_status, _nextChange);
      await Future.delayed(const Duration(minutes: 1), () {});
    }

    //return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);

  Workmanager.initialize(callbackDispatcher);

  //Cancel any existing tasks
  await Workmanager.cancelAll();

  runApp(MyApp());
}