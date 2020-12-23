import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:retropanic/components/ffi.dart';
import 'package:retropanic/components/notificationHelper.dart';
import 'package:workmanager/workmanager.dart';
import './app.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
NotificationAppLaunchDetails notificationAppLaunchDetails;

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {

    var status;
    var nextChange;

    while(true) {
      print("Registering notification");
      status = ffiCurrentStatus();
      nextChange = ffiNextChange();
      showOngoingNotification(status, nextChange);
      await Future.delayed(const Duration(minutes: 1), () {});
    }

/*    var _currTime = new DateTime.now();
    print(_currTime);
    var _nextValue = !ffiCurrentStatus();
    print(_nextValue);
    var _nextChange = ffiNextChange();
    print(_nextChange);

    if(_nextChange.isBefore(_currTime.add(new Duration(minutes: 15)))) {
      scheduleNotification(flutterLocalNotificationsPlugin, '0', '$_nextValue', _nextChange);
    }*/

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  await initNotifications(flutterLocalNotificationsPlugin);

  Workmanager.initialize(callbackDispatcher);

  runApp(MyApp());
}