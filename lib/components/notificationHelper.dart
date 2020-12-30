import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:retropanic/main.dart';
import 'package:rxdart/subjects.dart';
import '../models/notifications.dart';

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('placeholder');

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

Future<void> showNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails('0', 'Retropanic', 'Mercury Status',
    importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'Retropanic title', 'plain body', platformChannelSpecifics,
    payload: 'item x');
}

Future<void> scheduleNotification(
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  String id,
  String body,
  DateTime scheduledNotificationDateTime) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(id, 'Retropanic', 'Mercury Status', icon: 'placeholder',);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(0, 'Retropanic title', body, scheduledNotificationDateTime, platformChannelSpecifics);
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

  await flutterLocalNotificationsPlugin.show(0, 'Mercury currently: $status', 'Next change: $nextChange', platformChannelSpecifics);
}