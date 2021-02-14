import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
    return 'RETROGRADE';
  } else {
    return 'NOT RETROGRADE';
  }
}

String statusSubText (status) {
  if (status) {
    return 'ENDS';
  } else {
    return 'BEGINS';
  }
}

Color mainUITextColor (isDarkMode) {
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