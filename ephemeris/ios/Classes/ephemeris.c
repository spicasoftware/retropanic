#include <stdint.h>
#include "swisseph/src/swephexp.h"

int g_init_offset = 0;

/*extern "C"*/ __attribute__((visibility("default"))) __attribute__((used))
int32_t native_add(int32_t x, int32_t y) {
    return x + y + g_init_offset;
}

__attribute__((visibility("default"))) __attribute__((used))
void init() {
    swe_set_ephe_path(NULL);
    g_init_offset = 1337;
}

__attribute__((visibility("default"))) __attribute__((used))
double julianDay(int year, int month, int day, double hour) {
    double tjd_ut = swe_julday(year, month, day, hour, SE_GREG_CAL);
    return tjd_ut; // + swe_deltat(tjd_ut); not necessary, we're using swe_calc_ut
}

typedef struct {
    double longitude;
    double latitude;
    double distance;
} skyPoint;

/**
 * WARNING: THIS! IS! NOT! THREAD! SAFE!
 * Because of how Dart does threading this should be okay as long as in the Dart
 * code you copy your results out of the planetResult struct before calling planetInfo
 * again. This *should* be handled in the Dart wrapper, but this comment is your last
 * warning just in case that gets routed around somehow.
 */
typedef struct {
    skyPoint position;
    skyPoint speed;
    char serr[AS_MAXCH];
} planetResult_t;

planetResult_t planetResult;

__attribute__((visibility("default"))) __attribute__((used))
planetResult_t* planetInfo(int planet, double julianDay) {
    double planetParams[6];
    long iflag = SEFLG_SPEED;
    long iflgret = swe_calc_ut(julianDay, planet, iflag, planetParams, planetResult.serr);

     /* if there is a problem, a negative value is returned and an
     * error message is in serr.
     */

    if (iflgret < 0)
         printf("error: %s\n", planetResult.serr);

    // array of 6 doubles for longitude, latitude, distance, speed in long., speed in lat., and speed in dist.
    int sigh = 0;
    planetResult.position.longitude = planetParams[sigh];
    planetResult.position.latitude = planetParams[sigh++];
    planetResult.position.distance = planetParams[sigh++];
    planetResult.speed.longitude = planetParams[sigh++];
    planetResult.speed.latitude = planetParams[sigh++];
    planetResult.speed.distance = planetParams[sigh++];

    return &planetResult;
}