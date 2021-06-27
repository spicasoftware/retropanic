import 'package:retropanic/main.dart';
import 'package:retropanic/components/ffi.dart';
import 'package:retropanic/components/notificationHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

Future<void> read() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'rp_notifications';
  notificationToggle = prefs.getBool(key) ?? true;
  print('Value: ' +  notificationToggle.toString());
}

void save(value) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'rp_notifications';
  prefs.setBool(key, value);

  var _status = ffiCurrentStatus();
  var _nextChange = ffiNextMercuryChange();
  var _currTime = new DateTime.now();
  var _difference = _nextChange.difference(_currTime);
  var _timer = new Duration(minutes: 15);
  var _interval = new Duration(minutes: 2);

  if (notificationToggle) {

    await Workmanager.cancelAll();

    cancelAllNotifications();

    showOngoingNotification(_status, _nextChange);

    if (_difference <= _timer) {
      await showScheduledNotification(!_status, _difference);
      await Future.delayed(_difference + _interval);
      showOngoingNotification(_status, _nextChange);
    }
  }
  else
  {
    cancelOngoingNotification();
    await showScheduledNotification(!_status, _difference);
  }
}