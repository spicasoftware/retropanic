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
double ephemerisTime(int year, int month, int day, double hour) {
    double tjd_ut = swe_julday(year, month, day, hour, SE_GREG_CAL);
    return tjd_ut + swe_deltat(tjd_ut);
}

typedef struct planetResult {
    char serr[AS_MAXCH];
}

__attribute__((visibility("default"))) __attribute__((used))
void planetInfo(int year, int month, int day, int hour) {
            iflgret = swe_calc_ut(tjd_ut, p, iflag, x2, serr);

             /* if there is a problem, a negative value is returned and an
             * error message is in serr.
             */

            if (iflgret < 0)
                 printf("error: %s\n", serr);
}

__attribute__((visibility("default"))) __attribute__((used))
void planet_info(int year, int month, int day, int hour) {
    char *sp, sdate[AS_MAXCH], snam[40], serr[AS_MAXCH];
    int jday = 1, jmon = 1, jyear = 2000;
    double jut = 0.0;
    double tjd_ut, te, x2[6];
    long iflag, iflgret;
    int p;

    iflag = SEFLG_SPEED;

    while (TRUE) {
        printf("\nDate (d.m.y) ?");
        gets(sdate);

         /* stop if a period . is entered */
        if (*sdate == '.')
            return OK;

        if (sscanf (sdate, "%d%*c%d%*c%d", &jday, &jmon, &jyear) < 1) exit(1);

         /*
         * we have day, month and year and convert to Julian day number
         */

        tjd_ut = swe_julday(jyear, jmon, jday, jut, SE_GREG_CAL);

         /*
         * compute Ephemeris time from Universal time by adding delta_t
         * not required for Swisseph versions smaller than 1.60
         */

        te = tjd_ut + swe_deltat(tjd_ut);

        printf("date: %02d.%02d.%d at 0:00 Universal time\n", jday, jmon, jyear);
        printf("planet \tlongitude\tlatitude\tdistance\tspeed long.\n");

         /*
         * a loop over all planets
         */

        for (p = SE_SUN; p <= SE_CHIRON; p++) {
            if (p == SE_EARTH) continue;

             /*
             * do the coordinate calculation for this planet p
             */

            iflgret = swe_calc_ut(tjd_ut, p, iflag, x2, serr);

             /* if there is a problem, a negative value is returned and an
             * error message is in serr.
             */

            if (iflgret < 0)
                 printf("error: %s\n", serr);
            /*
            * get the name of the planet p
            */

            swe_get_planet_name(p, snam);

            /*
            * print the coordinates
            */

            printf("%10s\t%11.7f\t%10.7f\t%10.7f\t%10.7f\n", snam, x2[0], x2[1], x2[2], x2[3]);
        }
    }

    return OK;
}