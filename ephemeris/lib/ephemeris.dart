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

// see https://www.astro.com/swisseph/swephprg.htm#_Toc58481315 for documentation of what these represent
final SE_ECL_NUT = ephemerisLib.lookup<Int32>("ECL_NUT").value;
final SE_SUN = ephemerisLib.lookup<Int32>("SUN").value;
final SE_MOON = ephemerisLib.lookup<Int32>("MOON").value;
final SE_MERCURY = ephemerisLib.lookup<Int32>("MERCURY").value;
final SE_VENUS = ephemerisLib.lookup<Int32>("VENUS").value;
final SE_MARS = ephemerisLib.lookup<Int32>("MARS").value;
final SE_JUPITER = ephemerisLib.lookup<Int32>("JUPITER").value;
final SE_SATURN = ephemerisLib.lookup<Int32>("SATURN").value;
final SE_URANUS = ephemerisLib.lookup<Int32>("URANUS").value;
final SE_NEPTUNE = ephemerisLib.lookup<Int32>("NEPTUNE").value;
final SE_PLUTO = ephemerisLib.lookup<Int32>("PLUTO").value;
final SE_MEAN_NODE = ephemerisLib.lookup<Int32>("MEAN_NODE").value;
final SE_TRUE_NODE = ephemerisLib.lookup<Int32>("TRUE_NODE").value;
final SE_MEAN_APOG = ephemerisLib.lookup<Int32>("MEAN_APOG").value;
final SE_OSCU_APOG = ephemerisLib.lookup<Int32>("OSCU_APOG").value;
final SE_EARTH = ephemerisLib.lookup<Int32>("EARTH").value;
final SE_CHIRON = ephemerisLib.lookup<Int32>("CHIRON").value;
final SE_PHOLUS = ephemerisLib.lookup<Int32>("PHOLUS").value;
final SE_CERES = ephemerisLib.lookup<Int32>("CERES").value;
final SE_PALLAS = ephemerisLib.lookup<Int32>("PALLAS").value;
final SE_JUNO = ephemerisLib.lookup<Int32>("JUNO").value;
final SE_VESTA = ephemerisLib.lookup<Int32>("VESTA").value;
final SE_INTP_APOG = ephemerisLib.lookup<Int32>("INTP_APOG").value;
final SE_INTP_PERG = ephemerisLib.lookup<Int32>("INTP_PERG").value;
final SE_NPLANETS = ephemerisLib.lookup<Int32>("NPLANETS").value;
final SE_FICT_OFFSET = ephemerisLib.lookup<Int32>("FICT_OFFSET").value;
final SE_NFICT_ELEM = ephemerisLib.lookup<Int32>("NFICT_ELEM").value;
final SE_PLMOON_OFFSET = ephemerisLib.lookup<Int32>("PLMOON_OFFSET").value;
final SE_AST_OFFSET = ephemerisLib.lookup<Int32>("AST_OFFSET").value;

/* Hamburger or Uranian "planets" */
final SE_CUPIDO = ephemerisLib.lookup<Int32>("CUPIDO").value;
final SE_HADES = ephemerisLib.lookup<Int32>("HADES").value;
final SE_ZEUS = ephemerisLib.lookup<Int32>("ZEUS").value;
final SE_KRONOS = ephemerisLib.lookup<Int32>("KRONOS").value;
final SE_APOLLON = ephemerisLib.lookup<Int32>("APOLLON").value;
final SE_ADMETOS = ephemerisLib.lookup<Int32>("ADMETOS").value;
final SE_VULKANUS = ephemerisLib.lookup<Int32>("VULKANUS").value;
final SE_POSEIDON = ephemerisLib.lookup<Int32>("POSEIDON").value;

/* other fictitious bodies */
final SE_ISIS = ephemerisLib.lookup<Int32>("ISIS").value;
final SE_NIBIRU = ephemerisLib.lookup<Int32>("NIBIRU").value;
final SE_HARRINGTON = ephemerisLib.lookup<Int32>("HARRINGTON").value;
final SE_NEPTUNE_LEVERRIER = ephemerisLib.lookup<Int32>("NEPTUNE_LEVERRIER").value;
final SE_NEPTUNE_ADAMS = ephemerisLib.lookup<Int32>("NEPTUNE_ADAMS").value;
final SE_PLUTO_LOWELL = ephemerisLib.lookup<Int32>("PLUTO_LOWELL").value;
final SE_PLUTO_PICKERING = ephemerisLib.lookup<Int32>("PLUTO_PICKERING").value;

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
          final subFound = findIt(i, i+step, found, step/2);
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
