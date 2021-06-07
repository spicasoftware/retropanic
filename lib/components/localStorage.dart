import 'package:retropanic/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

void read() async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'rp_notifications';
  notificationToggle = prefs.getBool(key) ?? false;

  if (notificationToggle) {
    await Workmanager.cancelAll();

    cancelAllNotifications();

    Workmanager.registerPeriodicTask(
        "1", "Retropanic ongoing notification",
        frequency: Duration(minutes: 15));
  }
}

void save(value) async {
  final prefs = await SharedPreferences.getInstance();
  final key = 'rp_notifications';
  prefs.setBool(key, value);
}