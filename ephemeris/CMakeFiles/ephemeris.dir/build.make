# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.19

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Disable VCS-based implicit rules.
% : %,v


# Disable VCS-based implicit rules.
% : RCS/%


# Disable VCS-based implicit rules.
% : RCS/%,v


# Disable VCS-based implicit rules.
% : SCCS/s.%


# Disable VCS-based implicit rules.
% : s.%


.SUFFIXES: .hpux_make_needs_suffix_list


# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/lharding/projects/retropanic/ephemeris/android

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/lharding/projects/retropanic/ephemeris

# Include any dependencies generated for this target.
include CMakeFiles/ephemeris.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/ephemeris.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/ephemeris.dir/flags.make

CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.o: CMakeFiles/ephemeris.dir/flags.make
CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.o: ios/Classes/ephemeris.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/lharding/projects/retropanic/ephemeris/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.o -c /home/lharding/projects/retropanic/ephemeris/ios/Classes/ephemeris.cpp

CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/lharding/projects/retropanic/ephemeris/ios/Classes/ephemeris.cpp > CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.i

CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/lharding/projects/retropanic/ephemeris/ios/Classes/ephemeris.cpp -o CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.s

# Object files for target ephemeris
ephemeris_OBJECTS = \
"CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.o"

# External object files for target ephemeris
ephemeris_EXTERNAL_OBJECTS =

libephemeris.so: CMakeFiles/ephemeris.dir/ios/Classes/ephemeris.cpp.o
libephemeris.so: CMakeFiles/ephemeris.dir/build.make
libephemeris.so: CMakeFiles/ephemeris.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/lharding/projects/retropanic/ephemeris/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX shared library libephemeris.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ephemeris.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/ephemeris.dir/build: libephemeris.so

.PHONY : CMakeFiles/ephemeris.dir/build

CMakeFiles/ephemeris.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/ephemeris.dir/cmake_clean.cmake
.PHONY : CMakeFiles/ephemeris.dir/clean

CMakeFiles/ephemeris.dir/depend:
	cd /home/lharding/projects/retropanic/ephemeris && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/lharding/projects/retropanic/ephemeris/android /home/lharding/projects/retropanic/ephemeris/android /home/lharding/projects/retropanic/ephemeris /home/lharding/projects/retropanic/ephemeris /home/lharding/projects/retropanic/ephemeris/CMakeFiles/ephemeris.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/ephemeris.dir/depend
