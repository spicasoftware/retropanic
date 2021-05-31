import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:retropanic/components/timeHelper.dart';
import 'package:retropanic/main.dart';
import 'package:retropanic/models/notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('rp_not_icon');

  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });

  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectNotificationSubject.add(payload);
      });
}

/*
Future<void> showScheduledNotification(status) async {

  var statusString = mercuryStatus(status);

  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '1', 'Retropanic', 'Mercury Status',
    importance: Importance.max,
    priority: Priority.max,
    showWhen: false,
    playSound: true,
    ticker: 'ticker',
  );

  const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(0, 'Mercury is $statusString.', null , platformChannelSpecifics);
}
*/

Future<void> showScheduledNotification(status, difference) async {

  await _configureLocalTimeZone();

  var statusString = mercuryStatus(status);

  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '1', 'Retropanic', 'Mercury Status',
    importance: Importance.max,
    priority: Priority.max,
    showWhen: false,
    playSound: true,
    ticker: 'ticker',
  );

  const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(0, 'Mercury is $statusString.', null , tz.TZDateTime.now(tz.local).add(difference), platformChannelSpecifics, androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
}

Future<void> showOngoingNotification(status, nextChange) async {

  print('time: ' + nextChange.toString());

  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0', 'Retropanic', 'Mercury Status',
      importance: Importance.low,
      priority: Priority.max,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      playSound: false,
  );

  const platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

  var statusString = mercuryStatus(status);
  var days = dayDifference(nextChange);

  if (days == 1) {
    if (status) {
      await flutterLocalNotificationsPlugin.show(0, 'Mercury is $statusString.', 'Mercury retrograde ends in $days day.', platformChannelSpecifics);
    } else {
      await flutterLocalNotificationsPlugin.show(0, 'Mercury is $statusString.', 'Mercury retrograde begins in $days day.', platformChannelSpecifics);
    }
  } else if (days == 0) {
    if (status) {
      await flutterLocalNotificationsPlugin.show(0, 'Mercury is $statusString.', 'Mercury retrograde ends in less than one day.', platformChannelSpecifics);
    } else {
      await flutterLocalNotificationsPlugin.show(0, 'Mercury is $statusString.', 'Mercury retrograde begins in less than one day.', platformChannelSpecifics);
    }
  } else {
    if (status) {
      await flutterLocalNotificationsPlugin.show(0, 'Mercury is $statusString.', 'Mercury retrograde ends in $days days.', platformChannelSpecifics);
    } else {
      await flutterLocalNotificationsPlugin.show(0, 'Mercury is $statusString.', 'Mercury retrograde begins in $days days.', platformChannelSpecifics);
    }
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}