import 'package:flutter/material.dart';

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