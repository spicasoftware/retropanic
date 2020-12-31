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