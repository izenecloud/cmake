# - Find jma installation.
#
# The following are set after the configuration is done:
#
# izenejma_FOUND        - Set to True if izenejma was found.
# izenejma_INCLUDE_DIRS - Include directories
# izenejma_LIBRARIES    - Libraries required to link
# izenejma_KNOWLEDGE    - Path to jma knowledge directory
# User can change the following variable in cache to indicate where
# lalib is installed.
#
# IZENEJMA            - It can also be set as environemnt variable. The jmake
#                      variable can override the setting in environement
#                      variable. It should be set to the install root directory
#                      of jma. The header files should be in
#                      ${IZENEJMA}/include and libraries are in ${IZENEJMA}/lib
#
# izenejma_INCLUDE_DIR
# izenejma_LIBRARY    - Specify include dir and library directly.
#

# Setup izenejma_ROOT_DIR according to IZENEJMA
IF(IZENEJMA)
  SET(izenejma_ROOT_DIR ${IZENEJMA})
ELSE(IZENEJMA)
  SET(izenejma_ROOT_DIR $ENV{IZENEJMA})
ENDIF(IZENEJMA)

INCLUDE(MacroFindPackageWithCache)
MACRO_FIND_PACKAGE_WITH_CACHE(ijma izenejma ijma/analyzer.h jma)

IF(izenejma_FOUND)
  # set the knowledge directly
  SET(izenejma_KNOWLEDGE ${izenejma_ROOT_DIR}/db/ipadic/bin_utf8)

  IF(izenejma_KNOWLEDGE)
    MESSAGE(STATUS "  Found: ${izenejma_KNOWLEDGE}")
  ELSE(izenejma_KNOWLEDGE)
    SET(izenejma_FOUND FALSE)
    SET(izenejma_INCLUDE_DIR ${izenejma_ROOT_DIR}/include)

    SET(_details "  Failed.")
    IF(${name}_FIND_REQUIRED)
      MESSAGE(FATAL_ERROR "${_details}")
    ELSEIF(NOT ${name}_FIND_QUIETLY)
      MESSAGE(STATUS "${_details}")
    ENDIF(${name}_FIND_REQUIRED)
  ENDIF(izenejma_KNOWLEDGE)

ENDIF(izenejma_FOUND)

MARK_AS_ADVANCED(IZENEJMA izenejma_LIBRARY izenejma_KNOWLEDGE)
