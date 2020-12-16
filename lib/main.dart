import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:retropanic/components/notificationHelper.dart';
import 'package:workmanager/workmanager.dart';
import './app.dart';
import './components/ffi.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {

    var _currTime = new DateTime.now();
    var _nextNotification = _currTime.add(new Duration(seconds: 15));

    scheduleNotification(flutterLocalNotificationsPlugin, '0', '$inputData', _nextNotification);

    Workmanager.registerOneOffTask(
      "2", "Test task 2", inputData: <String, dynamic>{
      'bool': ffiTest(),
    },
      initialDelay: Duration(seconds: 15),
    );

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);

  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);

  runApp(MyApp());
}