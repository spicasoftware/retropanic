import 'dart:math';
import 'package:ephemeris/ephemeris.dart';

void ffiInit() {
  init();
}

bool ffiCurrentStatus() {
  final now = new DateTime.now().toUtc();
  print('Using time: ${now}');
  final pi = getPlanetInfo(SE_MERCURY, now.year, now.month, now.day, now.hour + now.minute/60);
  //final pi = getPlanetInfo(SE_MERCURY, 2021, 1, 30, 7 + 51/60 + 8);  <-- stationing retrograde
  print('${pi.position.longitude}, ${pi.position.latitude}, ${pi.position.distance} / ${pi.speed.longitude}, ${pi.speed.latitude}, ${pi.speed.distance}');

  return pi.speed.longitude < 0;

  //Generate random number between 1 and 10
  var rng = new Random();
  var rand = rng.nextInt(10);
  print(rand);

  //Use the modulus of the random number to generate a random bool
  var preStatus = rand % 2;
  print(preStatus);

  //Return the bool
  if(preStatus == 1) {
    return true;
  } else {
    return false;
  }
}

DateTime ffiNextChange() {
  var _currTime = new DateTime.now();
  return _currTime.add(new Duration(minutes: 1));
}