import 'dart:ffi'; // For FFI
import 'dart:io'; // For Platform.isX
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';

final DynamicLibrary ephemerisLib = Platform.isAndroid
    ? DynamicLibrary.open("libephemeris.so")
    : DynamicLibrary.process();

final void Function() init =
ephemerisLib
    .lookup<NativeFunction<Void Function()>>("init")
    .asFunction();

class PlanetInfoFFI extends Struct {
  @Double()
  double position_longitude;

  @Double()
  double position_latitude;

  @Double()
  double position_distance;

  @Double()
  double speed_longitude;

  @Double()
  double speed_latitude;

  @Double()
  double speed_distance;

  @Int32()
  int returnFlag;

  Pointer<Int8> serr;
}

class SkyPoint {
  double longitude;
  double latitude;
  double distance;
}

class PlanetInfo {
  SkyPoint position;
  SkyPoint speed;
  int returnCode;
  String errorString;
}

// see also MERCURY in ephemeris.c (it can't be called SE_MERCURY there because that will clash with Swisseph's own constant
// to add more planets, just follow this pattern here and in ephemeris.c
final SE_MERCURY = ephemerisLib.lookup<Int32>("MERCURY").value;

// nice-looking but doesn't compile:
// typedef piFunc = Pointer<PlanetInfo> Function(int planet, int year, int month, int day, double hour);
// final planetInfoToo = ephemerisLib.lookupFunction("planetInfo") as piFunc;

// have to use dart primitives in the actual definition because apparently Int32 et. al. aren't subtypes of themselves????
final Pointer<PlanetInfoFFI> Function(int planet, int year, int month, int day, double hour) planetInfoFunc =
ephemerisLib
    .lookup<NativeFunction<Pointer<PlanetInfoFFI> Function(Int32, Int32, Int32, Int32, Double)>>("planetInfo")
    .asFunction();

// this wrapper is important to get the results copied out of the static C-side
// result holder ASAP.
PlanetInfo getPlanetInfo(int planet, int year, int month, int day, double hour) {
  PlanetInfoFFI pi = planetInfoFunc(planet, year, month, day, hour).ref;
  PlanetInfo ret = new PlanetInfo();
  ret.position = new SkyPoint();
  ret.speed = new SkyPoint();
  ret.position.longitude = pi.position_longitude;
  ret.position.latitude = pi.position_latitude;
  ret.position.distance = pi.position_distance;
  ret.speed.longitude = pi.speed_longitude;
  ret.speed.latitude = pi.speed_latitude;
  ret.speed.distance = pi.speed_distance;
  ret.returnCode = pi.returnFlag;
  //TODO ret.errorString = pi.serr;

  return ret;
}

// this is basically a bastardized radix search, hacked around the idea that we can only know if our requested aspect is "close enough" at a given time.
// Efficiency is heavily dependent on the "magic numbers" chosen (initialStepHours, resolution, and whatever calculation the `found` function does to
// convert a steps size into an epsilon value internally. Fiddle with them if issues occur.
DateTime findSituation(DateTime start, DateTime end, bool found(DateTime when, double stepHours), {double initialStepHours=24, double resolution=1/60}) {
  DateTime hour2Date(double hour) {
    return DateTime.fromMillisecondsSinceEpoch((hour*1000*60*60).round(), isUtc: true);
  }

  double findIt(double lo, double hi, bool found(DateTime when, double stepHours), double step) {
    for (var i = lo; i < hi; i += step) {
      if(found(hour2Date(i), step)) {
        if(step > resolution) {
          final subFound = findIt(i-step, i+step, found, step/2);
          if(subFound != null) return subFound;
        }
        else return i;
      }
    }

    return null;
  }

  final ret = hour2Date(findIt(start.millisecondsSinceEpoch/1000/60/60, end.millisecondsSinceEpoch/1000/60/60, found, initialStepHours));
  print('final: ${ret}');
  return ret;
}

class Ephemeris {
  static const MethodChannel _channel =
      const MethodChannel('ephemeris');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');

    return version;
  }
}
