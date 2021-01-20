import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

bool isDarkMode () {
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  return brightness == Brightness.dark;
}

String mainUIIcon (status) {
  if (status && !isDarkMode()) {
    return 'assets/images/rp_retro_light.png';
  } else if (status && isDarkMode()){
    return 'assets/images/rp_retro_dark.png';
  } else if (!status && !isDarkMode()) {
    return 'assets/images/rp_direct_light.png';
  } else {
    return 'assets/images/rp_direct_dark.png';
  }
}

String mainUIText (status) {
  if (status) {
    return 'OMG PANIC!';
  } else {
    return 'Chill, man...';
  }
}

Color mainUITextColor (status) {
  if (status) {
    return Color(0xFFFFD80C);
  } else {
    return Color(0xFFF46F01);
  }
}

Color mainUIBackgroundColor (status) {
  if (status) {
    return Color(0xFF060606);
  } else {
    return Color(0xFFFBF8C6);
  }
}