cmake_minimum_required(VERSION 3.4.1)  # for example

set(ANDROID_DISABLE_FORMAT_STRING_CHECKS 1)

file(GLOB SOURCES "../ios/Classes/swisseph/src/*.c")
file(GLOB HEADERS "../ios/Classes/swisseph/src/*.h")

add_library( ephemeris

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             ${HEADERS} ${SOURCES} ../ios/Classes/ephemeris.c)