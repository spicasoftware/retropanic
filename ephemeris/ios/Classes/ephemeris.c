#include <stdint.h>
#include "swisseph/src/swephexp.h"

__attribute__((visibility("default"))) __attribute__((used))
int MERCURY = SE_MERCURY;

__attribute__((visibility("default"))) __attribute__((used))
void init() {
    swe_set_ephe_path(NULL);
}

/**
 * Warning: it's not clear from the swisseph documentation how this function actually interacts with UTC.
 * If you're in here looking for why house cusps and things are wrong, this is probably the culprit.
 */
__attribute__((visibility("default"))) __attribute__((used))
double getJulianDay(int year, int month, int day, double hour) {
    double tjd_ut = swe_julday(year, month, day, hour, SE_GREG_CAL);
    return tjd_ut; // + swe_deltat(tjd_ut); not necessary, we're using swe_calc_ut
}

// Dart FFI can't nest structs. This is why we can't have nice things.
typedef struct {
    double position_longitude;
    double position_latitude;
    double position_distance;
    double speed_longitude;
    double speed_latitude;
    double speed_distance;
    long returnFlag;
    char *errorString;
} planetResult_t;

/**
 * WARNING: THIS! IS! NOT! THREAD! SAFE!
 * Because of how Dart does threading this should be okay as long as in the Dart
 * code you copy your results out of the planetResult struct before calling planetInfo
 * again. This *should* be handled in the Dart wrapper, but this comment is your last
 * warning just in case that gets routed around somehow.
 *
 * The way this ultimately *should* work is to replicate the way
 * https://github.com/dart-lang/samples/blob/master/ffi/structs/structs.dart
 * handles allocations and deletions, but doing it this way cuts a bunch of time off
 * getting a functional RetroPanic MVP out the door.
 */
char serr[AS_MAXCH];
planetResult_t planetResult;

__attribute__((visibility("default"))) __attribute__((used))
planetResult_t* planetInfo(int planet, int year, int month, int day, double hour) {
    double planetParams[6];

    double julianDay = getJulianDay(year, month, day, hour);

    planetResult.returnFlag = swe_calc_ut(julianDay, planet, SEFLG_SPEED, planetParams, serr);
    planetResult.errorString = serr;

    // if there is a problem, a negative value is returned and an error message is in serr.
    if (planetResult.returnFlag < 0) {
        printf("swisseph error: %s\n", serr);
    }

    // array of 6 doubles for longitude, latitude, distance, speed in long., speed in lat., and speed in dist.
    int sigh = 0;
    planetResult.position_longitude = planetParams[sigh++];
    planetResult.position_latitude = planetParams[sigh++];
    planetResult.position_distance = planetParams[sigh++];
    planetResult.speed_longitude = planetParams[sigh++];
    planetResult.speed_latitude = planetParams[sigh++];
    planetResult.speed_distance = planetParams[sigh++];

    return &planetResult;
}