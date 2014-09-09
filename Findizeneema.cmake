# - Find ema installation.
#
# The following are set after the configuration is done:
#
# izeneema_FOUND        - Set to True if izeneema was found.
# izeneema_INCLUDE_DIRS - Include directories
# izeneema_LIBRARIES    - Libraries required to link
# izeneema_KNOWLEDGE    - Path to ema knowledge directory
# User can change the following variable in cache to indicate where
# lalib is installed.
#
# IZENEEMA            - It can also be set as environemnt variable. The emake
#                      variable can override the setting in environement
#                      variable. It should be set to the install root directory
#                      of ema. The header files should be in
#                      ${IZENEEMA}/include and libraries are in ${IZENEEMA}/lib
#
# izeneema_INCLUDE_DIR
# izeneema_LIBRARY    - Specify include dir and library directly.
#

# Setup izeneema_ROOT_DIR according to IZENEEMA
IF(IZENEEMA)
  SET(izeneema_ROOT_DIR ${IZENEEMA})
ELSE(IZENEEMA)
  SET(izeneema_ROOT_DIR $ENV{IZENEEMA})
ENDIF(IZENEEMA)

INCLUDE(MacroFindPackageWithCache)
MACRO_FIND_PACKAGE_WITH_CACHE(iema izeneema ema/analyzer.h ema)

IF(izeneema_FOUND)
  # set the knowledge directly
  SET(izeneema_KNOWLEDGE ${izeneema_ROOT_DIR}/models/postag)

  IF(izeneema_KNOWLEDGE)
    MESSAGE(STATUS "  Found: ${izeneema_KNOWLEDGE}")
  ELSE(izeneema_KNOWLEDGE)
    SET(izeneema_FOUND FALSE)
    SET(izeneema_INCLUDE_DIR ${izeneema_ROOT_DIR}/include)

    SET(_details "  Failed.")
    IF(${name}_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "${_details}")
    ELSEIF(NOT ${name}_FIND_QUIETLY)
      MESSAGE(STATUS "${_details}")
    ENDIF(${name}_FIND_REQUIRED)
  ENDIF(izeneema_KNOWLEDGE)

ENDIF(izeneema_FOUND)

MARK_AS_ADVANCED(IZENEEMA izeneema_LIBRARY izeneema_KNOWLEDGE)
