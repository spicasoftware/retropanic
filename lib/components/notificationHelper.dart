import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  print('In showNotification');
  var androidPlatformChannelSpecifics = AndroidNotificationDetails('0', 'Retropanic', 'Mercury Status',
    importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'Retropanic title', 'plain body', platformChannelSpecifics,
    payload: 'item x');
}