# - Find blackhole installation.
#
# The following are set after the configuration is done:
#
# blackhole_FOUND        - Set to True if blackhole was found.
# blackhole_INCLUDE_DIRS - Include directories
# blackhole_LIBRARIES    - Libraries required to link
#
# User can change the following variable in cache to indicate where
# blackhole is installed.
#
# blackhole            - It can also be set as environemnt variable. The cmake
#                      variable can override the setting in environement
#                      variable. It should be set to the install root directory
#                      of lalib. The header files should be in
#                      ${blackhole}/include and libraries are in ${blackhole}/lib
#
# blackhole_INCLUDE_DIR
# blackhole_LIBRARY     - Specify include dir and library directly.
#

IF(BLACKHOLE)
  SET(blackhole_ROOT_DIR ${BLACKHOLE})
ELSE(BLACKHOLE)
  SET(blackhole_ROOT_DIR $ENV{BLACKHOLE})
ENDIF(BLACKHOLE)

#INCLUDE(MacroFindPackageWithCache)

#MACRO_FIND_PACKAGE_WITH_CACHE(
#  imllib imllib ml/ml_common.h imllib
#  )

#IF(blackhole_FOUND)
  SET(blackhole_INCLUDE_DIR ${blackhole_ROOT_DIR}/src)
  #ENDIF(blackhole_FOUND)

MARK_AS_ADVANCED(blackhole_INCLUDE_DIR)
