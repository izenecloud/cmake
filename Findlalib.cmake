# - Find la-manager installation.
#
# The following are set after the configuration is done:
#
# lalib_FOUND        - Set to True if lalib was found.
# lalib_INCLUDE_DIRS - Include directories
# lalib_LIBRARIES    - Libraries required to link
#
# User can change the following variable in cache to indicate where
# lalib is installed.
#
# LA_PATH            - It can also be set as environemnt variable. The cmake
#                      variable can override the setting in environement
#                      variable. It should be set to the install root directory
#                      of lalib. The header files should be in
#                      ${LA_PATH}/include and libraries are in ${LA_PATH}/lib
#
# lalib_INCLUDE_DIR
# lalib_LIBRARY     - Specify include dir and library directly.
#

# Setup lalib_ROOT_DIR according to LALIB
IF(LA_PATH)
  SET(lalib_ROOT_DIR ${LA_PATH})
ELSE(LA_PATH)
  SET(lalib_ROOT_DIR $ENV{LA_PATH})
ENDIF(LA_PATH)

INCLUDE(MacroFindPackageWithCache)
MACRO_FIND_PACKAGE_WITH_CACHE(la-manager lalib LA.h la)

SET(lalib_LIBRARY ${lalib_la_LIBRARY}
  CACHE STRING "Path to libraries of lalib")

MARK_AS_ADVANCED(LA_PATH lalib_LIBRARY)