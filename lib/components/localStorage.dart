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
  var _differenceNow = _nextChange.difference(_currTime);
  var _differenceDay = _nextChange.difference(_currTime.add(new Duration(days: 1)));
  var _differenceWeek = _nextChange.difference(_currTime.add(new Duration(days: 7)));
  var _timer = new Duration(minutes: 15);
  var _interval = new Duration(minutes: 2);

  if (notificationToggle) {

    await Workmanager.cancelAll();

    cancelAllNotifications();

    showOngoingNotification(_status, _nextChange);

    //Pop-up one week ahead
    if (_differenceWeek <= _timer && !_differenceWeek.isNegative) {
      await showScheduledNotificationWeek(!_status, _differenceWeek);
      await Future.delayed(_differenceWeek + _interval);
      showOngoingNotification(_status, _nextChange);
    }

    //Pop-up one day ahead
    if (_differenceDay <= _timer && !_differenceDay.isNegative) {
      await showScheduledNotificationDay(!_status, _differenceDay);
      await Future.delayed(_differenceDay + _interval);
      showOngoingNotification(_status, _nextChange);
    }

    //Pop-up at time of change
    if (_differenceNow <= _timer) {
      await showScheduledNotificationNow(!_status, _differenceNow);
      await Future.delayed(_differenceNow + _interval);
      showOngoingNotification(_status, _nextChange);
    }
  }
  else
  {
    cancelOngoingNotification();

    //Pop-up one week ahead
    if (_differenceWeek <= _timer && !_differenceWeek.isNegative) {
      await showScheduledNotificationWeek(!_status, _differenceWeek);
    }

    //Pop-up one day ahead
    if (_differenceDay <= _timer && !_differenceDay.isNegative) {
      await showScheduledNotificationDay(!_status, _differenceDay);
    }

    //Pop-up at time of change
    if (_differenceNow <= _timer) {
      await showScheduledNotificationNow(!_status, _differenceNow);
    }
  }
}