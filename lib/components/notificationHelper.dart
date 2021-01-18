import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:retropanic/components/timeHelper.dart';
import 'package:retropanic/main.dart';
import 'package:retropanic/models/notifications.dart';
import 'package:rxdart/subjects.dart';

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

  final InitializationSettings initializationSettings = InitializationSettings(initializationSettingsAndroid,
      initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectNotificationSubject.add(payload);
      });
}

Future<void> showScheduledNotification(status) async {
  const iconColor = Color(0xFFF46F01);

  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '1', 'Retropanic', 'Mercury Status',
    importance: Importance.Max,
    priority: Priority.Max,
    showWhen: false,
    playSound: true,
    color: iconColor,
    ticker: 'ticker',
  );

  const platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, null);

  await flutterLocalNotificationsPlugin.show(0, 'Mercury is $status.', null , platformChannelSpecifics);
}

Future<void> showOngoingNotification(status, nextChange) async {
  const iconColor = Color(0xFFF46F01);

  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0', 'Retropanic', 'Mercury Status',
      importance: Importance.Low,
      priority: Priority.Max,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      playSound: false,
      color: iconColor,
  );

  const platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, null);

  var statusString = mercuryStatus(status);
  var days = dayDifference(nextChange);

  if (status) {
    await flutterLocalNotificationsPlugin.show(0, 'Mercury is $statusString.', 'Mercury retrograde ends in $days days.', platformChannelSpecifics);
  } else {
    await flutterLocalNotificationsPlugin.show(0, 'Mercury is $statusString.', 'Mercury retrograde begins in $days days.', platformChannelSpecifics);
  }
}