import 'package:ephemeris/ephemeris.dart';

void ffiInit() {
  init();
}

bool ffiCurrentStatus() {
  final now = new DateTime.now().toUtc();
  print('Using time: ${now}');
  final pi = getPlanetInfo(
      SE_MERCURY, now.year, now.month, now.day, now.hour + now.minute / 60);
  //final pi = getPlanetInfo(SE_MERCURY, 2021, 1, 30, 7 + 51/60 + 8);  <-- stationing retrograde
  print('${pi.position.longitude}, ${pi.position.latitude}, ${pi.position
      .distance} / ${pi.speed.longitude}, ${pi.speed.latitude}, ${pi.speed
      .distance}');

  return pi.speed.longitude < 0;
}

DateTime ffiNextMercuryChange() {
  var _currTime = new DateTime.now().toUtc();
  return findSituation(_currTime, _currTime.add(new Duration(days: 365)), (DateTime when, double stepHours) {
    final cur = getPlanetInfo(SE_MERCURY, when.year, when.month, when.day, when.hour + when.minute / 60);
    final future = getPlanetInfo(SE_MERCURY, when.year, when.month, when.day, when.hour + stepHours + (when.minute / 60));

    return cur.speed.longitude.sign != future.speed.longitude.sign;
  }).toLocal();
}

double ffiMercuryFullDegree() {
  final now = new DateTime.now().toUtc();
  final pi = getPlanetInfo(
      SE_MERCURY, now.year, now.month, now.day, now.hour + now.minute / 60);

  return pi.position.longitude;
}

int ffiMercurySignDegree() {
  return (ffiMercuryFullDegree() % 30).floor();
}

String ffiMercurySign() {
  final signs = ['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'];
  final String currSign = signs[(ffiMercuryFullDegree() / 30).floor()];

  return currSign;
}