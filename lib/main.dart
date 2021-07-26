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
    var _differenceNow = _nextChange.difference(_currTime);
    var _differenceDay = _nextChange.difference(_currTime.add(new Duration(days: 1)));
    var _differenceWeek = _nextChange.difference(_currTime.add(new Duration(days: 7)));
    var _timer = new Duration(minutes: 15);
    var _interval = new Duration(minutes: 2);

    await read();

    if (notificationToggle) {
      showOngoingNotification(_status, _nextChange);
    }

    //Pop-up one week ahead
    if (_differenceWeek <= _timer && !_differenceWeek.isNegative) {
      await showScheduledNotificationWeek(!_status, _differenceWeek);
      await Future.delayed(_differenceWeek + _interval);
      if (notificationToggle) {
        showOngoingNotification(_status, _nextChange);
      }
    }

    //Pop-up one day ahead
    if (_differenceDay <= _timer && !_differenceDay.isNegative) {
      await showScheduledNotificationDay(!_status, _differenceDay);
      await Future.delayed(_differenceDay + _interval);
      if (notificationToggle) {
        showOngoingNotification(_status, _nextChange);
      }
    }


    //Pop-up at time of change
    if (_differenceNow <= _timer) {
      await showScheduledNotificationNow(!_status, _differenceNow);
      await Future.delayed(_differenceNow + _interval);
      if (notificationToggle) {
        showOngoingNotification(_status, _nextChange);
      }
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

  //Read notification toggle setting
  await read();

  //Lock in Portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((value) => runApp(MyApp()));
}