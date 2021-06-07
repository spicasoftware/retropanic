import 'package:retropanic/main.dart';
import 'package:retropanic/components/ffi.dart';
import 'package:retropanic/components/notificationHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void read() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'rp_notifications';
  notificationToggle = prefs.getBool(key) ?? true;
}

void save(value) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'rp_notifications';
  prefs.setBool(key, value);

  if (notificationToggle) {

    var _status = ffiCurrentStatus();
    var _nextChange = ffiNextMercuryChange();
    var _currTime = new DateTime.now();
    var _difference = _nextChange.difference(_currTime);
    var _timer = new Duration(minutes: 15);
    var _interval = new Duration(minutes: 2);

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
    cancelAllNotifications();
  }
}