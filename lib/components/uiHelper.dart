import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:retropanic/components/ffi.dart';

bool isDarkMode () {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  return brightness == Brightness.dark;
}

String mainUIIcon (status, isDarkMode) {
  if (status && !isDarkMode) {
    return 'assets/images/rp_retro_light.png';
  } else if (status && isDarkMode){
    return 'assets/images/rp_retro_dark.png';
  } else if (!status && !isDarkMode) {
    return 'assets/images/rp_direct_light.png';
  } else {
    return 'assets/images/rp_direct_dark.png';
  }
}

String statusText (status) {
  if (status) {
    return 'Mercury is retrograde';
  } else {
    return 'Mercury is not retrograde';
  }
}

String statusSubText (status) {
  if (status) {
    return 'Ends';
  } else {
    return 'Begins';
  }
}

Color mainUITextColor (isDarkMode) {
  print('Next ${ffiNextMercuryChange()}');
  print('Countdown ${ffiNextMercuryChange().millisecondsSinceEpoch + 1000 * 30}');
  print('Current ${DateTime.now().millisecondsSinceEpoch + 1000 * 30}');
  if (!isDarkMode) {
    return Colors.black;
  } else {
    return Color(0xFFFBF8C6);
  }
}

Color mainUIBackgroundColor (isDarkMode) {
  if (!isDarkMode) {
    return Color(0xFFFBF8C6);
  } else {
    return Colors.black;
  }
}