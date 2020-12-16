
import 'dart:async';

import 'package:flutter/services.dart';

class Ephemeris {
  static const MethodChannel _channel =
      const MethodChannel('ephemeris');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
